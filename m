Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06ABE55E06B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbiF0LuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237679AbiF0LrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:47:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B97DFF7;
        Mon, 27 Jun 2022 04:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E927CB81132;
        Mon, 27 Jun 2022 11:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDEBC3411D;
        Mon, 27 Jun 2022 11:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329952;
        bh=iPaPXnO6femvThk7XxvLCJLoVOjfA2IJ8p6/aAO9ZOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuUPajohaFyOMtOfuq5anb7Bm7J2FragaOcilzvuo0L5JqrUwg8zKZh0oXHAO5P9j
         vtE7pkXeg6qb/8iKntu6IxoJStBZF71pj7czQcwczD1tjNC2iDsxHIcp/BQQlJjlEB
         svae8CDMHa6Tc1uv9Yh1NfcIE5I0X1ZKlKAMtBn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.18 033/181] filemap: Handle sibling entries in filemap_get_read_batch()
Date:   Mon, 27 Jun 2022 13:20:06 +0200
Message-Id: <20220627111945.522910063@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit cb995f4eeba9d268fd4b56c2423ad6c1d1ea1b82 upstream.

If a read races with an invalidation followed by another read, it is
possible for a folio to be replaced with a higher-order folio.  If that
happens, we'll see a sibling entry for the new folio in the next iteration
of the loop.  This manifests as a NULL pointer dereference while holding
the RCU read lock.

Handle this by simply returning.  The next call will find the new folio
and handle it correctly.  The other ways of handling this rare race are
more complex and it's just not worth it.

Reported-by: Dave Chinner <david@fromorbit.com>
Reported-by: Brian Foster <bfoster@redhat.com>
Debugged-by: Brian Foster <bfoster@redhat.com>
Tested-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2385,6 +2385,8 @@ static void filemap_get_read_batch(struc
 			continue;
 		if (xas.xa_index > max || xa_is_value(folio))
 			break;
+		if (xa_is_sibling(folio))
+			break;
 		if (!folio_try_get_rcu(folio))
 			goto retry;
 


