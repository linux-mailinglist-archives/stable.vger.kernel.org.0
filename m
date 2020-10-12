Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14E228B7D7
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389789AbgJLNp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389711AbgJLNpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BA9C2226B;
        Mon, 12 Oct 2020 13:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510285;
        bh=wePNkQv9o5UWyIChMcyLeEgOxui2j6cLkgOIcvrBYs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNgtR2ddSaLvM5fe7PxGosC8f6vJNEbv8zRz5JubfDX2HAH4CEZRiQIlddUMBVXSg
         eKypXq0ImAHi8LP981cR/Jiakqc4oqsnkny3CiPpwyPFClEbCjPkIpS+2pikXrgi1Q
         2yDGCpflqcMnPvdCHYZ4pdsTrZFucvnwo8uZ1Tc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.8 034/124] xfrmi: drop ignore_df check before updating pmtu
Date:   Mon, 12 Oct 2020 15:30:38 +0200
Message-Id: <20201012133148.500496559@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

commit 45a36a18d01907710bad5258d81f76c18882ad88 upstream.

xfrm interfaces currently test for !skb->ignore_df when deciding
whether to update the pmtu on the skb's dst. Because of this, no pmtu
exception is created when we do something like:

    ping -s 1438 <dest>

By dropping this check, the pmtu exception will be created and the
next ping attempt will work.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -292,7 +292,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct
 	}
 
 	mtu = dst_mtu(dst);
-	if (!skb->ignore_df && skb->len > mtu) {
+	if (skb->len > mtu) {
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->protocol == htons(ETH_P_IPV6)) {


