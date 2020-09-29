Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B45127CB4E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbgI2M0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729645AbgI2Ldc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D206923B9B;
        Tue, 29 Sep 2020 11:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378822;
        bh=zfh1yQvoSMT8e6XSBmOpS1/gJtYedwcqb2MkD/f3h3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrKhCCSdP6vd3oMLxYSOfv8UuxWLikK4+p/he0JkIOy+efJvzhquRVJy42jJO+3Xy
         uIW363qUKdie+mmxvnEQ3w3K7L6Pt9YnvoWYnq6SQWKWVfDufYAHFKVtd5JdwthGTA
         DiqA56ZSACCgjfGZD6QdAagjOORA/0CzMDWH9eN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Safonov <insafonov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 152/245] staging:r8188eu: avoid skb_clone for amsdu to msdu conversion
Date:   Tue, 29 Sep 2020 13:00:03 +0200
Message-Id: <20200929105954.380637600@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Safonov <insafonov@gmail.com>

[ Upstream commit 628cbd971a927abe6388d44320e351c337b331e4 ]

skb clones use same data buffer,
so tail of one skb is corrupted by beginning of next skb.

Signed-off-by: Ivan Safonov <insafonov@gmail.com>
Link: https://lore.kernel.org/r/20200423191404.12028-1-insafonov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 17b4b9257b495..0ddf41b5a734a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -1535,21 +1535,14 @@ static int amsdu_to_msdu(struct adapter *padapter, struct recv_frame *prframe)
 
 		/* Allocate new skb for releasing to upper layer */
 		sub_skb = dev_alloc_skb(nSubframe_Length + 12);
-		if (sub_skb) {
-			skb_reserve(sub_skb, 12);
-			skb_put_data(sub_skb, pdata, nSubframe_Length);
-		} else {
-			sub_skb = skb_clone(prframe->pkt, GFP_ATOMIC);
-			if (sub_skb) {
-				sub_skb->data = pdata;
-				sub_skb->len = nSubframe_Length;
-				skb_set_tail_pointer(sub_skb, nSubframe_Length);
-			} else {
-				DBG_88E("skb_clone() Fail!!! , nr_subframes=%d\n", nr_subframes);
-				break;
-			}
+		if (!sub_skb) {
+			DBG_88E("dev_alloc_skb() Fail!!! , nr_subframes=%d\n", nr_subframes);
+			break;
 		}
 
+		skb_reserve(sub_skb, 12);
+		skb_put_data(sub_skb, pdata, nSubframe_Length);
+
 		subframes[nr_subframes++] = sub_skb;
 
 		if (nr_subframes >= MAX_SUBFRAME_COUNT) {
-- 
2.25.1



