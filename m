Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1727727C72A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbgI2Lvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730839AbgI2LsL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 335BA208B8;
        Tue, 29 Sep 2020 11:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380082;
        bh=h8laDXD65Ci5PGIMfpaGIeC5PU1A+ZMVXPI564ALMNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ate2S6X2D47+YrRMnwfzHQdYM/CEZQkw4GV+mPXbeM2tsfhXFkJRMB9EugK+O/x9C
         9JvLCzomXu28DO95jbCWjAk/afhs6WAY744iu2Db3QCutrFlrmYIqAGU5WnjayqeoW
         wFa4oG1HWwhq6rsITnPRE4G4mF6AstGxRtjWgpcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 30/99] netfilter: ctnetlink: fix mark based dump filtering regression
Date:   Tue, 29 Sep 2020 13:01:13 +0200
Message-Id: <20200929105931.216982070@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Willi <martin@strongswan.org>

[ Upstream commit 6c0d95d1238d944fe54f0bbfc7ec017d78435daa ]

conntrack mark based dump filtering may falsely skip entries if a mask
is given: If the mask-based check does not filter out the entry, the
else-if check is always true and compares the mark without considering
the mask. The if/else-if logic seems wrong.

Given that the mask during filter setup is implicitly set to 0xffffffff
if not specified explicitly, the mark filtering flags seem to just
complicate things. Restore the previously used approach by always
matching against a zero mask is no filter mark is given.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Signed-off-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d65846aa80591..c3a4214dc9588 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -851,7 +851,6 @@ static int ctnetlink_done(struct netlink_callback *cb)
 }
 
 struct ctnetlink_filter {
-	u_int32_t cta_flags;
 	u8 family;
 
 	u_int32_t orig_flags;
@@ -906,10 +905,6 @@ static int ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
 					 struct nf_conntrack_zone *zone,
 					 u_int32_t flags);
 
-/* applied on filters */
-#define CTA_FILTER_F_CTA_MARK			(1 << 0)
-#define CTA_FILTER_F_CTA_MARK_MASK		(1 << 1)
-
 static struct ctnetlink_filter *
 ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 {
@@ -930,14 +925,10 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	if (cda[CTA_MARK]) {
 		filter->mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
-		filter->cta_flags |= CTA_FILTER_FLAG(CTA_MARK);
-
-		if (cda[CTA_MARK_MASK]) {
+		if (cda[CTA_MARK_MASK])
 			filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
-			filter->cta_flags |= CTA_FILTER_FLAG(CTA_MARK_MASK);
-		} else {
+		else
 			filter->mark.mask = 0xffffffff;
-		}
 	} else if (cda[CTA_MARK_MASK]) {
 		err = -EINVAL;
 		goto err_filter;
@@ -1117,11 +1108,7 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if ((filter->cta_flags & CTA_FILTER_FLAG(CTA_MARK_MASK)) &&
-	    (ct->mark & filter->mark.mask) != filter->mark.val)
-		goto ignore_entry;
-	else if ((filter->cta_flags & CTA_FILTER_FLAG(CTA_MARK)) &&
-		 ct->mark != filter->mark.val)
+	if ((ct->mark & filter->mark.mask) != filter->mark.val)
 		goto ignore_entry;
 #endif
 
-- 
2.25.1



