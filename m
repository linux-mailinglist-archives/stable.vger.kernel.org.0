Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B96419C25
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbhI0RZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:25:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237802AbhI0RXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99FCD6136F;
        Mon, 27 Sep 2021 17:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762909;
        bh=YdKmW74Bx+an5TB/qALyKl2Log0GvXtCp2YzBtllF5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1n1tBWRtItEX43GkLzgDRvyrFJ4LeBDE0S718sjDmgfhSUuOkRl6ChP5DqbaTUnPx
         cdcbcftOKxXuH9nBVrK9XL1JJ7gdw6jTgueKjLhDHqgh6G5N/P9yrO9qnHcrAagDas
         E5IO8kijSaqHUICL/213dh4Dk0/jK1/qsr/a7+cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <Dai.Ngo@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 054/162] NLM: Fix svcxdr_encode_owner()
Date:   Mon, 27 Sep 2021 19:01:40 +0200
Message-Id: <20210927170235.363903954@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 89c485c7a3ecbc2ebd568f9c9c2edf3a8cf7485b ]

Dai Ngo reports that, since the XDR overhaul, the NLM server crashes
when the TEST procedure wants to return NLM_DENIED. There is a bug
in svcxdr_encode_owner() that none of our standard test cases found.

Replace the open-coded function with a call to an appropriate
pre-fabricated XDR helper.

Reported-by: Dai Ngo <Dai.Ngo@oracle.com>
Fixes: a6a63ca5652e ("lockd: Common NLM XDR helpers")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcxdr.h | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/lockd/svcxdr.h b/fs/lockd/svcxdr.h
index c69a0bb76c94..4f1a451da5ba 100644
--- a/fs/lockd/svcxdr.h
+++ b/fs/lockd/svcxdr.h
@@ -134,18 +134,9 @@ svcxdr_decode_owner(struct xdr_stream *xdr, struct xdr_netobj *obj)
 static inline bool
 svcxdr_encode_owner(struct xdr_stream *xdr, const struct xdr_netobj *obj)
 {
-	unsigned int quadlen = XDR_QUADLEN(obj->len);
-	__be32 *p;
-
-	if (xdr_stream_encode_u32(xdr, obj->len) < 0)
-		return false;
-	p = xdr_reserve_space(xdr, obj->len);
-	if (!p)
+	if (obj->len > XDR_MAX_NETOBJ)
 		return false;
-	p[quadlen - 1] = 0;	/* XDR pad */
-	memcpy(p, obj->data, obj->len);
-
-	return true;
+	return xdr_stream_encode_opaque(xdr, obj->data, obj->len) > 0;
 }
 
 #endif /* _LOCKD_SVCXDR_H_ */
-- 
2.33.0



