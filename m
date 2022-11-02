Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8566157BD
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiKBCiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiKBCh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:37:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EABFAF7
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1096AB8206C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83971C433D7;
        Wed,  2 Nov 2022 02:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356671;
        bh=7BHXgRL/GPbTdfR++NU+afMZbARwfum1k9+vUlmeK/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qK6DfSiJ9ImmLZvlRRXAmdh1Hdfe+ICSkVkci6o13UuIZ7T9Ks2QtKku4IdWhXbSq
         GHwYe8c520CdqfAqCvv9+qTNDU/f9YWkJK39M17Yj/JZXl0Xg4vdQ2QE3PtGO7KWA3
         P3hWiGjClypCb60hJAV/39wF64DN/xKcktDY9Dlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Phillip Lougher <phillip@squashfs.org.uk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Marc Miltenberger <marcmiltenberger@gmail.com>,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Slade Watkins <srw@sladewatkins.net>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 040/240] squashfs: fix extending readahead beyond end of file
Date:   Wed,  2 Nov 2022 03:30:15 +0100
Message-Id: <20221102022112.309190964@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Lougher <phillip@squashfs.org.uk>

commit c9199de82bad03bceb94ec3c5195c879d7e11911 upstream.

The readahead code will try to extend readahead to the entire size of the
Squashfs data block.

But, it didn't take into account that the last block at the end of the
file may not be a whole block.  In this case, the code would extend
readahead to beyond the end of the file, leaving trailing pages.

Fix this by only requesting the expected number of pages.

Link: https://lkml.kernel.org/r/20221020223616.7571-3-phillip@squashfs.org.uk
Fixes: 8fc78b6fe24c ("squashfs: implement readahead")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reported-by: Marc Miltenberger <marcmiltenberger@gmail.com>
Cc: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Slade Watkins <srw@sladewatkins.net>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/squashfs/file.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index e526eb7a1658..f0afd4d6fd30 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -559,6 +559,12 @@ static void squashfs_readahead(struct readahead_control *ractl)
 		unsigned int expected;
 		struct page *last_page;
 
+		expected = start >> msblk->block_log == file_end ?
+			   (i_size_read(inode) & (msblk->block_size - 1)) :
+			    msblk->block_size;
+
+		max_pages = (expected + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
 		nr_pages = __readahead_batch(ractl, pages, max_pages);
 		if (!nr_pages)
 			break;
@@ -567,13 +573,10 @@ static void squashfs_readahead(struct readahead_control *ractl)
 			goto skip_pages;
 
 		index = pages[0]->index >> shift;
+
 		if ((pages[nr_pages - 1]->index >> shift) != index)
 			goto skip_pages;
 
-		expected = index == file_end ?
-			   (i_size_read(inode) & (msblk->block_size - 1)) :
-			    msblk->block_size;
-
 		if (index == file_end && squashfs_i(inode)->fragment_block !=
 						SQUASHFS_INVALID_BLK) {
 			res = squashfs_readahead_fragment(pages, nr_pages,
-- 
2.38.1



