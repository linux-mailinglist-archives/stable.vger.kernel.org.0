Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7842505159
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237485AbiDRMeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239769AbiDRMdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C082A1E3FF;
        Mon, 18 Apr 2022 05:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D11860FB0;
        Mon, 18 Apr 2022 12:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537ACC385A1;
        Mon, 18 Apr 2022 12:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284741;
        bh=rW1u9K8345+MlZzqAj6h4y9oB8V4Y/VHGKcLCTUIvac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tJKviRIGfxQnLrXo8w1Gf/DrGoe9x8zZ9muyOUX9fddyjNHlFxnxUdrX3q4NXFiH
         b49g0BPZE+WqvkAf3d2nFepSc8H2t3JBYg89nP+eHHLdYF4oNrgMxsBMapdylarlwp
         ihun+HRdFHGBPWIrRnJNZKq3+TP16IGVVlEFVkBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.17 176/219] mm, page_alloc: fix build_zonerefs_node()
Date:   Mon, 18 Apr 2022 14:12:25 +0200
Message-Id: <20220418121211.804040370@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit e553f62f10d93551eb883eca227ac54d1a4fad84 upstream.

Since commit 6aa303defb74 ("mm, vmscan: only allocate and reclaim from
zones with pages managed by the buddy allocator") only zones with free
memory are included in a built zonelist.  This is problematic when e.g.
all memory of a zone has been ballooned out when zonelists are being
rebuilt.

The decision whether to rebuild the zonelists when onlining new memory
is done based on populated_zone() returning 0 for the zone the memory
will be added to.  The new zone is added to the zonelists only, if it
has free memory pages (managed_zone() returns a non-zero value) after
the memory has been onlined.  This implies, that onlining memory will
always free the added pages to the allocator immediately, but this is
not true in all cases: when e.g. running as a Xen guest the onlined new
memory will be added only to the ballooned memory list, it will be freed
only when the guest is being ballooned up afterwards.

Another problem with using managed_zone() for the decision whether a
zone is being added to the zonelists is, that a zone with all memory
used will in fact be removed from all zonelists in case the zonelists
happen to be rebuilt.

Use populated_zone() when building a zonelist as it has been done before
that commit.

There was a report that QubesOS (based on Xen) is hitting this problem.
Xen has switched to use the zone device functionality in kernel 5.9 and
QubesOS wants to use memory hotplugging for guests in order to be able
to start a guest with minimal memory and expand it as needed.  This was
the report leading to the patch.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6112,7 +6112,7 @@ static int build_zonerefs_node(pg_data_t
 	do {
 		zone_type--;
 		zone = pgdat->node_zones + zone_type;
-		if (managed_zone(zone)) {
+		if (populated_zone(zone)) {
 			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
 			check_highest_zone(zone_type);
 		}


