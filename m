Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF505F294A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiJCHRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiJCHQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:16:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527A740E25;
        Mon,  3 Oct 2022 00:13:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA001B80E6A;
        Mon,  3 Oct 2022 07:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182B3C433D6;
        Mon,  3 Oct 2022 07:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781221;
        bh=X8HBuCkoqw+yFs+sNyv9u+U5y3+61Xxi/ip1jmfXBUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krpKYOciYJl6ZqiYcBQaUr4oCV6l2EDfc7SzukTUrtUyhtf89cUrV2mc69DU6Uzae
         ivhPOl28k8nyhtPJLL6a8frxeCoyu7HgRKIQz0RNU5HJYIwhRRxU9vCD5UQdcWWTRt
         DwGln77/vauutDiVrYloJQWkF/dRHTBcvfFKk5Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alex Sierra <alex.sierra@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Karol Herbst <kherbst@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Lyude Paul <lyude@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 041/101] mm/migrate_device.c: add missing flush_cache_page()
Date:   Mon,  3 Oct 2022 09:10:37 +0200
Message-Id: <20221003070725.488962594@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>

commit a3589e1d5fe39c3d9fdd291b111524b93d08bc32 upstream.

Currently we only call flush_cache_page() for the anon_exclusive case,
however in both cases we clear the pte so should flush the cache.

Link: https://lkml.kernel.org/r/5676f30436ab71d1a587ac73f835ed8bd2113ff5.1662078528.git-series.apopple@nvidia.com
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -187,9 +187,9 @@ again:
 			bool anon_exclusive;
 			pte_t swp_pte;
 
+			flush_cache_page(vma, addr, pte_pfn(*ptep));
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
-				flush_cache_page(vma, addr, pte_pfn(*ptep));
 				ptep_clear_flush(vma, addr, ptep);
 
 				if (page_try_share_anon_rmap(page)) {


