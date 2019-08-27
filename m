Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE69E9DB6A
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 03:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbfH0BzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 21:55:02 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40765 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbfH0BzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 21:55:02 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46HX4f0vmjz9s00;
        Tue, 27 Aug 2019 11:54:58 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     David Sterba <dsterba@suse.cz>, Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, Christophe Leroy <christophe.leroy@c-s.fr>,
        erhard_f@mailbox.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix allocation of bitmap pages.
In-Reply-To: <20190826164646.GX2752@twin.jikos.cz>
References: <c3157c8e8e0e7588312b40c853f65c02fe6c957a.1566399731.git.christophe.leroy@c-s.fr> <20190826153757.GW2752@twin.jikos.cz> <a096d653-8b64-be15-3e81-581536a88e8a@suse.com> <20190826164646.GX2752@twin.jikos.cz>
Date:   Tue, 27 Aug 2019 11:54:57 +1000
Message-ID: <871rx74bke.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David Sterba <dsterba@suse.cz> writes:
> On Mon, Aug 26, 2019 at 06:40:24PM +0300, Nikolay Borisov wrote:
>> >> Link: https://bugzilla.kernel.org/show_bug.cgi?id=204371
>> >> Fixes: 69d2480456d1 ("btrfs: use copy_page for copying pages instead of memcpy")
>> >> Cc: stable@vger.kernel.org
>> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> >> ---
>> >> v2: Using kmem_cache instead of get_zeroed_page() in order to benefit from SLAB debugging features like redzone.
>> > 
>> > I'll take this version, thanks. Though I'm not happy about the allocator
>> > behaviour. The kmem cache based fix can be backported independently to
>> > 4.19 regardless of the SL*B fixes.
>> > 
>> >> +extern struct kmem_cache *btrfs_bitmap_cachep;
>> > 
>> > I've renamed the cache to btrfs_free_space_bitmap_cachep
>> > 
>> > Reviewed-by: David Sterba <dsterba@suse.com>
>> 
>> Isn't this obsoleted by
>> 
>> '[PATCH v2 0/2] guarantee natural alignment for kmalloc()' ?
>
> Yeah, but this would add maybe another whole dev cycle to merge and
> release. The reporters of the bug seem to care enough to identify the
> problem and propose the fix so I feel like adding the btrfs-specific fix
> now is a little favor we can afford.
>
> The bug is reproduced on an architecture that's not widely tested so
> from practical POV I think this adds more coverage which is desirable.

Thanks.

cheers
