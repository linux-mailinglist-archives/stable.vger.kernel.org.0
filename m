Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789761B1137
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 18:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgDTQPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 12:15:18 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54897 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgDTQPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 12:15:18 -0400
Received: by mail-pj1-f66.google.com with SMTP id np9so53109pjb.4;
        Mon, 20 Apr 2020 09:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mKMIW3mEg5t1gLoJ6mz8YW5V5YHdFX18CfmBOsT8+DM=;
        b=f7Ti89jI8mxJ++RbVIzArU4aCIEPh2c72uCntV4+3RouLxK7sEZBvt+6OnCYrx6e4c
         MdFybnbC7fdPiafrm3LmvP1xu/0VFNOkVfnV5Y35HpjYxocBMleKj1IUrIma8cc4LYuY
         XO67BjJrs5if1zVZGqpE23u8n10aS5YSECe3URm61+tcpnisZgsPZU2BsHcjpsYbhe9T
         ZXvbiVZLFSJLP23APR0r6aBIujdvAfQZBLRDyqlj4rCeqoV9TkvbuIo6fN9fcZ9g0oox
         FKqujgWDDMAitHe/ewdxdInmeJwAlBaHKl7rS9WPewzyqBZC7je0tIt+TvchrFLe1TRF
         7pmA==
X-Gm-Message-State: AGi0Pub8xibp06D0DzIgpYwu1wm2LyA1NuuxSHnaeNITk6Pi5CxphHwF
        oFqZyM52QOIvakJPOxp3O6jcVnfw
X-Google-Smtp-Source: APiQypIo65I60EmrvJr0Fn9k464/b4BsdAENW1ihErA04xVYqn/vV5ywXSVnzlYGX6PHk/VUYYyFKA==
X-Received: by 2002:a17:90a:890a:: with SMTP id u10mr161799pjn.154.1587399317254;
        Mon, 20 Apr 2020 09:15:17 -0700 (PDT)
Received: from sultan-box.localdomain ([104.200.129.62])
        by smtp.gmail.com with ESMTPSA id o1sm48749pjs.35.2020.04.20.09.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:15:16 -0700 (PDT)
Date:   Mon, 20 Apr 2020 09:15:14 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Auld <matthew.auld@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] drm/i915: Synchronize active and retire callbacks
Message-ID: <20200420161514.GB1963@sultan-box.localdomain>
References: <20200404024156.GA10382@sultan-box.localdomain>
 <20200407064007.7599-1-sultan@kerneltoast.com>
 <20200414061312.GA90768@sultan-box.localdomain>
 <158685263618.16269.9317893477736764675@build.alporthouse.com>
 <20200414144309.GB2082@sultan-box.localdomain>
 <20200420052419.GA40250@sultan-box.localdomain>
 <158737090265.8380.6644489879531344891@jlahtine-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158737090265.8380.6644489879531344891@jlahtine-desk.ger.corp.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 11:21:42AM +0300, Joonas Lahtinen wrote:
> So it seems that the patch got pulled into v5.6 and has been backported
> to v5.5 but not v5.4.

You're right, that's my mistake.

> In doing that zeroing of ring->vaddr is removed so the test to do mdelay(1)
> and "ring->vaddr = NULL;" is not correct.

I'm not so sure about this. Look at where `ring->vaddr` is assigned:
-------------------------------------8<-----------------------------------------
	ret = i915_vma_pin(vma, 0, 0, flags);
	if (unlikely(ret))
		goto err_unpin;

	if (i915_vma_is_map_and_fenceable(vma))
		addr = (void __force *)i915_vma_pin_iomap(vma);
	else
		addr = i915_gem_object_pin_map(vma->obj,
					       i915_coherent_map_type(vma->vm->i915));
	if (IS_ERR(addr)) {
		ret = PTR_ERR(addr);
		goto err_ring;
	}

	i915_vma_make_unshrinkable(vma);

	/* Discard any unused bytes beyond that submitted to hw. */
	intel_ring_reset(ring, ring->emit);

	ring->vaddr = addr;
------------------------------------->8-----------------------------------------

And then the converse of that is done *before* my reproducer patch does
`ring->vaddr = NULL;`:
-------------------------------------8<-----------------------------------------
	i915_vma_unset_ggtt_write(vma);
	if (i915_vma_is_map_and_fenceable(vma))
		i915_vma_unpin_iomap(vma);
	else
		i915_gem_object_unpin_map(vma->obj);

	/* mdelay(1);
	ring->vaddr = NULL; */

	i915_vma_make_purgeable(vma);
	i915_vma_unpin(vma);
------------------------------------->8-----------------------------------------

Isn't the value assigned to `ring->vaddr` trashed by those function calls above
where I've got the mdelay? If so, why would it be correct to let the stale value
sit in `ring->vaddr`?

My interpretation of the zeroing of ring->vaddr being removed by Chris was that
it was an unnecessary step before the ring was getting discarded anyway.

Sultan
