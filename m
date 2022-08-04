Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90497589906
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 10:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbiHDILV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 04:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237383AbiHDILU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 04:11:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A282127B23;
        Thu,  4 Aug 2022 01:11:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4101A20D28;
        Thu,  4 Aug 2022 08:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659600678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=QktJ04eaheJxC/ih3AdbUruJqpnXSFUvzFR2uxovmjM=;
        b=c5weCumS82Dg7MJukQjEOaYUAwxZ3nmtCQ4N+ZdNmnIriw+UUY3QxWnPdIwt+um+XeYGIz
        ux4qYX3kN1USrXfmfTRDfGUvRC+YsLTMxZ0tVb1ktn6v8DpZ2cqTStUsvxEOprJ/VbF/hC
        vTHZ1aRlSGh1U4eUJl/ilvuYINg+aZg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5CD7113AE1;
        Thu,  4 Aug 2022 08:11:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ISTmCSV/62L1KQAAMHmgww
        (envelope-from <wqu@suse.com>); Thu, 04 Aug 2022 08:11:17 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH STABLE 5.18 0/2] btrfs: raid56 backports to reduce destructive RMW
Date:   Thu,  4 Aug 2022 16:10:57 +0800
Message-Id: <cover.1659600630.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

This two patches are backports for v5.18 branch.

These two patches are reducing the chance of destructive RMW cycle,
where btrfs can use corrupted data to generate new P/Q, thus making some
repairable data unrepairable.

Those patches are more important than what I initially thought, thus
unfortunately they are not CCed to stable by themselves.

Furthermore due to recent refactors/renames, there are quite some member
change related to those patches, thus have to be manually backported.
(The v5.18 backport is more like the v5.15 backport, with small tweaks
due to member naming change).

One of the fastest way to verify the behavior is the existing btrfs/125
test case from fstests. (not in auto group AFAIK).

Qu Wenruo (2):
  btrfs: only write the sectors in the vertical stripe which has data
    stripes
  btrfs: raid56: don't trust any cached sector in
    __raid56_parity_recover()

 fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 17 deletions(-)

-- 
2.37.0

