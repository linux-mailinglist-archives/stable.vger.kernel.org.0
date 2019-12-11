Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D1C11B4EE
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfLKPXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbfLKPXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B0B2073D;
        Wed, 11 Dec 2019 15:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077820;
        bh=1W/yuzsqPKUXIgw8tbPznp5CX6Nft+yes7pZOcKigjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7xQM8HZsIxBkJH9/uqTKIHoJZ0Kj+DV7YO/SLExFiZOOXbz2Jrtfu1ffaDOeGkah
         zdJVucH4VjxvrMJQFnMmb/eeuolUCC/4l6uapenhzUPyzEdYKiw0Ju5q6YfglQzeU2
         qaPluNC4jYFui6Ke0CjzLLW4zSwgXy/SjlSZ8SIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Audykowicz <jakub.audykowicz@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 182/243] sctp: frag_point sanity check
Date:   Wed, 11 Dec 2019 16:05:44 +0100
Message-Id: <20191211150351.455453924@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Audykowicz <jakub.audykowicz@gmail.com>

[ Upstream commit afd0a8006e98b1890908f81746c94ca5dae29d7c ]

If for some reason an association's fragmentation point is zero,
sctp_datamsg_from_user will try to endlessly try to divide a message
into zero-sized chunks. This eventually causes kernel panic due to
running out of memory.

Although this situation is quite unlikely, it has occurred before as
reported. I propose to add this simple last-ditch sanity check due to
the severity of the potential consequences.

Signed-off-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/sctp.h | 5 +++++
 net/sctp/chunk.c        | 6 ++++++
 net/sctp/socket.c       | 3 +--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index ab9242e51d9e0..2abbc15824af9 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -620,4 +620,9 @@ static inline bool sctp_transport_pmtu_check(struct sctp_transport *t)
 	return false;
 }
 
+static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 datasize)
+{
+	return sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT, datasize);
+}
+
 #endif /* __net_sctp_h__ */
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index ce8087846f059..d2048de86e7c2 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -191,6 +191,12 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	 * the packet
 	 */
 	max_data = asoc->frag_point;
+	if (unlikely(!max_data)) {
+		max_data = sctp_min_frag_point(sctp_sk(asoc->base.sk),
+					       sctp_datachk_len(&asoc->stream));
+		pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data to default minimum (%Zu)",
+				    __func__, asoc, max_data);
+	}
 
 	/* If the the peer requested that we authenticate DATA chunks
 	 * we need to account for bundling of the AUTH chunks along with
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index e7a11cd7633f5..95f9068b85497 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3328,8 +3328,7 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 		__u16 datasize = asoc ? sctp_datachk_len(&asoc->stream) :
 				 sizeof(struct sctp_data_chunk);
 
-		min_len = sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT,
-					   datasize);
+		min_len = sctp_min_frag_point(sp, datasize);
 		max_len = SCTP_MAX_CHUNK_LEN - datasize;
 
 		if (val < min_len || val > max_len)
-- 
2.20.1



