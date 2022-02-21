Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375404BE97F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351140AbiBUJmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:42:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351170AbiBUJmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:42:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A813E0DF;
        Mon, 21 Feb 2022 01:17:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C757BCE0E88;
        Mon, 21 Feb 2022 09:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E46C340E9;
        Mon, 21 Feb 2022 09:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435061;
        bh=8Fp2icFelVe5cF2glrfpTqMr4PApFbTngg78rssYqCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiSLghU7ftsr2F6ZcndNAM0JbGntvVM6sXn3yjAheU0m6bPT7zVwyCnS6P5oHvKpQ
         bt2Ul8QrPZCp1OuqBug5nN7haM4eKoozpFIWT2fq38rn9iNuvFmPxrZu45QQ6ZYCAX
         BRWrr9D1/FDB0tqoF7u1OibKxfXArEjzDJjEw6v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 030/227] btrfs: defrag: dont try to defrag extents which are under writeback
Date:   Mon, 21 Feb 2022 09:47:29 +0100
Message-Id: <20220221084935.841579106@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 0d1ffa2228cb34f485f8fe927f134b82a0ea62ae upstream.

Once we start writeback (have called btrfs_run_delalloc_range()), we
allocate an extent, create an extent map point to that extent, with a
generation of (u64)-1, created the ordered extent and then clear the
DELALLOC bit from the range in the inode's io tree.

Such extent map can pass the first call of defrag_collect_targets(), as
its generation is (u64)-1, meets any possible minimal generation check.
And the range will not have DELALLOC bit, also passing the DELALLOC bit
check.

It will only be re-checked in the second call of
defrag_collect_targets(), which will wait for writeback.

But at that stage we have already spent our time waiting for some IO we
may or may not want to defrag.

Let's reject such extents early so we won't waste our time.

CC: stable@vger.kernel.org # 5.16
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1184,6 +1184,10 @@ static int defrag_collect_targets(struct
 		if (em->generation < newer_than)
 			goto next;
 
+		/* This em is under writeback, no need to defrag */
+		if (em->generation == (u64)-1)
+			goto next;
+
 		/*
 		 * Our start offset might be in the middle of an existing extent
 		 * map, so take that into account.


