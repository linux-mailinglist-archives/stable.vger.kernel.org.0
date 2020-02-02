Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D97814FE70
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 18:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgBBRG4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 2 Feb 2020 12:06:56 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:52489 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726525AbgBBRG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 12:06:56 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20091882-1500050 
        for multiple; Sun, 02 Feb 2020 17:06:51 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Daniel Vetter <daniel@ffwll.ch>
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20200202164306.GQ43062@phenom.ffwll.local>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
References: <20200202161009.3969641-1-chris@chris-wilson.co.uk>
 <20200202164306.GQ43062@phenom.ffwll.local>
Message-ID: <158066320986.17828.7875090801235082375@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [PATCH] drm: Remove PageReserved manipulation from drm_pci_alloc
Date:   Sun, 02 Feb 2020 17:06:49 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Daniel Vetter (2020-02-02 16:43:06)
> On Sun, Feb 02, 2020 at 04:10:09PM +0000, Chris Wilson wrote:
> > drm_pci_alloc/drm_pci_free are very thin wrappers around the core dma
> > facilities, and we have no special reason within the drm layer to behave
> > differently. In particular, since
> > 
> > commit de09d31dd38a50fdce106c15abd68432eebbd014
> > Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Date:   Fri Jan 15 16:51:42 2016 -0800
> > 
> >     page-flags: define PG_reserved behavior on compound pages
> > 
> >     As far as I can see there's no users of PG_reserved on compound pages.
> >     Let's use PF_NO_COMPOUND here.
> > 
> > it has been illegal to combine GFP_COMP with SetPageReserved, so lets
> > stop doing both and leave the dma layer to its own devices.
> > 
> > Reported-by: Taketo Kabe
> > Closes: https://gitlab.freedesktop.org/drm/intel/issues/1027
> > Fixes: de09d31dd38a ("page-flags: define PG_reserved behavior on compound pages")
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: <stable@vger.kernel.org> # v4.5+
> 
> Given that after your i915 patch only mga and r128 still use this I think
> deleting code is the best action here.

drm_bufs.c has a little sting in its tail with the inclusion of the
drm_dma_handle struct in its seglist. Certainly after removing r128 we
can remove the EXPORT_SYMBOL and make it internal.
-Chris
