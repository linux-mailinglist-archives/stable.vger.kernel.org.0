Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7276DEF80
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjDLIvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjDLIvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243F49ED1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B49C6312D
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA9DC433EF;
        Wed, 12 Apr 2023 08:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289454;
        bh=ufToQkiASLa+rFF4Pj0uzl7m8luMgXz6oamPvsRC/RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqK/sWr3AdnBJNo4E0UfC5t532s11bslOjCflKXSd/vZBkJ9JZq+p1PGk1rfseOsH
         UtCPh2kS/LEVLTyZaUQMgJRgT3W8vULzAaqtR4VzN49PKeYgJjh+8ZaWErvib7QBSD
         zRU8lFueWUd3BR7oWp4JknQ9eVEwoGu6Ou4+eDlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Jan Kara <jack@suse.cz>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 088/173] fsdax: dedupe should compare the min of two iters length
Date:   Wed, 12 Apr 2023 10:33:34 +0200
Message-Id: <20230412082841.607329994@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shiyang Ruan <ruansy.fnst@fujitsu.com>

commit e900ba10d15041a6236cc75778cc6e06c3590a58 upstream.

In an dedupe comparison iter loop, the length of iomap_iter decreases
because it implies the remaining length after each iteration.

The dedupe command will fail with -EIO if the range is larger than one
page size and not aligned to the page size.  Also report warning in dmesg:

[ 4338.498374] ------------[ cut here ]------------
[ 4338.498689] WARNING: CPU: 3 PID: 1415645 at fs/iomap/iter.c:16
...

The compare function should use the min length of the current iters,
not the total length.

Link: https://lkml.kernel.org/r/1679469958-2-1-git-send-email-ruansy.fnst@fujitsu.com
Fixes: 0e79e3736d54 ("fsdax: dedupe: iter two files at the same time")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dax.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2022,8 +2022,8 @@ int dax_dedupe_file_range_compare(struct
 
 	while ((ret = iomap_iter(&src_iter, ops)) > 0 &&
 	       (ret = iomap_iter(&dst_iter, ops)) > 0) {
-		compared = dax_range_compare_iter(&src_iter, &dst_iter, len,
-						  same);
+		compared = dax_range_compare_iter(&src_iter, &dst_iter,
+				min(src_iter.len, dst_iter.len), same);
 		if (compared < 0)
 			return ret;
 		src_iter.processed = dst_iter.processed = compared;


