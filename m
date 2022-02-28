Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB934C7595
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbiB1Rzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240690AbiB1Rya (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF8B28998;
        Mon, 28 Feb 2022 09:42:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88E5BB815AB;
        Mon, 28 Feb 2022 17:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D0DC340E7;
        Mon, 28 Feb 2022 17:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070162;
        bh=+HyTJW9oh68MjDBNP2PCnJ/peQpW+kpxwJTPtWuGjx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDbIVWJB9a1A3DhtE+tJ0GfNO9d6Le61z5EFW1m+CG8gEN0LTuj0uAXPqtCwLIhCt
         8q97U6e3Ue2YHaaTL6auj3yOwKWhegvPnuxfYANUcvb3gRxj1sCH1pAHcTToQjlXLN
         EDs5l8vbBtCwbG4K1+1fVePEbLUKkM/IKLGgAtIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        "stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com, Song Liu" 
        <songliubraving@fb.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Adam Majer <amajer@suse.com>, Dirk Mueller <dmueller@suse.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 001/164] mm/filemap: Fix handling of THPs in generic_file_buffered_read()
Date:   Mon, 28 Feb 2022 18:22:43 +0100
Message-Id: <20220228172359.727109405@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

When a THP is present in the page cache, we can return it several times,
leading to userspace seeing the same data repeatedly if doing a read()
that crosses a 64-page boundary.  This is probably not a security issue
(since the data all comes from the same file), but it can be interpreted
as a transient data corruption issue.  Fortunately, it is very rare as
it can only occur when CONFIG_READ_ONLY_THP_FOR_FS is enabled, and it can
only happen to executables.  We don't often call read() on executables.

This bug is fixed differently in v5.17 by commit 6b24ca4a1a8d
("mm: Use multi-index entries in the page cache").  That commit is
unsuitable for backporting, so fix this in the clearest way.  It
sacrifices a little performance for clarity, but this should never
be a performance path in these kernel versions.

Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
Cc: stable@vger.kernel.org # v5.15, v5.16
Link: https://lore.kernel.org/r/df3b5d1c-a36b-2c73-3e27-99e74983de3a@suse.cz/
Analyzed-by: Adam Majer <amajer@suse.com>
Analyzed-by: Dirk Mueller <dmueller@suse.com>
Bisected-by: Takashi Iwai <tiwai@suse.de>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2365,8 +2365,12 @@ static void filemap_get_read_batch(struc
 			break;
 		if (PageReadahead(head))
 			break;
-		xas.xa_index = head->index + thp_nr_pages(head) - 1;
-		xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
+		if (PageHead(head)) {
+			xas_set(&xas, head->index + thp_nr_pages(head));
+			/* Handle wrap correctly */
+			if (xas.xa_index - 1 >= max)
+				break;
+		}
 		continue;
 put_page:
 		put_page(head);


