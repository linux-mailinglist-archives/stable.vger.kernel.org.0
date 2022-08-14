Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AE1592200
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240946AbiHNPmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241309AbiHNPlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:41:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A96220C9;
        Sun, 14 Aug 2022 08:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF8060BC9;
        Sun, 14 Aug 2022 15:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A55AC433D6;
        Sun, 14 Aug 2022 15:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491173;
        bh=/QLmC2S3Y9ckObInugCjVY1KWeEqBnsxxCQOD44T8/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESU3NMTUPDOpRTJp+wm/at+NZsYoNb/XM2c9MS+Ybpt2p5OGycIQ+hRq8+4isqY4l
         OjPLVuzGT1rdNPrmG22UM48fmnkddyqSGWBNI2GKOhcxhRJnEzTxQou1egIpSGPaMT
         wk/dcTk5BeO0CwZmw3pkl/JhGWjT8tCjSPpl+hmtqgJHcEqzMH2HL0DWUlBTqKwvTu
         TwJ/P5vYUBT3CrX+X6FxIfw4APioassN8kdG44qLDYSXuqQHnuijtMbfA3T1BmAVKl
         Gok4yDCqSX2AcPaPZkUsqIrNwBxCoqmkWaE286NvkQOy7dyqBKIO+/RZgyB9FbzIDc
         5IvbIeHmihpKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Li <Frank.Li@nxp.com>, Faqiang Zhu <faqiang.zhu@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, peter.chen@kernel.org,
        pawell@cadence.com, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/46] usb: cdns3 fix use-after-free at workaround 2
Date:   Sun, 14 Aug 2022 11:32:05 -0400
Message-Id: <20220814153247.2378312-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
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
 drivers/usb/cdns3/cdns3-gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index d6d515d598dc..c4f90b124e55 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -625,9 +625,9 @@ static void cdns3_wa2_remove_old_request(struct cdns3_endpoint *priv_ep)
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

