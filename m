Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441312F1409
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733211AbhAKNS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:18:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733207AbhAKNSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74AB72251F;
        Mon, 11 Jan 2021 13:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371094;
        bh=Lq/MXugNPfkg9GR7Mk//n4bW8MNNh796E1wXtzobYCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LV5cHlLYUn3VJaTfHEaxhryJ5LCokWqLuZ2r2FVbB5nlBwEsXf++6pi6mFZ961xC9
         +3QbV7YemEcvC21BF7aSUE4uM335YdRpd1o4DFjHFPt2veYEai6BoEkBH6svYxHgQU
         lcbOMwdvUmqKaonqlxQGS5teqqVZROk2D20Mh5no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 140/145] netfilter: nft_dynset: report EOPNOTSUPP on missing set feature
Date:   Mon, 11 Jan 2021 14:02:44 +0100
Message-Id: <20210111130055.236590459@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 95cd4bca7b1f4a25810f3ddfc5e767fb46931789 upstream.

If userspace requests a feature which is not available the original set
definition, then bail out with EOPNOTSUPP. If userspace sends
unsupported dynset flags (new feature not supported by this kernel),
then report EOPNOTSUPP to userspace. EINVAL should be only used to
report malformed netlink messages from userspace.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_dynset.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -123,7 +123,7 @@ static int nft_dynset_init(const struct
 		u32 flags = ntohl(nla_get_be32(tb[NFTA_DYNSET_FLAGS]));
 
 		if (flags & ~NFT_DYNSET_F_INV)
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		if (flags & NFT_DYNSET_F_INV)
 			priv->invert = true;
 	}
@@ -156,7 +156,7 @@ static int nft_dynset_init(const struct
 	timeout = 0;
 	if (tb[NFTA_DYNSET_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
-			return -EINVAL;
+			return -EOPNOTSUPP;
 
 		err = nf_msecs_to_jiffies64(tb[NFTA_DYNSET_TIMEOUT], &timeout);
 		if (err)
@@ -170,7 +170,7 @@ static int nft_dynset_init(const struct
 
 	if (tb[NFTA_DYNSET_SREG_DATA] != NULL) {
 		if (!(set->flags & NFT_SET_MAP))
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		if (set->dtype == NFT_DATA_VERDICT)
 			return -EOPNOTSUPP;
 


