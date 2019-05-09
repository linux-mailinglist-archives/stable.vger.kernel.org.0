Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E9718F6E
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 19:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfEIRmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 13:42:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59174 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfEIRmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 13:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SWxiY7wLMkvGzgYZ4dhJCkizwo7IZKg5eY+l4keAF+w=; b=A+r+1MhWu/dkRNuFIgEnO64VI
        MbuTp1uF2SGZIS/b/4+Q9/wkGy8Nb8jCTAu4AqSvvfmbvfCLsn7yuBflpfI4fnGbLfbg2g0iiVcmN
        zowWbM+NicYMfTiL4lRHtDyOS/Bc5WsOiWTpXdx0l0jkNtyMI6YMzLLCguRIs1HglMamuA61hDuI5
        aEjceSgZhHv3m8sQeYir/8gDn0glrdEQtRSvP+DeboAUNaXnkJzr1qjIPkcnsdI5PQEVv6fxLJuP2
        8il84ihcOElvpUkBREhm6AqLzH295tN0gomSEbRmxJ8UB6xOGLHnY+napd6YJwhAz/mJU8DmwaJSJ
        5en8emtJg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hOn3k-0006iG-S4; Thu, 09 May 2019 17:42:20 +0000
Date:   Thu, 9 May 2019 10:42:20 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     akpm@linux-foundation.org, stable@vger.kernel.org,
        Piotr Balcer <piotr.balcer@intel.com>,
        Yan Ma <yan.ma@intel.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Chandan Rajendra <chandan@linux.ibm.com>,
        Jan Kara <jack@suse.cz>,
        Souptick Joarder <jrdr.linux@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: Fix vmf_insert_pfn_{pmd, pud}() crash,
 handle unaligned addresses
Message-ID: <20190509174220.GA6235@bombadil.infradead.org>
References: <155741946350.372037.11148198430068238140.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155741946350.372037.11148198430068238140.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 09:31:41AM -0700, Dan Williams wrote:
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index e428468ab661..996d68ff992a 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -184,8 +184,7 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
> +	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);

I think we can ditch the third parameter too.  Going through the callers ...

> @@ -235,8 +234,7 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
> +	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);

> @@ -1575,8 +1575,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
> +		result = vmf_insert_pfn_pmd(vmf, pfn, write);

This 'write' parameter came earlier from:

        bool write = vmf->flags & FAULT_FLAG_WRITE;

and it is not modified subsequently.

> @@ -1686,8 +1685,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
> +		ret = vmf_insert_pfn_pmd(vmf, pfn, FAULT_FLAG_WRITE);

If FAULT_FLAG_WRITE is not set in a mkwrite handler, I don't know
what's gone wrong with the world.

Even without these changes,

Reviewed-by: Matthew Wilcox <willy@infradead.org>
