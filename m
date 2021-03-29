Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7EC34C95B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhC2I3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233749AbhC2I0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:26:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA252619CA;
        Mon, 29 Mar 2021 08:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006353;
        bh=+bsrpx4cNVUktMcDSEJnM3RMt0AKF3D62/wDJ/q8e/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3I9X7LKS1hjqqgzqKOHoqX0FmfCWaJa4gDX2naZ54vv6bSeWATZnGTPULxphQBa3
         DCUtAsfV3/nkK9jcB7S1hkFk0dfDdpflGSyHRNeWPe2iMtArLSHNVVukRLid3KkApw
         Z5RYw2g9JrRwVlesjt8iubNetsmWDnrpJbV1JJ/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: [PATCH 5.10 209/221] mm/memcg: fix 5.10 backport of splitting page memcg
Date:   Mon, 29 Mar 2021 09:59:00 +0200
Message-Id: <20210329075636.083883684@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

The straight backport of 5.12's e1baddf8475b ("mm/memcg: set memcg when
splitting page") works fine in 5.11, but turned out to be wrong for 5.10:
because that relies on a separate flag, which must also be set for the
memcg to be recognized and uncharged and cleared when freeing. Fix that.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3274,13 +3274,17 @@ void obj_cgroup_uncharge(struct obj_cgro
 void split_page_memcg(struct page *head, unsigned int nr)
 {
 	struct mem_cgroup *memcg = head->mem_cgroup;
+	int kmemcg = PageKmemcg(head);
 	int i;
 
 	if (mem_cgroup_disabled() || !memcg)
 		return;
 
-	for (i = 1; i < nr; i++)
+	for (i = 1; i < nr; i++) {
 		head[i].mem_cgroup = memcg;
+		if (kmemcg)
+			__SetPageKmemcg(head + i);
+	}
 	css_get_many(&memcg->css, nr - 1);
 }
 


