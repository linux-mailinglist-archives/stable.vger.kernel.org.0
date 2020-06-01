Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040251EA586
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 16:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgFAOFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 10:05:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:42473 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbgFAOFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 10:05:23 -0400
IronPort-SDR: uace8Q3geYRIbZpubwDJhgFrzi4/8jr72WSd9sXiy4hTMuiuwSvVrY2Z5fAUeAig5Dr2kW344/
 6Tp/fxf61zbA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2020 07:05:22 -0700
IronPort-SDR: WR34/KqDSTCDA2Z8DD9bQuyKXhAuTgGppnGjrPDBRdq5qKCL1g5HsDPrXi5jZIdaTkiXrSG4/L
 MvWpx4ev3Dmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,461,1583222400"; 
   d="scan'208";a="256784856"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 01 Jun 2020 07:05:20 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 5CF0023F; Mon,  1 Jun 2020 17:05:19 +0300 (EEST)
Date:   Mon, 1 Jun 2020 17:05:19 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     Yalin.Wang@sonymobile.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: FAILED: patch "[PATCH] mm: add VM_BUG_ON_PAGE() to
 page_mapcount()" failed to apply to 4.4-stable tree
Message-ID: <20200601140519.rm5lthhe6cf45567@black.fi.intel.com>
References: <159100964424864@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159100964424864@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 01:07:24PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Please don't.

The patch known to cause trouble and going to be effectively reverted:

https://lore.kernel.org/r/159032779896.957378.7852761411265662220.stgit@buzz

If you have it in any other stable queue, please drop it.

> ------------------ original commit in Linus's tree ------------------
> 
> From 1d148e218a0d0566b1c06f2f45f1436d53b049b2 Mon Sep 17 00:00:00 2001
> From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
> Date: Wed, 11 Feb 2015 15:24:48 -0800
> Subject: [PATCH] mm: add VM_BUG_ON_PAGE() to page_mapcount()
> 
> Add VM_BUG_ON_PAGE() for slab pages.  _mapcount is an union with slab
> struct in struct page, so we must avoid accessing _mapcount if this page
> is a slab page.  Also remove the unneeded bracket.
> 
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 8dd4fde9d2e5..c6bf813a6b3d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -484,7 +484,8 @@ static inline void page_mapcount_reset(struct page *page)
>  
>  static inline int page_mapcount(struct page *page)
>  {
> -	return atomic_read(&(page)->_mapcount) + 1;
> +	VM_BUG_ON_PAGE(PageSlab(page), page);
> +	return atomic_read(&page->_mapcount) + 1;
>  }
>  
>  static inline int page_count(struct page *page)
> 

-- 
 Kirill A. Shutemov
