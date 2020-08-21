Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675C624D422
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 13:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgHULiS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 21 Aug 2020 07:38:18 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:60194 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728298AbgHULiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 07:38:11 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22197337-1500050 
        for multiple; Fri, 21 Aug 2020 12:38:05 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <159800635942.29194.13489565974587679781@build.alporthouse.com>
References: <20200821085011.28878-1-chris@chris-wilson.co.uk> <20200821100902.GG3354@suse.de> <159800481672.29194.17217138842959831589@build.alporthouse.com> <20200821102343.GI3354@suse.de> <159800635942.29194.13489565974587679781@build.alporthouse.com>
Subject: Re: [PATCH] mm: Track page table modifications in __apply_to_page_range() construction
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>, stable@vger.kernel.org
To:     Joerg Roedel <jroedel@suse.de>
Date:   Fri, 21 Aug 2020 12:38:03 +0100
Message-ID: <159800988352.29194.8498025838223804532@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2020-08-21 11:39:19)
> Quoting Joerg Roedel (2020-08-21 11:23:43)
> > On Fri, Aug 21, 2020 at 11:13:36AM +0100, Chris Wilson wrote:
> > > We need to store the initial addr, as here addr == end [or earlier on
> > > earlier], so range is (start, addr).
> > 
> > Right, I missed that, thanks for pointing it out.
> 
> And with that (start, addr)
> 
> Tested-by: Chris Wilson <chris@chris-wilson.co.uk> #x86-32

In the version I tested, I also had

@@ -2216,7 +2216,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,

        if (create) {
                pte = (mm == &init_mm) ?
-                       pte_alloc_kernel(pmd, addr) :
+                       pte_alloc_kernel_track(pmd, addr, mask) :
                        pte_alloc_map_lock(mm, pmd, addr, &ptl);
                if (!pte)
                        return -ENOMEM;

And that PGTBL_PMD_MODIFIED makes a difference.
-Chris
