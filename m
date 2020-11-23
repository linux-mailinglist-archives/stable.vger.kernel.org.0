Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131062C07D7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733246AbgKWMok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733239AbgKWMoh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6231520888;
        Mon, 23 Nov 2020 12:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135474;
        bh=UVLGGAn1X4Y5UwlsUVyRRaVcLVlbaVyg0i8DyPEmP6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zstd6z44NAepPeyaOV+XObVB907oPeWcvv3gFsQ8hcC1lEPSrMVhR8+N5WYI+ijkw
         FVLVes2IeOSpqsfPPB0eRUKJukQ8nmvbPvvzPptZteQu16inUWA56XIMI8UwVNlKXy
         MFpvSJFzEeqUd0jX6HdxvjtEuhMAAl8dwDuWmbaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 052/252] net/tls: Fix wrong record sn in async mode of device resync
Date:   Mon, 23 Nov 2020 13:20:02 +0100
Message-Id: <20201123121838.099930457@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 138559b9f99d3b6b1d5e75c78facc067a23871c6 ]

In async_resync mode, we log the TCP seq of records until the async request
is completed.  Later, in case one of the logged seqs matches the resync
request, we return it, together with its record serial number.  Before this
fix, we mistakenly returned the serial number of the current record
instead.

Fixes: ed9b7646b06a ("net/tls: Add asynchronous resync")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
Link: https://lore.kernel.org/r/20201115131448.2702-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h    |   16 +++++++++++++++-
 net/tls/tls_device.c |   37 +++++++++++++++++++++++++++----------
 2 files changed, 42 insertions(+), 11 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -300,7 +300,8 @@ enum tls_offload_sync_type {
 #define TLS_DEVICE_RESYNC_ASYNC_LOGMAX		13
 struct tls_offload_resync_async {
 	atomic64_t req;
-	u32 loglen;
+	u16 loglen;
+	u16 rcd_delta;
 	u32 log[TLS_DEVICE_RESYNC_ASYNC_LOGMAX];
 };
 
@@ -471,6 +472,18 @@ static inline bool tls_bigint_increment(
 	return (i == -1);
 }
 
+static inline void tls_bigint_subtract(unsigned char *seq, int  n)
+{
+	u64 rcd_sn;
+	__be64 *p;
+
+	BUILD_BUG_ON(TLS_MAX_REC_SEQ_SIZE != 8);
+
+	p = (__be64 *)seq;
+	rcd_sn = be64_to_cpu(*p);
+	*p = cpu_to_be64(rcd_sn - n);
+}
+
 static inline struct tls_context *tls_get_ctx(const struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -639,6 +652,7 @@ tls_offload_rx_resync_async_request_star
 	atomic64_set(&rx_ctx->resync_async->req, ((u64)ntohl(seq) << 32) |
 		     ((u64)len << 16) | RESYNC_REQ | RESYNC_REQ_ASYNC);
 	rx_ctx->resync_async->loglen = 0;
+	rx_ctx->resync_async->rcd_delta = 0;
 }
 
 static inline void
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -694,36 +694,51 @@ static void tls_device_resync_rx(struct
 
 static bool
 tls_device_rx_resync_async(struct tls_offload_resync_async *resync_async,
-			   s64 resync_req, u32 *seq)
+			   s64 resync_req, u32 *seq, u16 *rcd_delta)
 {
 	u32 is_async = resync_req & RESYNC_REQ_ASYNC;
 	u32 req_seq = resync_req >> 32;
 	u32 req_end = req_seq + ((resync_req >> 16) & 0xffff);
+	u16 i;
+
+	*rcd_delta = 0;
 
 	if (is_async) {
+		/* shouldn't get to wraparound:
+		 * too long in async stage, something bad happened
+		 */
+		if (WARN_ON_ONCE(resync_async->rcd_delta == USHRT_MAX))
+			return false;
+
 		/* asynchronous stage: log all headers seq such that
 		 * req_seq <= seq <= end_seq, and wait for real resync request
 		 */
-		if (between(*seq, req_seq, req_end) &&
+		if (before(*seq, req_seq))
+			return false;
+		if (!after(*seq, req_end) &&
 		    resync_async->loglen < TLS_DEVICE_RESYNC_ASYNC_LOGMAX)
 			resync_async->log[resync_async->loglen++] = *seq;
 
+		resync_async->rcd_delta++;
+
 		return false;
 	}
 
 	/* synchronous stage: check against the logged entries and
 	 * proceed to check the next entries if no match was found
 	 */
-	while (resync_async->loglen) {
-		if (req_seq == resync_async->log[resync_async->loglen - 1] &&
-		    atomic64_try_cmpxchg(&resync_async->req,
-					 &resync_req, 0)) {
-			resync_async->loglen = 0;
+	for (i = 0; i < resync_async->loglen; i++)
+		if (req_seq == resync_async->log[i] &&
+		    atomic64_try_cmpxchg(&resync_async->req, &resync_req, 0)) {
+			*rcd_delta = resync_async->rcd_delta - i;
 			*seq = req_seq;
+			resync_async->loglen = 0;
+			resync_async->rcd_delta = 0;
 			return true;
 		}
-		resync_async->loglen--;
-	}
+
+	resync_async->loglen = 0;
+	resync_async->rcd_delta = 0;
 
 	if (req_seq == *seq &&
 	    atomic64_try_cmpxchg(&resync_async->req,
@@ -741,6 +756,7 @@ void tls_device_rx_resync_new_rec(struct
 	u32 sock_data, is_req_pending;
 	struct tls_prot_info *prot;
 	s64 resync_req;
+	u16 rcd_delta;
 	u32 req_seq;
 
 	if (tls_ctx->rx_conf != TLS_HW)
@@ -786,8 +802,9 @@ void tls_device_rx_resync_new_rec(struct
 			return;
 
 		if (!tls_device_rx_resync_async(rx_ctx->resync_async,
-						resync_req, &seq))
+						resync_req, &seq, &rcd_delta))
 			return;
+		tls_bigint_subtract(rcd_sn, rcd_delta);
 		break;
 	}
 


