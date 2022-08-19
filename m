Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533B8599B70
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 14:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348756AbiHSMBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 08:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348503AbiHSMBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 08:01:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6088E398F;
        Fri, 19 Aug 2022 05:01:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9DBC135294;
        Fri, 19 Aug 2022 12:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660910491; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=lUx2upYUK882vY8+Up0b10yFNUJRHPJRqFq2C8X5PjM=;
        b=iBO6E3n4GeYLL0tBfq8u0IlmM3fNSC8oI2yi9vQFOpMLmlvg6JV/v0uQ7tlN6v+BoBDZf5
        eHPLyCK9+jyb+a6aPH2jnM5VDpBKs/HPjXqzSbu24Agx91c/qtbHgMUPkMyE3lia+Jj2VY
        yv2MaTmankYRjgsF3D0SJyjYHLJ9gSk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C018013AC1;
        Fri, 19 Aug 2022 12:01:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bWN3Ipp7/2LLOwAAMHmgww
        (envelope-from <wqu@suse.com>); Fri, 19 Aug 2022 12:01:30 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH STABLE 5.10 0/2] btrfs: raid56: backports to reduce corruption
Date:   Fri, 19 Aug 2022 20:01:08 +0800
Message-Id: <cover.1660906975.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the backport for v5.10.x stable branch.

The full explananation can be found here:
https://lore.kernel.org/linux-btrfs/cover.1660891713.git.wqu@suse.com/

Difference between v5.10.x and v5.15.x backports:

- Naming change in btrfs_io_contrl
  In v5.15, we don't have the btrfs_io_contrl rename, thus only
  btrfs_bio.

- Missing btrfs_fs_info::sectorsize_bits
  Since RAID56 doesn't support anything but PAGE_SIZE == sectorsize
  (until v5.19+), here we just use PAGE_SHIFT.

Another thing related to v5.10.x testing is, there are some lockdep
assert triggered related to uuid_mutex.

I'm not 100% sure, but at least RAID56 code is not touching that mutex,
thus I guess it's some other problems.

Qu Wenruo (2):
  btrfs: only write the sectors in the vertical stripe which has data
    stripes
  btrfs: raid56: don't trust any cached sector in
    __raid56_parity_recover()

 fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 17 deletions(-)

-- 
2.37.1

