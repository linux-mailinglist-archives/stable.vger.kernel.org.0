Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19FA6CC45F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbjC1PEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbjC1PEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:04:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8289B47C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:03:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EEFAB81D86
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D995C4339B;
        Tue, 28 Mar 2023 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015754;
        bh=hWDveVcO63/N+u/HOLSx0BaRMQYb3vr1b+/kzv1G5Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctFkcGVg4CMXVK8xpAYyED+DgAXSU+1gSHcw2I/GcZQXvai8aLM87ZWfMDohIiO0j
         NO1VVM1JviC4vLQiq2zBFlYUEdLxyFQNKprqeLfkggPFEAwWi8GteNHbmmgwi/OhMV
         mGZnb3qmQiY6v9MJKj0LkrWbuoStpR/8bSZA1mbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 164/224] btrfs: zoned: fix btrfs_can_activate_zone() to support DUP profile
Date:   Tue, 28 Mar 2023 16:42:40 +0200
Message-Id: <20230328142624.203134766@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 9e1cdf0c354e46e428c0e0cab008abbe81b6013d upstream.

btrfs_can_activate_zone() returns true if at least one device has one zone
available for activation. This is OK for the single profile, but not OK for
DUP profile. We need two zones to create a DUP block group. Fix it by
properly handling the case with the profile flags.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2113,11 +2113,21 @@ bool btrfs_can_activate_zone(struct btrf
 		if (!device->bdev)
 			continue;
 
-		if (!zinfo->max_active_zones ||
-		    atomic_read(&zinfo->active_zones_left)) {
+		if (!zinfo->max_active_zones) {
 			ret = true;
 			break;
 		}
+
+		switch (flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+		case 0: /* single */
+			ret = (atomic_read(&zinfo->active_zones_left) >= 1);
+			break;
+		case BTRFS_BLOCK_GROUP_DUP:
+			ret = (atomic_read(&zinfo->active_zones_left) >= 2);
+			break;
+		}
+		if (ret)
+			break;
 	}
 	mutex_unlock(&fs_info->chunk_mutex);
 


