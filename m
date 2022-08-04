Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4186558981C
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 09:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbiHDHHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 03:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239093AbiHDHHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 03:07:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E89B61D66;
        Thu,  4 Aug 2022 00:07:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F000E4E34C;
        Thu,  4 Aug 2022 07:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659596864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dZ5fzzOyi7x9K6ycFv/1geqWnPkWAMMG5EnN6mG7mJw=;
        b=UNqdBFoKliCklvcvyZfqBmI4EOtFq5Iii5TyBxrQ4Aie5jXlbijhRGY4VsyPsqEcu4GSqo
        dHZ+ytJLP9kP3sePPDaXOeCCdAQ/m9/Aal0K+EX28pH6qdX1LdEj8veacmnlJfQdEkk+vA
        TYem5jlgLxuNSrzy5VcrF1TxhSXyE+U=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 240C21348A;
        Thu,  4 Aug 2022 07:07:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WFAbOD9w62J+DgAAMHmgww
        (envelope-from <wqu@suse.com>); Thu, 04 Aug 2022 07:07:43 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH STABLE 5.10 5.15 0/2] btrfs: raid56 backports to reduce destructive RMW
Date:   Thu,  4 Aug 2022 15:07:24 +0800
Message-Id: <cover.1659596446.git.wqu@suse.com>
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

This two patches are backports for v5.15 and v5.10 (for v5.10 conflicts
can be auto resolved) stable branches.

(For older branches from v4.9 to v5.4, due to some naming change,
although the patches can be applied with auto-resolve, they won't compile).

These two patches are reducing the chance of destructive RMW cycle,
where btrfs can use corrupted data to generate new P/Q, thus making some
repairable data unrepairable.

Those patches are more important than what I initially thought, thus
unfortunately they are not CCed to stable by themselves.

Furthermore due to recent refactors/renames, there are quite some member
change related to those patches, thus have to be manually backported.


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

