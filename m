Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F6F5060EC
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240572AbiDSA3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240459AbiDSA2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:28:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF7222B33;
        Mon, 18 Apr 2022 17:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B4726134B;
        Tue, 19 Apr 2022 00:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F98C385A8;
        Tue, 19 Apr 2022 00:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650327964;
        bh=6r8GqEddq/AMGZs2CHafjOe4FAUiGoKPrjTGdC1dw4A=;
        h=Date:To:From:Subject:From;
        b=G875L8us5PsO2Oz8aHRuIQGOTBObYobsKJWMFsRxZYQ52T7widcCWsq1xqE6yU6jy
         rGyxsssnwGGUIpiCxRkj90IEKzb3Vzr3+f1mMzW9szbvMPpx1AIzodzgfIsq5aH0n1
         MhEX8ubhNLpGfqhxSCvErZu7G/TL+AIHVixztA54=
Date:   Mon, 18 Apr 2022 17:26:03 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        richard.weiyang@gmail.com, mhocko@suse.com,
        marmarek@invisiblethingslab.com, david@redhat.com, jgross@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_alloc-fix-build_zonerefs_node.patch removed from -mm tree
Message-Id: <20220419002604.91F98C385A8@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: fix build_zonerefs_node()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-build_zonerefs_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Juergen Gross <jgross@suse.com>
Subject: mm, page_alloc: fix build_zonerefs_node()

Since commit 6aa303defb74 ("mm, vmscan: only allocate and reclaim from
zones with pages managed by the buddy allocator") only zones with free
memory are included in a built zonelist.  This is problematic when e.g. 
all memory of a zone has been ballooned out when zonelists are being
rebuilt.

The decision whether to rebuild the zonelists when onlining new memory is
done based on populated_zone() returning 0 for the zone the memory will be
added to.  The new zone is added to the zonelists only, if it has free
memory pages (managed_zone() returns a non-zero value) after the memory
has been onlined.  This implies, that onlining memory will always free the
added pages to the allocator immediately, but this is not true in all
cases: when e.g.  running as a Xen guest the onlined new memory will be
added only to the ballooned memory list, it will be freed only when the
guest is being ballooned up afterwards.

Another problem with using managed_zone() for the decision whether a zone
is being added to the zonelists is, that a zone with all memory used will
in fact be removed from all zonelists in case the zonelists happen to be
rebuilt.

Use populated_zone() when building a zonelist as it has been done before
that commit.

There was a report that QubesOS (based on Xen) is hitting this problem.
Xen has switched to use the zone device functionality in kernel 5.9
and QubesOS wants to use memory hotplugging for guests in order to be
able to start a guest with minimal memory and expand it as needed. 
This was the report leading to the patch.

Link: https://lkml.kernel.org/r/20220407120637.9035-1-jgross@suse.com
Fixes: 6aa303defb74 ("mm, vmscan: only allocate and reclaim from zones with pages managed by the buddy allocator")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-build_zonerefs_node
+++ a/mm/page_alloc.c
@@ -6131,7 +6131,7 @@ static int build_zonerefs_node(pg_data_t
 	do {
 		zone_type--;
 		zone = pgdat->node_zones + zone_type;
-		if (managed_zone(zone)) {
+		if (populated_zone(zone)) {
 			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
 			check_highest_zone(zone_type);
 		}
_

Patches currently in -mm which might be from jgross@suse.com are


