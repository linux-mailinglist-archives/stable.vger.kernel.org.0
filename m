Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE87D2ABB82
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731812AbgKINJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:09:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731822AbgKINJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:09:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CA192083B;
        Mon,  9 Nov 2020 13:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927361;
        bh=4Vrim/rqDv1Jp7u9rThkC7xLSBYhPB71gHrR0JYwbi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAZaPXbOJYloe9igJONOa6YJIzsLGAkpXil70qgEBx5EgBtZRxA08ny9Eo002OhmG
         MsJV/ETRwFTQYvgfgAyH/9Fin3BQinjEBakIe670+XjSZDikFpDtbrKjhR/V+Eyk/m
         WSTgY/hb4pSuwGwCjMfjDetin7tcOuS5/L15nGKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 06/71] chelsio/chtls: fix always leaking ctrl_skb
Date:   Mon,  9 Nov 2020 13:55:00 +0100
Message-Id: <20201109125020.210069689@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit dbfe394dad33f99cf8458be50483ec40a5d29c34 ]

Correct skb refcount in alloc_ctrl_skb(), causing skb memleak
when chtls_send_abort() called with NULL skb.
it was always leaking the skb, correct it by incrementing skb
refs by one.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Link: https://lore.kernel.org/r/20201102173909.24826-1-vinay.yadav@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -175,7 +175,7 @@ static struct sk_buff *alloc_ctrl_skb(st
 {
 	if (likely(skb && !skb_shared(skb) && !skb_cloned(skb))) {
 		__skb_trim(skb, 0);
-		refcount_add(2, &skb->users);
+		refcount_inc(&skb->users);
 	} else {
 		skb = alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
 	}


