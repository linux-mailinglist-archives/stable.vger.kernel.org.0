Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8EB9546E
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 04:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfHTCar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 22:30:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56210 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbfHTCar (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 22:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uPXPHVEYMLe1+2GVdYIOdPqr5CMV8EsylIRmKkmRT3Q=; b=mH0VY+ovyP9mQQyeA2pygVd+6
        jlgtHzACKYGkOPyDVHPZ1PjKaSFzvetqdR5EDtZcKQm5AZEUs7VM7R3dfG5jl0z5n+Ie4leAPKsGJ
        u/vM7LKI6mT/GNbP7XvILp+P6nx6S71Mv/CoaZ8idyC8hOQQZ3gwCUl+ZL/B2nzffjhxYzGyJWJNx
        KkcWSK7fwws93Q69B/L7lCriRIvh7VSGlJDyi2G4DHiyHNQM5dJK2HV73vxCCrwNwGaSZCu3Wc5P1
        McDsO+eyJSOiseL+x6zSQ+MN5Ix3KK3HW8EocfpujB8ickMfRLColHq2KFtkfRL3/UjGP4IDHSW+j
        s8IxFRwEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hztup-0001lf-QO; Tue, 20 Aug 2019 02:30:31 +0000
Date:   Mon, 19 Aug 2019 19:30:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     dsterba@suse.cz, Christophe Leroy <christophe.leroy@c-s.fr>,
        erhard_f@mailbox.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix allocation of bitmap pages.
Message-ID: <20190820023031.GC9594@infradead.org>
References: <20190817074439.84C6C1056A3@localhost.localdomain>
 <20190819174600.GN24086@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819174600.GN24086@twin.jikos.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 07:46:00PM +0200, David Sterba wrote:
> Another thing that is lost is the slub debugging support for all
> architectures, because get_zeroed_pages lacking the red zones and sanity
> checks.
> 
> I find working with raw pages in this code a bit inconsistent with the
> rest of btrfs code, but that's rather minor compared to the above.
> 
> Summing it up, I think that the proper fix should go to copy_page
> implementation on architectures that require it or make it clear what
> are the copy_page constraints.

The whole point of copy_page is to copy exactly one page and it makes
sense to assume that is aligned.  A sane memcpy would use the same
underlying primitives as well after checking they fit.  So I think the
prime issue here is btrfs' use of copy_page instead of memcpy.  The
secondary issue is slub fucking up alignments for no good reason.  We
just got bitten by that crap again in XFS as well :(
