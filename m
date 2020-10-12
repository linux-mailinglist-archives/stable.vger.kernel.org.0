Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F21A28B6F1
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731315AbgJLNjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731286AbgJLNiy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFDBD206D9;
        Mon, 12 Oct 2020 13:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509933;
        bh=rvnjSrMEECJgoM3x7gvKWcniaay8WsK1fAvGitthpDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOvoUwGVWQM1PfypclrAMefm6RuWcVKVqCIOlCd7kcb+OOrOwTGrSpCxg3Bg6o/+t
         T/siM4uVaTBMOU8ojhZBZn4ZYyIStZgDImWnNUOfQR4tVuaFAD3bXVQwgZOgtZycRF
         Kwfppg57QNPfe/4thep1gB1H0fnP8bkPdrM3Vpu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.19 20/49] xfrmi: drop ignore_df check before updating pmtu
Date:   Mon, 12 Oct 2020 15:27:06 +0200
Message-Id: <20201012132630.392304657@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
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
@@ -293,7 +293,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct
 	}
 
 	mtu = dst_mtu(dst);
-	if (!skb->ignore_df && skb->len > mtu) {
+	if (skb->len > mtu) {
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->protocol == htons(ETH_P_IPV6)) {


