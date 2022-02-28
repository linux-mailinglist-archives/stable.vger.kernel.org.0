Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D576E4C75CA
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236874AbiB1R41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240797AbiB1Ryp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603AA5371F;
        Mon, 28 Feb 2022 09:43:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFA20608D5;
        Mon, 28 Feb 2022 17:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0169BC340F1;
        Mon, 28 Feb 2022 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070229;
        bh=6dmsWtF2WF6CEy7yiT59gPr76gbVM+Z8NfW08yZAGbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUXTwfcXnEdrTRsRU6DikCqruPKEQIuMHjeObtVU6H1VazOsWGppreuKA6nfHsxTp
         PgIHzHnTQnw/7aMn8DXbTEfU29+8UgA+Xrgmknkc5ptVsI3Bmkzlirwa/6viivmRy0
         fU4p6QYbnEF49eETpV3BIB0++X1VFbiy4tCMeEA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>
Subject: [PATCH 5.16 033/164] ping: remove pr_err from ping_lookup
Date:   Mon, 28 Feb 2022 18:23:15 +0100
Message-Id: <20220228172403.242099098@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit cd33bdcbead882c2e58fdb4a54a7bd75b610a452 upstream.

As Jakub noticed, prints should be avoided on the datapath.
Also, as packets would never come to the else branch in
ping_lookup(), remove pr_err() from ping_lookup().

Fixes: 35a79e64de29 ("ping: fix the dif and sdif check in ping_lookup")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/1ef3f2fcd31bd681a193b1fcf235eee1603819bd.1645674068.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ping.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -187,7 +187,6 @@ static struct sock *ping_lookup(struct n
 			 (int)ident, &ipv6_hdr(skb)->daddr, dif);
 #endif
 	} else {
-		pr_err("ping: protocol(%x) is not supported\n", ntohs(skb->protocol));
 		return NULL;
 	}
 


