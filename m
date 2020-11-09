Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EE92ABB3F
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732534AbgKIN0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:26:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731647AbgKINQl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32FDB22210;
        Mon,  9 Nov 2020 13:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927800;
        bh=xbU1shsLUHH8l0swdQELuObqhCkvZnPvwggRopfm+hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbKbthomOo32hTNwyB65wpTNY0nYv613huiT6J5H/+s0OfhoaDyoEl9BL1m6uNq4y
         6a9X8m6yYE/xu4kj8qC9Yj9eUpsbY3z+Mr55VOg2fGu17TxJkauf/MkuhhnttrdWyT
         PjX6ZtVyeL2SIzMRxV/H5i/ijo0YZP0W69Hw/c0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 025/133] chelsio/chtls: fix always leaking ctrl_skb
Date:   Mon,  9 Nov 2020 13:54:47 +0100
Message-Id: <20201109125031.931203579@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
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
@@ -212,7 +212,7 @@ static struct sk_buff *alloc_ctrl_skb(st
 {
 	if (likely(skb && !skb_shared(skb) && !skb_cloned(skb))) {
 		__skb_trim(skb, 0);
-		refcount_add(2, &skb->users);
+		refcount_inc(&skb->users);
 	} else {
 		skb = alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
 	}


