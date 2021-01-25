Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74D5302AD1
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbhAYSxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731266AbhAYSxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E9820719;
        Mon, 25 Jan 2021 18:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600788;
        bh=hd8DWQ87NPnbKcvlSfisChFaqcQXks0WXP7Ym5bLg10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYlBSWMBs87ZS7ozg2P2od9vxc2KmEfMs2+TEUU1NeKs2sS0Nf5S7VbS2YgVZkRJe
         ZKV2PIPAquFoeR7MSHq8g9q21hB+NFo8SxFhR4MROhhK4U6rUTDhEZ5crxAyofcluy
         2Gu3El1njNO0nTEPK3x/8iL1STWwLKWMPKG8gFso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 124/199] mm: memcg: fix memcg file_dirty numa stat
Date:   Mon, 25 Jan 2021 19:39:06 +0100
Message-Id: <20210125183221.451554920@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

commit 8a8792f600abacd7e1b9bb667759dca1c153f64c upstream.

The kernel updates the per-node NR_FILE_DIRTY stats on page migration
but not the memcg numa stats.

That was not an issue until recently the commit 5f9a4f4a7096 ("mm:
memcontrol: add the missing numa_stat interface for cgroup v2") exposed
numa stats for the memcg.

So fix the file_dirty per-memcg numa stat.

Link: https://lkml.kernel.org/r/20210108155813.2914586-1-shakeelb@google.com
Fixes: 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface for cgroup v2")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -504,9 +504,9 @@ int migrate_page_move_mapping(struct add
 			__inc_lruvec_state(new_lruvec, NR_SHMEM);
 		}
 		if (dirty && mapping_can_writeback(mapping)) {
-			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
+			__dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
 			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
-			__inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
+			__inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
 			__inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
 		}
 	}


