Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B7C38A575
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhETKQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236364AbhETKPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CA076197F;
        Thu, 20 May 2021 09:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503907;
        bh=4NY54SNfUGPrxe5GIQkiXIcyy4aj8Lao/UeOjCbP+/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJC1nVZuhGsYut/nxMmWtiNYJa/wncbKaTwvayVG20K1CreCoS3vCOXK2jL6VYiWj
         dsX1qLAx+lxLssp8oa5XZoACEwbE1/EVmVR4GVYGrQVRswW2zIG0dpEdtPQId8+k//
         oV3xBz5xK2iLtlCin9ZPFILD1UawIkTf59ZU8fTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 400/425] xsk: Simplify detection of empty and full rings
Date:   Thu, 20 May 2021 11:22:49 +0200
Message-Id: <20210520092144.540881853@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 11cc2d21499cabe7e7964389634ed1de3ee91d33 ]

In order to set the correct return flags for poll, the xsk code has to
check if the Rx queue is empty and if the Tx queue is full. This code
was unnecessarily large and complex as it used the functions that are
used to update the local state from the global state (xskq_nb_free and
xskq_nb_avail). Since we are not doing this nor updating any data
dependent on this state, we can simplify the functions. Another
benefit from this is that we can also simplify the xskq_nb_free and
xskq_nb_avail functions in a later commit.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/1576759171-28550-3-git-send-email-magnus.karlsson@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_queue.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index fe96c0d039f2..cf7cbb5dd918 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -245,12 +245,15 @@ static inline void xskq_produce_flush_desc(struct xsk_queue *q)
 
 static inline bool xskq_full_desc(struct xsk_queue *q)
 {
-	return xskq_nb_avail(q, q->nentries) == q->nentries;
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->producer) - READ_ONCE(q->ring->consumer) ==
+		q->nentries;
 }
 
 static inline bool xskq_empty_desc(struct xsk_queue *q)
 {
-	return xskq_nb_free(q, q->prod_tail, q->nentries) == q->nentries;
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->consumer) == READ_ONCE(q->ring->producer);
 }
 
 void xskq_set_umem(struct xsk_queue *q, struct xdp_umem_props *umem_props);
-- 
2.30.2



