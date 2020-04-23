Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC851B692D
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbgDWXU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:20:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48596 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728206AbgDWXGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:33 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvM-0004be-0R; Fri, 24 Apr 2020 00:06:28 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-00E6js-2N; Fri, 24 Apr 2020 00:06:27 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>
Date:   Fri, 24 Apr 2020 00:04:59 +0100
Message-ID: <lsq.1587683028.807471934@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 072/245] netfilter: nf_tables: validate
 NFT_DATA_VALUE after nft_data_init()
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 0d2c96af797ba149e559c5875c0151384ab6dd14 upstream.

Userspace might bogusly sent NFT_DATA_VERDICT in several netlink
attributes that assume NFT_DATA_VALUE. Moreover, make sure that error
path invokes nft_data_release() to decrement the reference count on the
chain object.

Fixes: 96518518cc41 ("netfilter: add nftables")
Fixes: 0f3cd9b36977 ("netfilter: nf_tables: add range expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[bwh: Backported to 3.16:
 - Drop changes in nft_get_set_elem(), nft_range
 - Call nft_data_uninit() instead of nft_data_release()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -86,7 +86,7 @@ static int nft_bitwise_init(const struct
 	err = nft_data_init(NULL, &priv->mask, &d1, tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
 		return err;
-	if (d1.len != priv->len) {
+	if (d1.type != NFT_DATA_VALUE || d1.len != priv->len) {
 		err = -EINVAL;
 		goto err1;
 	}
@@ -94,7 +94,7 @@ static int nft_bitwise_init(const struct
 	err = nft_data_init(NULL, &priv->xor, &d2, tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
 		goto err1;
-	if (d2.len != priv->len) {
+	if (d2.type != NFT_DATA_VALUE || d2.len != priv->len) {
 		err = -EINVAL;
 		goto err2;
 	}
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -84,6 +84,12 @@ static int nft_cmp_init(const struct nft
 	if (desc.len > U8_MAX)
 		return -ERANGE;
 
+	if (desc.type != NFT_DATA_VALUE) {
+		err = -EINVAL;
+		nft_data_uninit(&priv->data, desc.type);
+		return err;
+	}
+
 	priv->len = desc.len;
 	return 0;
 }

