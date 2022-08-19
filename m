Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF7559964F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 09:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347128AbiHSHlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 03:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347130AbiHSHlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 03:41:20 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E903FCAC66;
        Fri, 19 Aug 2022 00:41:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9E8DF343CE;
        Fri, 19 Aug 2022 07:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660894878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=1NP3udiq4wm98SpQo28tXnqb4MBR4G0em4T/ZD3Qj24=;
        b=TlyJDV1L27zDUH9y6R7yMW1bRh4g9XB3R2WTB8hZNlFA1Qccoc3R+xK4oB/6DGaEfO8+6A
        KknaMsxkwIIE8TmRejOzljyjoI3Bg28q7EJs6ky6rawAOfMARffPxRKlTnqYH51X/a7uqQ
        lqOv/Wupj/R8fGJKqQUzg25XsePvLmE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B48B813AC1;
        Fri, 19 Aug 2022 07:41:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2rFaH50+/2LrUgAAMHmgww
        (envelope-from <wqu@suse.com>); Fri, 19 Aug 2022 07:41:17 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH STABLE 5.18 0/2] btrfs: raid56: backports to reduce corruption
Date:   Fri, 19 Aug 2022 15:40:57 +0800
Message-Id: <cover.1660894086.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the backport for v5.18.x stable branch.

The full explananation can be found here:
https://lore.kernel.org/linux-btrfs/Yv85PTBsDhrQITZp@kroah.com/T/#t

Difference between v5.18.x and v5.19.x backports:

- Subpage sector::uptodate related changes
  Since v5.18 and older branches doesn't support subpage RAID56, these
  uptodate checks are now in their older PageUptodate form.

- Various member naming changes
  Like btrfs_raid_bio::stripe_npages -> stripe_nsector.

Qu Wenruo (2):
  btrfs: only write the sectors in the vertical stripe which has data
    stripes
  btrfs: raid56: don't trust any cached sector in
    __raid56_parity_recover()

 fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 17 deletions(-)

-- 
2.37.1

