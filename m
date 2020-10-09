Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6951C289B64
	for <lists+stable@lfdr.de>; Sat, 10 Oct 2020 00:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbgJIWAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 18:00:52 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14417 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731030AbgJIWAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 18:00:51 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80dd590003>; Fri, 09 Oct 2020 14:59:53 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 22:00:46 +0000
Received: from rcampbell-dev.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Fri, 9 Oct 2020 22:00:46 +0000
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralph Campbell <rcampbell@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH] mm/memcg: fix device private memcg accounting
Date:   Fri, 9 Oct 2020 14:59:52 -0700
Message-ID: <20201009215952.2726-1-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602280794; bh=7mbqnLRSmP8gyFcv2CaKHAGuiDlEp5BFChE0DK1AomM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         X-NVConfidentiality:Content-Transfer-Encoding:Content-Type;
        b=GeXxS06CgAM4OOs4VCnOprIky8XoMeqlb13IWp0IGbvVpb7B8gd+hqzTalJC/zNQy
         wqBVq14+n5Sn4XP6sXOxEMREEzyaO7RQXpwh00B/1HXhMrUJXKm6747f8MNxqTAovl
         RMHcyxNBZo/hWbb4hatQSFNc2MqflrLJCFYTod+GkNE6Rm4eIOjVfeVKsgWm5pa0ta
         T0bUuVSRMbG740o3HCQ5e89pmK/+o+j31QFnM4S85NaLtML/52R0fzfQN3RHTsuJKT
         Y0Xg08kvpmukYGORsuuNmYdLYb4jE1bR00IypKYRojk7PVJADHRkW0mGzF4VnQCS1y
         +dRqbzURrmy8g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
NULL before checking is_device_private_entry() so device private pages
are never handled.
Fix this by checking for non_swap_entry() after handling device private
swap PTEs.

Cc: stable@vger.kernel.org
Fixes: c733a82874a7 ("mm/memcontrol: support MEMORY_DEVICE_PRIVATE")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
---

I'm not sure exactly how to test this. I ran the HMM self tests but
that is a minimal sanity check. I think moving the self test from one
memory cgroup to another while it is running would exercise this patch.
I'm looking at how the test could move itself to another group after
migrating some anonymous memory to the test driver.

This applies cleanly to linux-5.9.0-rc8-mm1 and is for Andrew Morton's
tree.

 mm/memcontrol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2636f8bad908..3a24e3b619f5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5549,7 +5549,7 @@ static struct page *mc_handle_swap_pte(struct vm_area=
_struct *vma,
 	struct page *page =3D NULL;
 	swp_entry_t ent =3D pte_to_swp_entry(ptent);
=20
-	if (!(mc.flags & MOVE_ANON) || non_swap_entry(ent))
+	if (!(mc.flags & MOVE_ANON))
 		return NULL;
=20
 	/*
@@ -5568,6 +5568,9 @@ static struct page *mc_handle_swap_pte(struct vm_area=
_struct *vma,
 		return page;
 	}
=20
+	if (non_swap_entry(ent))
+		return NULL;
+
 	/*
 	 * Because lookup_swap_cache() updates some statistics counter,
 	 * we call find_get_page() with swapper_space directly.
--=20
2.20.1

