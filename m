Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570BA4F29F6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241099AbiDEKKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346539AbiDEJYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:24:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55847DAFE5;
        Tue,  5 Apr 2022 02:13:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01C66B81C15;
        Tue,  5 Apr 2022 09:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AE5C385A2;
        Tue,  5 Apr 2022 09:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150019;
        bh=ddMf/Q2OYNRAJxNBRf3ZcvSR2v8ceJNOuWDRf7eIQjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9684rb47wAOusW4DfFvYSh3ASdtetgjwsX05Iy5kAie4hhphBlyw/DvR1u8brm2G
         6CXV2k/hTDTmEd7jNmjyWqpm9cpZ16HRty35Ae1dmrg2Qw0i1FqUZLpE3U7LCw40hJ
         ZI0DLnUG/JTFvp0ebrRu3IJ6dr6zanwPI3u3Ncy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.16 0926/1017] XArray: Update the LRU list in xas_split()
Date:   Tue,  5 Apr 2022 09:30:39 +0200
Message-Id: <20220405070421.703881433@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
@@ -1081,6 +1081,7 @@ void xas_split(struct xa_state *xas, voi
 					xa_mk_node(child));
 			if (xa_is_value(curr))
 				values--;
+			xas_update(xas, child);
 		} else {
 			unsigned int canon = offset - xas->xa_sibs;
 
@@ -1095,6 +1096,7 @@ void xas_split(struct xa_state *xas, voi
 	} while (offset-- > xas->xa_offset);
 
 	node->nr_values += values;
+	xas_update(xas, node);
 }
 EXPORT_SYMBOL_GPL(xas_split);
 #endif


