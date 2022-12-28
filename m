Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A5B65803F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbiL1QQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234479AbiL1QPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:15:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95C61A80B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:13:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84E3C6155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94300C433D2;
        Wed, 28 Dec 2022 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243987;
        bh=GCAwWLTS2dS7azZOv1nhK2HejKNwVOj1082OnAyfARU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rssb0jYTzlh0Qb+9iHNcQaE4sWqzKFJvOX0CgTU6jY3edffvjlqdMu0quYb/E8alM
         xW8bkjMhMlBNC/oC94tvOKvlDPktkXSRXSBWd4AQckKw+0xGeZOm/zpq3WdyVu+E3P
         h12SThD7irSKLJSYAlvqY015aojczuUCqD88l2Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0627/1073] scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails
Date:   Wed, 28 Dec 2022 15:36:55 +0100
Message-Id: <20221228144345.072571960@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 6ec296321ffc..38774a272e62 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2491,6 +2491,7 @@ static int __init fcoe_init(void)
 
 out_free:
 	mutex_unlock(&fcoe_config_mutex);
+	fcoe_transport_detach(&fcoe_sw_transport);
 out_destroy:
 	destroy_workqueue(fcoe_wq);
 	return rc;
-- 
2.35.1



