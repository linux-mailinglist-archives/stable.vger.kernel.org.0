Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA9923A415
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgHCMWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbgHCMWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B174F204EC;
        Mon,  3 Aug 2020 12:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457361;
        bh=6/KZZcuNPBEWPDe5p9X9eJ+q6DkOWYt2qsk2p6v6cMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYV6+jk20tjK+4ZFt/E5QrBCh5ojP4gjg1LzOE6M7bEBa1zE22y567u0gWVKnnyW0
         aLCQ5Iaw/TO6AgKoDOqyAoSvYf89b3Ixpsuazsc3ybDACvVsLplr71HNXnjnYPKxVV
         qeAAVSHKmQK9RAuSMaw/33ptDkNOHXG/V4qHj4PM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 040/120] xfrm: Fix crash when the hold queue is used.
Date:   Mon,  3 Aug 2020 14:18:18 +0200
Message-Id: <20200803121904.776077829@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 101dde4207f1daa1fda57d714814a03835dccc3f ]

The commits "xfrm: Move dst->path into struct xfrm_dst"
and "net: Create and use new helper xfrm_dst_child()."
changed xfrm bundle handling under the assumption
that xdst->path and dst->child are not a NULL pointer
only if dst->xfrm is not a NULL pointer. That is true
with one exception. If the xfrm hold queue is used
to wait until a SA is installed by the key manager,
we create a dummy bundle without a valid dst->xfrm
pointer. The current xfrm bundle handling crashes
in that case. Fix this by extending the NULL check
of dst->xfrm with a test of the DST_XFRM_QUEUE flag.

Fixes: 0f6c480f23f4 ("xfrm: Move dst->path into struct xfrm_dst")
Fixes: b92cf4aab8e6 ("net: Create and use new helper xfrm_dst_child().")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 31ff059b42904..7b616e45fbfcc 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -946,7 +946,7 @@ struct xfrm_dst {
 static inline struct dst_entry *xfrm_dst_path(const struct dst_entry *dst)
 {
 #ifdef CONFIG_XFRM
-	if (dst->xfrm) {
+	if (dst->xfrm || (dst->flags & DST_XFRM_QUEUE)) {
 		const struct xfrm_dst *xdst = (const struct xfrm_dst *) dst;
 
 		return xdst->path;
@@ -958,7 +958,7 @@ static inline struct dst_entry *xfrm_dst_path(const struct dst_entry *dst)
 static inline struct dst_entry *xfrm_dst_child(const struct dst_entry *dst)
 {
 #ifdef CONFIG_XFRM
-	if (dst->xfrm) {
+	if (dst->xfrm || (dst->flags & DST_XFRM_QUEUE)) {
 		struct xfrm_dst *xdst = (struct xfrm_dst *) dst;
 		return xdst->child;
 	}
-- 
2.25.1



