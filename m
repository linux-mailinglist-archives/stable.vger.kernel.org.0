Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAB459E386
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbiHWMWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345057AbiHWMUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:20:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF8BEF9E7;
        Tue, 23 Aug 2022 02:42:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18E3161460;
        Tue, 23 Aug 2022 09:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11710C4314F;
        Tue, 23 Aug 2022 09:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247748;
        bh=/Q5pUORS8PperCMlDsARse1qnrG1sQL5K88clcjPeiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pg8LXWRmqpn1ZDGdbGCO3iY1fatruHAF824O+YMny6/UJvpmwWMYwDsUnNQoD2tcL
         9P2ngIWjW6MjCjXXwBvAUrbcfDfEWdP3EkPOJmvnNF0EPUArNkFHC7/067S/0oH0ku
         rTZ7INWeDMleRqQfWBRlT1O14abKnKlscMH48JZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Li <Frank.Li@nxp.com>,
        Faqiang Zhu <faqiang.zhu@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/158] usb: cdns3 fix use-after-free at workaround 2
Date:   Tue, 23 Aug 2022 10:27:16 +0200
Message-Id: <20220823080050.214993643@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f120da442d43..a37ea946459c 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -655,9 +655,9 @@ static void cdns3_wa2_remove_old_request(struct cdns3_endpoint *priv_ep)
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



