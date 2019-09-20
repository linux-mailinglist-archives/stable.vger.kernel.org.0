Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D69B8FD3
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 14:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409009AbfITMaY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 20 Sep 2019 08:30:24 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:58007 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2409008AbfITMaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 08:30:24 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 18559024-1500050 
        for multiple; Fri, 20 Sep 2019 13:30:22 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <156898213374.1196.4409741985922996220@skylake-alporthouse-com>
Cc:     Matthew Auld <matthew.william.auld@gmail.com>,
        =?utf-8?b?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        stable@vger.kernel.org
References: <20190920121821.7223-1-chris@chris-wilson.co.uk>
 <156898213374.1196.4409741985922996220@skylake-alporthouse-com>
Message-ID: <156898262040.1196.10325037059820148075@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [PATCH] drm/i915: Mark contents as dirty on a write fault
Date:   Fri, 20 Sep 2019 13:30:20 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2019-09-20 13:22:13)
> Quoting Chris Wilson (2019-09-20 13:18:21)
> > Since dropping the set-to-gtt-domain in commit a679f58d0510 ("drm/i915:
> > Flush pages on acquisition"), we no longer mark the contents as dirty on
> > a write fault. This has the issue of us then not marking the pages as
> > dirty on releasing the buffer, which means the contents are not written
> > out to the swap device (should we ever pick that buffer as a victim).
> > Notably, this is visible in the dumb buffer interface used for cursors.
> > Having updated the cursor contents via mmap, and swapped away, if the
> > shrinker should evict the old cursor, upon next reuse, the cursor would
> > be invisible.
> 
> Hmm, I think the dumb interface may be missing a few steps around the
> place to ensure the contents are flushed.

No, it's fine. We do the flush in pinning pages, the only thing that was
dropped was then marking the content as dirty.
-Chris
