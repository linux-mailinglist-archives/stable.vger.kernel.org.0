Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00235502054
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 04:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348600AbiDOCQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 22:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348598AbiDOCQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 22:16:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F161A393;
        Thu, 14 Apr 2022 19:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9559262212;
        Fri, 15 Apr 2022 02:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89F1C385A5;
        Fri, 15 Apr 2022 02:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649988824;
        bh=/uR13Qq9wqBGR9IH2YJtOSDEkWsRKu9t9fGiJRj36Sw=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=ru4zzQgZZv5wnCe2MqmiPW8Mrkv5lbrCHfuRGSRPfGzWp6b0IJVfzfc9fiTrqDkhM
         WcRWTA0x8/4DpkeTVfJ4wJynVxaMlZv2dTj/CObVECCyS2GEbjBlc4Iz2AB+3OL09Y
         4nZzArhd+1H5VkjZvXg5BXICp8JqjE77qlhwYb8s=
Date:   Thu, 14 Apr 2022 19:13:43 -0700
To:     stable@vger.kernel.org, richard.weiyang@gmail.com, mhocko@suse.com,
        marmarek@invisiblethingslab.com, david@redhat.com, jgross@suse.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
Subject: [patch 07/14] mm, page_alloc: fix build_zonerefs_node()
Message-Id: <20220415021343.E89F1C385A5@smtp.kernel.org>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
