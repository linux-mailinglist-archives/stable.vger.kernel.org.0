Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BA64C7705
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbiB1SLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241101AbiB1SJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982996578C;
        Mon, 28 Feb 2022 09:49:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 150ECCE17DE;
        Mon, 28 Feb 2022 17:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A926C340E7;
        Mon, 28 Feb 2022 17:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070530;
        bh=7ZUWafBrUgsPQOM0spQIijXWaUVsOrTgp7TNYgMDLdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NS/0uGqoQ9gIBAxbEIAPytIKsEwIxdF5jVvu3mOxdM52GHdkgebAUw07ulFBjj7uX
         lbohkXhWulhgjIXgNEnZrQnm0y5kS7mNEqBvKZObEFXEAXVl3o9QawMQwwlia9zRfw
         lTGcbqaaZ907xu1UBtfYBU0qWFzEv1L8YP5C3PzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 140/164] btrfs: defrag: remove an ambiguous condition for rejection
Date:   Mon, 28 Feb 2022 18:25:02 +0100
Message-Id: <20220228172412.642464193@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 550f133f6959db927127111b50e483da3a7ce662 upstream.

>From the very beginning of btrfs defrag, there is a check to reject
extents which meet both conditions:

- Physically adjacent

  We may want to defrag physically adjacent extents to reduce the number
  of extents or the size of subvolume tree.

- Larger than 128K

  This may be there for compressed extents, but unfortunately 128K is
  exactly the max capacity for compressed extents.
  And the check is > 128K, thus it never rejects compressed extents.

  Furthermore, the compressed extent capacity bug is fixed by previous
  patch, there is no reason for that check anymore.

The original check has a very small ranges to reject (the target extent
size is > 128K, and default extent threshold is 256K), and for
compressed extent it doesn't work at all.

So it's better just to remove the rejection, and allow us to defrag
physically adjacent extents.

CC: stable@vger.kernel.org # 5.16
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1049,10 +1049,6 @@ static bool defrag_check_next_extent(str
 	 */
 	if (next->len >= get_extent_max_capacity(em))
 		goto out;
-	/* Physically adjacent and large enough */
-	if ((em->block_start + em->block_len == next->block_start) &&
-	    (em->block_len > SZ_128K && next->block_len > SZ_128K))
-		goto out;
 	ret = true;
 out:
 	free_extent_map(next);


