Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BF4521A49
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244384AbiEJNyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243919AbiEJNwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:52:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29706C0D0;
        Tue, 10 May 2022 06:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CB38615E9;
        Tue, 10 May 2022 13:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C61C385A6;
        Tue, 10 May 2022 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189858;
        bh=BEL/QK5o7Uyv5QUi+azeEgIO671K4UQlx+HYxKtUE/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzIP0O5utaP2SNA0m63pxgLNYwLNiCfA3Q5Sjd60BHwOOUrGnODU8eLWYhta+l3zX
         RZBLSqJusZV2aHqvts/ozhSHHf2OBkIXJ+6+jesabWZvej1Hh/Go0YQDzVRt5RIje6
         RiWLr4GyKI/BqVWNPMONdyYrk5sjbFvvfye7y3Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.17 052/140] NFC: netlink: fix sleep in atomic bug when firmware download timeout
Date:   Tue, 10 May 2022 15:07:22 +0200
Message-Id: <20220510130743.109408814@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 4071bf121d59944d5cd2238de0642f3d7995a997 upstream.

There are sleep in atomic bug that could cause kernel panic during
firmware download process. The root cause is that nlmsg_new with
GFP_KERNEL parameter is called in fw_dnld_timeout which is a timer
handler. The call trace is shown below:

BUG: sleeping function called from invalid context at include/linux/sched/mm.h:265
Call Trace:
kmem_cache_alloc_node
__alloc_skb
nfc_genl_fw_download_done
call_timer_fn
__run_timers.part.0
run_timer_softirq
__do_softirq
...

The nlmsg_new with GFP_KERNEL parameter may sleep during memory
allocation process, and the timer handler is run as the result of
a "software interrupt" that should not call any other function
that could sleep.

This patch changes allocation mode of netlink message from GFP_KERNEL
to GFP_ATOMIC in order to prevent sleep in atomic bug. The GFP_ATOMIC
flag makes memory allocation operation could be used in atomic context.

Fixes: 9674da8759df ("NFC: Add firmware upload netlink command")
Fixes: 9ea7187c53f6 ("NFC: netlink: Rename CMD_FW_UPLOAD to CMD_FW_DOWNLOAD")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220504055847.38026-1-duoming@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1244,7 +1244,7 @@ int nfc_genl_fw_download_done(struct nfc
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!msg)
 		return -ENOMEM;
 
@@ -1260,7 +1260,7 @@ int nfc_genl_fw_download_done(struct nfc
 
 	genlmsg_end(msg, hdr);
 
-	genlmsg_multicast(&nfc_genl_family, msg, 0, 0, GFP_KERNEL);
+	genlmsg_multicast(&nfc_genl_family, msg, 0, 0, GFP_ATOMIC);
 
 	return 0;
 


