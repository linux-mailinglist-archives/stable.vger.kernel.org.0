Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392A04F7BB2
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 11:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiDGJeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 05:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbiDGJeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 05:34:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E147D888C0;
        Thu,  7 Apr 2022 02:32:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 94A37212C2;
        Thu,  7 Apr 2022 09:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649323943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iMz/fVk+XpC4IDojCtgZdhSbgaH5sJ66FU6YyYC0dAU=;
        b=srp3svmAJ66vDcJogBKiIGdVGuq5CEJs6NzN+Dq5b4+v+huIvNyS5C2rdiaVbhfch0DbrT
        75BoiGD0hZpc6CLImwmff34i2BgedTfCkHnIdUGSlX2blYRSglJ9ApB8mrYmE1yFAMAhOC
        HK7B66ciQOpkaSSp/7AQBiyKBcgA1u8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5B6E913A66;
        Thu,  7 Apr 2022 09:32:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5vzuFKevTmJVLgAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 07 Apr 2022 09:32:23 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH] mm, page_alloc: fix build_zonerefs_node()
Date:   Thu,  7 Apr 2022 11:32:21 +0200
Message-Id: <20220407093221.1090-1-jgross@suse.com>
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

Since commit 9d3be21bf9c0 ("mm, page_alloc: simplify zonelist
initialization") only zones with free memory are included in a built
zonelist. This is problematic when e.g. all memory of a zone has been
ballooned out.

Use populated_zone() when building a zonelist as it has been done
before that commit.

Cc: stable@vger.kernel.org
Fixes: 9d3be21bf9c0 ("mm, page_alloc: simplify zonelist initialization")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
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

