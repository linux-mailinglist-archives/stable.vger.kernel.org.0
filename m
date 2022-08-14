Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071FA59230F
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241976AbiHNPw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241280AbiHNPtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:49:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF2011801;
        Sun, 14 Aug 2022 08:35:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 874C3B80B43;
        Sun, 14 Aug 2022 15:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B07C43470;
        Sun, 14 Aug 2022 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491335;
        bh=alwZg7Pm/vtkDLVFTe2uuR2ES6OCPdj8VDhWPiZKH8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTRESsmlrFswBSb9/Y+iCPdoEvkNIhCujnAC8nbCVHT0lzpgCN+gmg753qjxyHgbV
         EbAY7/xJ4L0pwKPtCZdt0q7hq9koYYG4Dg2fcOLd92Ps/7GU3kSKCMwq7/fTSPmIHM
         orbGJDNqqZtI8nkdTjyxfZkM0EvYiHS2Em1OJtkSgfT04Jyhb8DfQDpiw8O21Ip1qO
         Yfxk4Eg8ZVO+uH+n84kk+Usx4EZ6yxiaRxDhkfKZtwvT7PWqKsF6d6+jfv6PJfwpYj
         qn2NziViTjVgS1H2iMf06uyjWWLRRRLQ1ZiEIXlZwbxsD9eqW4+FsqDI8KiNIBmROl
         8J54TXcYU48vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Li <Frank.Li@nxp.com>, Faqiang Zhu <faqiang.zhu@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, pawell@cadence.com,
        peter.chen@kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/21] usb: cdns3 fix use-after-free at workaround 2
Date:   Sun, 14 Aug 2022 11:35:12 -0400
Message-Id: <20220814153531.2379705-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153531.2379705-1-sashal@kernel.org>
References: <20220814153531.2379705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 7d602f30149a117eea260208b1661bc404c21dfd ]

BUG: KFENCE: use-after-free read in __list_del_entry_valid+0x10/0xac

cdns3_wa2_remove_old_request()
{
	...
	kfree(priv_req->request.buf);
	cdns3_gadget_ep_free_request(&priv_ep->endpoint, &priv_req->request);
	list_del_init(&priv_req->list);
	^^^ use after free
	...
}

cdns3_gadget_ep_free_request() free the space pointed by priv_req,
but priv_req is used in the following list_del_init().

This patch move list_del_init() before cdns3_gadget_ep_free_request().

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Faqiang Zhu <faqiang.zhu@nxp.com>
Link: https://lore.kernel.org/r/20220608190430.2814358-1-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 296f2ee1b680..a9399f2b3930 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -549,9 +549,9 @@ static void cdns3_wa2_remove_old_request(struct cdns3_endpoint *priv_ep)
 		trace_cdns3_wa2(priv_ep, "removes eldest request");
 
 		kfree(priv_req->request.buf);
+		list_del_init(&priv_req->list);
 		cdns3_gadget_ep_free_request(&priv_ep->endpoint,
 					     &priv_req->request);
-		list_del_init(&priv_req->list);
 		--priv_ep->wa2_counter;
 
 		if (!chain)
-- 
2.35.1

