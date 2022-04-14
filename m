Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C1B50116D
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344728AbiDNODj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346187AbiDNN4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:56:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE95B0A5A;
        Thu, 14 Apr 2022 06:45:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2342B82985;
        Thu, 14 Apr 2022 13:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547CBC385A5;
        Thu, 14 Apr 2022 13:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943953;
        bh=8pB0J7RuG+0VRdERB0M6sy0avVjZh9WeAccoMSSevQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBzpGz4h4rjEpRqz7A4JsQcdoly8aVkVmio1RcUf75ryBCMprBqS2NMifAyrekNFE
         AFgQpIt00U0OUy41bLOYHnJmONppVUKEs6eIeh15BojnZnqfu8GZjX57bgLB1BGLRc
         CV7VitbvlD6wP2v2b/t1E7UfVHH5Cmjz3WPPWV1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.4 340/475] XArray: Update the LRU list in xas_split()
Date:   Thu, 14 Apr 2022 15:12:05 +0200
Message-Id: <20220414110904.597801199@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 3ed4bb77156da0bc732847c8c9df92454c1fbeea upstream.

When splitting a value entry, we may need to add the new nodes to the LRU
list and remove the parent node from the LRU list.  The WARN_ON checks
in shadow_lru_isolate() catch this oversight.  This bug was latent
until we stopped splitting folios in shrink_page_list() with commit
820c4e2e6f51 ("mm/vmscan: Free non-shmem folios without splitting them").
That allows the creation of large shadow entries, and subsequently when
trying to page in a small page, we will split the large shadow entry
in __filemap_add_folio().

Fixes: 8fc75643c5e1 ("XArray: add xas_split")
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/xarray.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1080,6 +1080,7 @@ void xas_split(struct xa_state *xas, voi
 					xa_mk_node(child));
 			if (xa_is_value(curr))
 				values--;
+			xas_update(xas, child);
 		} else {
 			unsigned int canon = offset - xas->xa_sibs;
 
@@ -1094,6 +1095,7 @@ void xas_split(struct xa_state *xas, voi
 	} while (offset-- > xas->xa_offset);
 
 	node->nr_values += values;
+	xas_update(xas, node);
 }
 EXPORT_SYMBOL_GPL(xas_split);
 #endif


