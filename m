Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B9159ABBE
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 08:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244833AbiHTGff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 02:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244516AbiHTGf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 02:35:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E9F75FEB;
        Fri, 19 Aug 2022 23:35:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6498B2039D;
        Sat, 20 Aug 2022 06:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660977319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=3U+o4lkcY7hbmzUQAAOIkW59PamrVdyj1QyfsVCoARQ=;
        b=bBgJRZo3Eq69H+kWX9tPiCPYuNbAGYd7r3nGl400tEgR8u2pSby9tSG2zEkg5jY9Qa/MSt
        3oQyPNvGy79qfey37+MHyTu5xSWaXMR5cRYeHTm8WwNNKjb4UwHzyUZZavHjh9Px7jLPPw
        MdFhvFlIexNPBM+vrNnnk4FyNsxbw1o=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6268C13523;
        Sat, 20 Aug 2022 06:35:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 97vOCaaAAGOCBwAAMHmgww
        (envelope-from <wqu@suse.com>); Sat, 20 Aug 2022 06:35:18 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH STABLE 5.4 0/2] btrfs: raid56: backports to reduce corruption
Date:   Sat, 20 Aug 2022 14:34:58 +0800
Message-Id: <cover.1660977189.git.wqu@suse.com>
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

This is the backport for v5.4.x stable branch.

The full explananation can be found here:
https://lore.kernel.org/linux-btrfs/cover.1660891713.git.wqu@suse.com/

These backport have no change compared to v5.10.x backports (at least
nothing git can not auto-resolve).

While the testing part shows some extra warning in btrfs/162, it's the
existing show_dev_name related RCU string accesss problem, not something
new regression caused by these backports.

Qu Wenruo (2):
  btrfs: only write the sectors in the vertical stripe which has data
    stripes
  btrfs: raid56: don't trust any cached sector in
    __raid56_parity_recover()

 fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 17 deletions(-)

-- 
2.37.1

