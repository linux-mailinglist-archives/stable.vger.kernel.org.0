Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB8448B2F4
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 18:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244043AbiAKRLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 12:11:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35170 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242530AbiAKRLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 12:11:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EF01B81C1F;
        Tue, 11 Jan 2022 17:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02511C36AEB;
        Tue, 11 Jan 2022 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641921059;
        bh=GhDvYFZGPRT80b9dqotfwgVnldQY1ncyLaPdagj1mBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XBiJhLA6JzUOHUpzbouhgmeQVRu+bwMItqkjG6cf0SxClEMTTly5zRh+oWRBl56Md
         pyDu9y4JwuQU61iJ0U4TQZ8+VX1BIT78IfibtQeTyj1ubVQlc0iuS6SFiuIXIOsANK
         nC8WJwG/1aFSvvUxsr8bdev/yCK/wSEr8Y/GTCyJNxsTJK4DVTSZnnSP9MTjg61TrX
         tbJZOWozAUodS3Mfw4BKdKSgjCDNuFQgNRLmr5dFI7z4mgRRwK61AdkLrjGV1fmuw2
         sukPzbZE+dg8Cc2EDdJpOKOREVNPPKbiE8M2LQrlfQJlqebaS8f17PF+bIPBxHUAfa
         I5l11pCGl/+sA==
Date:   Tue, 11 Jan 2022 19:10:52 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Christian Dietrich <christian.dietrich@tuhh.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/pgtable: define pte_index so that preprocessor could
 recognize it
Message-ID: <Yd26HEL4PvKdSaTQ@kernel.org>
References: <20220111145457.20748-1-rppt@kernel.org>
 <s7bzgo2cn99.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s7bzgo2cn99.fsf@dokucode.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christian,

On Tue, Jan 11, 2022 at 04:20:34PM +0100, Christian Dietrich wrote:
> Hello Mike!
> 
> Mike Rapoport <rppt@kernel.org> [11. Januar 2022]:
> 
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index e24d2c992b11..d468efcf48f4 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -62,6 +62,7 @@ static inline unsigned long pte_index(unsigned long address)
> >  {
> >  	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
> >  }
> > +#define pte_index pte_index
> 
> Wouldn't it make sense to remove the dead CPP blocks (#ifdef pte_index)
> from mm/memory.c? 

It does make sense to remove the dead code, but this cleanup does not need
stable backporting so it'll be a separate patch.

Care to send a patch? ;-)

> Or is there a case were pte_index is not defined for an architecture?

Nope, the fix in include/linux/pgtable.h covers MMU architectures and NOMMU
do not compile mm/memory.c anyway.

> chris
> -- 

-- 
Sincerely yours,
Mike.
