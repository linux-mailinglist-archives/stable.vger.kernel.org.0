Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5FF4B8112
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 08:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiBPHLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 02:11:15 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiBPHLO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 02:11:14 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAC11ED;
        Tue, 15 Feb 2022 23:10:49 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 36CFB212C3;
        Wed, 16 Feb 2022 07:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644995367; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=lShnI6VqvhfgrcXnUaaLWHBG2xNDPuV9t+KYhxjWikE=;
        b=iJxGETUXvcNCeg22xFlnh6ie7k57xv1UmcPJfz0FxjzIKOFnvEa3oAJusohL6YJA4BU/iV
        uCZh17XlSnq/Ons2TU7prNolx+WOUF4smE4aIwO1e2Hy/V2FU2qlqBcMfmVthE2CAyxCPe
        aum5VhRBeCAeEz0latmVYfVvqQqv0as=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CE1EB13A3A;
        Wed, 16 Feb 2022 07:09:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nw0TJSWjDGJ1LgAAMHmgww
        (envelope-from <wqu@suse.com>); Wed, 16 Feb 2022 07:09:25 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH for v5.15 0/2] Defrag fixes for v5.15
Date:   Wed, 16 Feb 2022 15:09:06 +0800
Message-Id: <cover.1644994950.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In v5.16 btrfs had a big rework (originally considered as a refactor
only) on defrag, which brings quite some regressions.

With those regressions, extra scrutiny is brought to defrag code, and
some existing bugs are exposed.

For v5.15, there are those patches need to be backported:
(Tracked through github issue:
https://github.com/btrfs/linux/issues/422)

- Already upstreamed:
  "btrfs: don't hold CPU for too long when defragging a file"
  The first patch.

- In maintainer's tree
  btrfs: defrag: don't try to merge regular extents with preallocated extents
  btrfs: defrag: don't defrag extents which are already at max capacity
  btrfs: defrag: remove an ambiguous condition for rejection

  Those will be backported when they get merged upstream.

- One special fix for v5.15
  The 2nd patch.

  The problem is, that patch has no upstream commit, since v5.16
  reworked the defrag code and fix the problem unintentionally.
  It's not a good idea to bring the whole rework (along with its bugs)
  to stable kernel.

  So here I crafted a small fix for v5.15 only.

  Not sure if this is conflicted with any stable policy.

Qu Wenruo (2):
  btrfs: don't hold CPU for too long when defragging a file
  btrfs: defrag: use the same cluster size for defrag ioctl and
    autodefrag

 fs/btrfs/ioctl.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

-- 
2.35.1

