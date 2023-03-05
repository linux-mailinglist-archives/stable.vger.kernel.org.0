Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED9C6AAD91
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 01:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCEAAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 19:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCEAAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 19:00:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A63196B7;
        Sat,  4 Mar 2023 16:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GFZU3Vr031k0W6AOiBuxkRp/WomquZxxmMw7RSoYHIA=; b=mFptCZUCgRYLzFH1ts+We08mpb
        hEMOVNREw6u+CJkwBA3vzRQ6lqpmgxsVNX8toK5l0rtpeilw1wSZQLxqgwnBzpHSwsHklzEuAVfC8
        42TcF0GiKHIh/Gb+Vj9jDxHd3wXRsq1IcN0Bsp6lFLVHlmsYZRkr3/nZ3x45+hocFrzkeLGUc7S8M
        teCVj5FJ3MzpUSODowjI6rCwia4u4Fc8Tqlw+9TQxnB+FfhIh03iqCD7LqnTSdSO+cgDTQmNAJrtk
        +wrA2hN5JK/Uj7o/ifYxz3jVYoC8JBMv7q+EbkgVeamd51qd5Tc77LBtmWK/M/dn+BxrhJsrfPOCY
        8pccAU3A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pYbnY-0047NX-Qn; Sun, 05 Mar 2023 00:00:20 +0000
Date:   Sun, 5 Mar 2023 00:00:20 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/paddr: fix folio_size() call after
 folio_put() in damon_pa_young()
Message-ID: <ZAPblL0G6JkekBtU@casper.infradead.org>
References: <20230304193949.296391-1-sj@kernel.org>
 <20230304193949.296391-2-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230304193949.296391-2-sj@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 04, 2023 at 07:39:48PM +0000, SeongJae Park wrote:
> damon_pa_young() is accessing a folio via folio_size() after folio_put()
> for the folio has invoked.  Fix it.
> 
> Fixes: 397b0c3a584b ("mm/damon/paddr: remove folio_sz field from damon_pa_access_chk_result")
> Cc: <stable@vger.kernel.org> # 6.3.x
> Signed-off-by: SeongJae Park <sj@kernel.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
