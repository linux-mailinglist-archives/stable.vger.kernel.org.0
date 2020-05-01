Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47041C10FE
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 12:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgEAKmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 06:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728268AbgEAKmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 06:42:22 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317D3C08E859;
        Fri,  1 May 2020 03:42:22 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jUT7Y-0003fF-19; Fri, 01 May 2020 12:42:16 +0200
Date:   Fri, 1 May 2020 12:42:15 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, tglx@linutronix.de,
        chris@chris-wilson.co.uk, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: check to see if SIMD registers are available
 before using SIMD
Message-ID: <20200501104215.s2eftchxm66lmbvj@linutronix.de>
References: <20200430221016.3866-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200430221016.3866-1-Jason@zx2c4.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-04-30 16:10:16 [-0600], Jason A. Donenfeld wrote:
> Sometimes it's not okay to use SIMD registers, the conditions for which
> have changed subtly from kernel release to kernel release. Usually the
> pattern is to check for may_use_simd() and then fallback to using
> something slower in the unlikely case SIMD registers aren't available.
> So, this patch fixes up i915's accelerated memcpy routines to fallback
> to boring memcpy if may_use_simd() is false.

That would indicate that these functions are used from IRQ/softirq which
break otherwise if the kernel is also using the registers. The crypto
code uses it for that purpose.

So
   Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

May I ask how large the memcpy can be? I'm asking in case it is large
and an explicit rescheduling point might be needed.

> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Sebastian
