Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAB1681195
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbjA3OO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237335AbjA3OOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:14:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330E71BAEC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:14:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8673B80DEB
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C064C433D2;
        Mon, 30 Jan 2023 14:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088089;
        bh=aa5C0dAsOQZTYhUI+KJVLBVc9xEz97J7qqmOkoHQV64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4C6loF1Yc8JQ/bA3CZNCAdXoj404ZO9MC7iXiYJPISdGTeyi+CbU88h6d0Db9ZUP
         hmMDIWen0ErnShx70ifob6nD8ozL26EGqh0Yb66A/pxRgU33jV9FfPW75Bel6GUVOs
         INBVdUePRfhwj5XpR2Ul5gKHnD38nJV3rF1ouG9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yihang Li <liyihang9@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/204] scsi: hisi_sas: Set a port invalid only if there are no devices attached when refreshing port id
Date:   Mon, 30 Jan 2023 14:51:17 +0100
Message-Id: <20230130134321.374698245@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit f58c89700630da6554b24fd3df293a24874c10c1 ]

Currently the driver sets the port invalid if one phy in the port is not
enabled, which may cause issues in expander situation. In directly attached
situation, if phy up doesn't occur in time when refreshing port id, the
port is incorrectly set to invalid which will also cause disk lost.

Therefore set a port invalid only if there are no devices attached to the
port.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1672805000-141102-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9515c45affa5..7d93783c09a5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1414,7 +1414,7 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
 				device->linkrate = phy->sas_phy.linkrate;
 
 			hisi_hba->hw->setup_itct(hisi_hba, sas_dev);
-		} else
+		} else if (!port->port_attached)
 			port->id = 0xff;
 	}
 }
-- 
2.39.0



