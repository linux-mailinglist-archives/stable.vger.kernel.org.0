Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19506ECE5E
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjDXNbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbjDXNbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:31:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8137295
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A8E462343
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81658C433EF;
        Mon, 24 Apr 2023 13:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343061;
        bh=pSLEgiBTAklJYbE4HYfduuFlerRfQs5FSyiDJXNZXNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmohkWPy6RmILdS5MBI5NfyseSfcpOgcbS+ufESMT+kdIBUSO/C2ZqbhcXR+Heu0P
         w0FeqUztfafqCC/9AptAacf2Adwpajqd4c1vDW37FSuKWkuu92if4X/6KWLC4bc7ka
         YI2IeEaXgzzm7OuOR8tha9R/tABY1d0alUxwJHwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Neal Gompa <neal@gompa.dev>,
        Boris Burkov <boris@bur.io>, David Sterba <dsterba@suse.com>
Subject: [PATCH 6.2 061/110] btrfs: reinterpret async discard iops_limit=0 as no delay
Date:   Mon, 24 Apr 2023 15:17:23 +0200
Message-Id: <20230424131138.595624714@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Burkov <boris@bur.io>

commit ef9cddfe57d86aac6b509b550136395669159b30 upstream.

Currently, a limit of 0 results in a hard coded metering over 6 hours.
Since the default is a set limit, I suspect no one truly depends on this
rather arbitrary setting. Repurpose it for an arguably more useful
"unlimited" mode, where the delay is 0.

Note that if block groups are too new, or go fully empty, there is still
a delay associated with those conditions. Those delays implement
heuristics for not trimming a region we are relatively likely to fully
overwrite soon.

CC: stable@vger.kernel.org # 6.2+
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/discard.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -56,8 +56,6 @@
 #define BTRFS_DISCARD_DELAY		(120ULL * NSEC_PER_SEC)
 #define BTRFS_DISCARD_UNUSED_DELAY	(10ULL * NSEC_PER_SEC)
 
-/* Target completion latency of discarding all discardable extents */
-#define BTRFS_DISCARD_TARGET_MSEC	(6 * 60 * 60UL * MSEC_PER_SEC)
 #define BTRFS_DISCARD_MIN_DELAY_MSEC	(1UL)
 #define BTRFS_DISCARD_MAX_DELAY_MSEC	(1000UL)
 #define BTRFS_DISCARD_MAX_IOPS		(1000U)
@@ -577,6 +575,7 @@ void btrfs_discard_calc_delay(struct btr
 	s32 discardable_extents;
 	s64 discardable_bytes;
 	u32 iops_limit;
+	unsigned long min_delay = BTRFS_DISCARD_MIN_DELAY_MSEC;
 	unsigned long delay;
 
 	discardable_extents = atomic_read(&discard_ctl->discardable_extents);
@@ -607,13 +606,19 @@ void btrfs_discard_calc_delay(struct btr
 	}
 
 	iops_limit = READ_ONCE(discard_ctl->iops_limit);
-	if (iops_limit)
+
+	if (iops_limit) {
 		delay = MSEC_PER_SEC / iops_limit;
-	else
-		delay = BTRFS_DISCARD_TARGET_MSEC / discardable_extents;
+	} else {
+		/*
+		 * Unset iops_limit means go as fast as possible, so allow a
+		 * delay of 0.
+		 */
+		delay = 0;
+		min_delay = 0;
+	}
 
-	delay = clamp(delay, BTRFS_DISCARD_MIN_DELAY_MSEC,
-		      BTRFS_DISCARD_MAX_DELAY_MSEC);
+	delay = clamp(delay, min_delay, BTRFS_DISCARD_MAX_DELAY_MSEC);
 	discard_ctl->delay_ms = delay;
 
 	spin_unlock(&discard_ctl->lock);


