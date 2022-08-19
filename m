Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE7D5995A3
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 09:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346889AbiHSHCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 03:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346852AbiHSHCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 03:02:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DA21A83B;
        Fri, 19 Aug 2022 00:02:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0E6785CAB3;
        Fri, 19 Aug 2022 07:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660892520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Axl1mCgymEaDOrka5s5cbWyxRTPCMz6DdKfYMUOpJ7Q=;
        b=em+hqikuMzxIpSx0JvoY7Et+sznr0Q5WnUT4PQIyyoLEXGw6/kJMZyvD1jP1+eRdoR1j1N
        yuY/EC0IdMgLtEjNBUaFE05UR3uSR4wV0Xnni+2ub71mE0NntdKXJ75NXlWrNQ6b0b4h4E
        TO8CrADNSWz8029GrCN0V+tDwOtJlGM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E699F13AC1;
        Fri, 19 Aug 2022 07:01:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vkRsEGY1/2JJRAAAMHmgww
        (envelope-from <wqu@suse.com>); Fri, 19 Aug 2022 07:01:58 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.19 0/2] btrfs: raid56: backports to reduce corruption
Date:   Fri, 19 Aug 2022 15:01:37 +0800
Message-Id: <cover.1660891713.git.wqu@suse.com>
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

This backport is going to address the following possible corruption for
btrfs RAID56:

- RMW always writes the full P/Q stripe
  This happens even only some vertical stripes are dirty.

  If some data sectors are corrupted in the clean vertical stripes,
  then such unnecessary P/Q updates will wipe the chance or recovery,
  as the P/Q will be calculated using corrupted data.

  This will be addressed by the first backport patch.

- Don't trust any cached sector when doing recovery
  Although above patch will avoid unnecessary P/Q writes, the full P/Q
  stripe will still be updated in the in-memory only RAID56 cache.

  To properly recovery data stripes, we should not trust any cached
  sector, and always read data from disk, which will avoid corrupted
  P/Q sectors.

  This will be addressed by the second backport patch.

This would make some previously always-fail test cases, like btrfs/125,
to pass, and end users have a lower chance to corrupt their RAID56 data.

Since this is a data corruption related fix, these backport patches are
needed for all stable branches.

Unfortunately due to the new cleanups in v6.0-rc, these backport patches
have quite some conflicts (even for 5.19), and have to be manually resolved.
Almost every stable branch will need their own backports.

Acked-by: David Sterba <dsterba@suse.com>

Qu Wenruo (2):
  btrfs: only write the sectors in the vertical stripe which has data
    stripes
  btrfs: raid56: don't trust any cached sector in
    __raid56_parity_recover()

 fs/btrfs/raid56.c | 68 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 13 deletions(-)

-- 
2.37.1

