Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0B96675C1
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbjALOYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbjALOXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:23:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87978559F9
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:15:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4249AB81E6D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89005C433EF;
        Thu, 12 Jan 2023 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532955;
        bh=O/fLqL2fAtz1/8oPm/uxz0QLqWFLOS6rJBvLe904W8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ld1uxoPKA4qbKq7912zR6nWTZHEk3fnbt8l3Hhq2M9bWNbr7z5U/nYsl4wzZNXk4g
         j+BB+AtgXuJx/5yA8sE5aFwxb3GM8fCvLI4vEkm6HuefoVq6uZYyDUy0gdmUdmCn3H
         S4mU+ADWEwsYMyt3suj3doVBZYx8IntJqVleuLxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/783] scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails
Date:   Thu, 12 Jan 2023 14:50:40 +0100
Message-Id: <20230112135539.341251524@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 4155658cee394b22b24c6d64e49247bf26d95b92 ]

fcoe_init() calls fcoe_transport_attach(&fcoe_sw_transport), but when
fcoe_if_init() fails, &fcoe_sw_transport is not detached and leaves freed
&fcoe_sw_transport on fcoe_transports list. This causes panic when
reinserting module.

 BUG: unable to handle page fault for address: fffffbfff82e2213
 RIP: 0010:fcoe_transport_attach+0xe1/0x230 [libfcoe]
 Call Trace:
  <TASK>
  do_one_initcall+0xd0/0x4e0
  load_module+0x5eee/0x7210
  ...

Fixes: 78a582463c1e ("[SCSI] fcoe: convert fcoe.ko to become an fcoe transport provider driver")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221115092442.133088-1-chenzhongjin@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fcoe/fcoe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 0f9274960dc6..30afcbbe1f86 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2504,6 +2504,7 @@ static int __init fcoe_init(void)
 
 out_free:
 	mutex_unlock(&fcoe_config_mutex);
+	fcoe_transport_detach(&fcoe_sw_transport);
 out_destroy:
 	destroy_workqueue(fcoe_wq);
 	return rc;
-- 
2.35.1



