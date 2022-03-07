Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC90F4CFAB1
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239446AbiCGKWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240858AbiCGKTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:19:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F487A9A5;
        Mon,  7 Mar 2022 01:58:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 536F1B810B2;
        Mon,  7 Mar 2022 09:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3997C340E9;
        Mon,  7 Mar 2022 09:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647048;
        bh=Ayo2KqVl42sq7dzzXi5bS6zNkAAC1qgQLNT8ZWRcAfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2umwE/lbBTyAVRZ+KCeZqfDSFovUgnYt1n+rIzk/ADMWphMoXvs9ipcxNiVOJBBft
         0tb2MBovUITQaKz7od1MvgKzdC2FfE5QFUocQ8SPK8CedlmPIHOylVWc68Tt/UQdGB
         czausS7VwCRldGwhF3yUu8SJAJn9Z81mPZwGbpN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 175/186] btrfs: subpage: fix a wrong check on subpage->writers
Date:   Mon,  7 Mar 2022 10:20:13 +0100
Message-Id: <20220307091658.970228729@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit c992fa1fd52380d0c4ced7b07479e877311ae645 upstream.

[BUG]
When looping btrfs/074 with 64K page size and 4K sectorsize, there is a
low chance (1/50~1/100) to crash with the following ASSERT() triggered
in btrfs_subpage_start_writer():

	ret = atomic_add_return(nbits, &subpage->writers);
	ASSERT(ret == nbits); <<< This one <<<

[CAUSE]
With more debugging output on the parameters of
btrfs_subpage_start_writer(), it shows a very concerning error:

  ret=29 nbits=13 start=393216 len=53248

For @nbits it's correct, but @ret which is the returned value from
atomic_add_return(), it's not only larger than nbits, but also larger
than max sectors per page value (for 64K page size and 4K sector size,
it's 16).

This indicates that some call sites are not properly decreasing the value.

And that's exactly the case, in btrfs_page_unlock_writer(), due to the
fact that we can have page locked either by lock_page() or
process_one_page(), we have to check if the subpage has any writer.

If no writers, it's locked by lock_page() and we only need to unlock it.

But unfortunately the check for the writers are completely opposite:

	if (atomic_read(&subpage->writers))
		/* No writers, locked by plain lock_page() */
		return unlock_page(page);

We directly unlock the page if it has writers, which is the completely
opposite what we want.

Thankfully the affected call site is only limited to
extent_write_locked_range(), so it's mostly affecting compressed write.

[FIX]
Just fix the wrong check condition to fix the bug.

Fixes: e55a0de18572 ("btrfs: rework page locking in __extent_writepage()")
CC: stable@vger.kernel.org # 5.16
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/subpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -736,7 +736,7 @@ void btrfs_page_unlock_writer(struct btr
 	 * Since we own the page lock, no one else could touch subpage::writers
 	 * and we are safe to do several atomic operations without spinlock.
 	 */
-	if (atomic_read(&subpage->writers))
+	if (atomic_read(&subpage->writers) == 0)
 		/* No writers, locked by plain lock_page() */
 		return unlock_page(page);
 


