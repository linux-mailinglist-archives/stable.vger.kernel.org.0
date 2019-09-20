Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE92B8FAF
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 14:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408899AbfITMWS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 20 Sep 2019 08:22:18 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:51986 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2406276AbfITMWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 08:22:18 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 18558906-1500050 
        for multiple; Fri, 20 Sep 2019 13:22:15 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20190920121821.7223-1-chris@chris-wilson.co.uk>
Cc:     Matthew Auld <matthew.william.auld@gmail.com>,
        =?utf-8?b?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        stable@vger.kernel.org
References: <20190920121821.7223-1-chris@chris-wilson.co.uk>
Message-ID: <156898213374.1196.4409741985922996220@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [PATCH] drm/i915: Mark contents as dirty on a write fault
Date:   Fri, 20 Sep 2019 13:22:13 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2019-09-20 13:18:21)
> Since dropping the set-to-gtt-domain in commit a679f58d0510 ("drm/i915:
> Flush pages on acquisition"), we no longer mark the contents as dirty on
> a write fault. This has the issue of us then not marking the pages as
> dirty on releasing the buffer, which means the contents are not written
> out to the swap device (should we ever pick that buffer as a victim).
> Notably, this is visible in the dumb buffer interface used for cursors.
> Having updated the cursor contents via mmap, and swapped away, if the
> shrinker should evict the old cursor, upon next reuse, the cursor would
> be invisible.

Hmm, I think the dumb interface may be missing a few steps around the
place to ensure the contents are flushed.
-Chris
