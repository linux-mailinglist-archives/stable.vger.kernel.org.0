Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435BE4F7EB6
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 14:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbiDGMIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 08:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbiDGMIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 08:08:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131EAB0A4C;
        Thu,  7 Apr 2022 05:06:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C4B5F1F85A;
        Thu,  7 Apr 2022 12:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649333198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UpuTzjjU3dwrDNlWUgU1m4VL7JE5wjWtlut0wOZ6+Us=;
        b=bamm/WXnOVYE8ZOho6XQUe7FCEZovOUuJfhlzWNhhXeUA04h7c/K9EahBbNmRzY3a1B0GV
        PYCeX6iSGlyPLVgg+TcAICaXy7ccBN1LFAaAz/36KVQU1wVrrWfK5NFQkqu3UV7fDyUDHl
        I7ddY451v2TFm/p8DP18Y42M5VrwxQE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 851E113485;
        Thu,  7 Apr 2022 12:06:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1/lNH87TTmIFBQAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 07 Apr 2022 12:06:38 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2] mm, page_alloc: fix build_zonerefs_node()
Date:   Thu,  7 Apr 2022 14:06:37 +0200
Message-Id: <20220407120637.9035-1-jgross@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 6aa303defb74 ("mm, vmscan: only allocate and reclaim from
zones with pages managed by the buddy allocator") only zones with free
memory are included in a built zonelist. This is problematic when e.g.
all memory of a zone has been ballooned out when zonelists are being
rebuilt.

The decision whether to rebuild the zonelists when onlining new memory
is done based on populated_zone() returning 0 for the zone the memory
will be added to. The new zone is added to the zonelists only, if it
has free memory pages (managed_zone() returns a non-zero value) after
the memory has been onlined. This implies, that onlining memory will
always free the added pages to the allocator immediately, but this is
not true in all cases: when e.g. running as a Xen guest the onlined
new memory will be added only to the ballooned memory list, it will be
freed only when the guest is being ballooned up afterwards.

Another problem with using managed_zone() for the decision whether a
zone is being added to the zonelists is, that a zone with all memory
used will in fact be removed from all zonelists in case the zonelists
happen to be rebuilt.

Use populated_zone() when building a zonelist as it has been done
before that commit.

Cc: stable@vger.kernel.org
Fixes: 6aa303defb74 ("mm, vmscan: only allocate and reclaim from zones with pages managed by the buddy allocator")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
V2:
- updated commit message (Michal Hocko)
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bdc8f60ae462..3d0662af3289 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6128,7 +6128,7 @@ static int build_zonerefs_node(pg_data_t *pgdat, struct zoneref *zonerefs)
 	do {
 		zone_type--;
 		zone = pgdat->node_zones + zone_type;
-		if (managed_zone(zone)) {
+		if (populated_zone(zone)) {
 			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
 			check_highest_zone(zone_type);
 		}
-- 
2.34.1

