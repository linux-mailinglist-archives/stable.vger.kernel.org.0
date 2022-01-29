Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811214A2E6B
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 12:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbiA2Lyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 06:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240332AbiA2Lyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 06:54:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49842C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 03:54:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EC36B822B2
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 11:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05563C340E5;
        Sat, 29 Jan 2022 11:54:47 +0000 (UTC)
Date:   Sat, 29 Jan 2022 11:54:44 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        D Scott Phillips <scott@os.amperecomputing.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH stable-5.9] arm64: errata: Fix exec handling in erratum
 1418040 workaround
Message-ID: <YfUrBOZxPGBiuzhY@arm.com>
References: <20220128185301.1729818-1-catalin.marinas@arm.com>
 <YfUpM5TE4rZVw6s1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfUpM5TE4rZVw6s1@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 12:46:59PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Jan 28, 2022 at 06:53:01PM +0000, Catalin Marinas wrote:
> > From: D Scott Phillips <scott@os.amperecomputing.com>
> > 
> > commit 38e0257e0e6f4fef2aa2966b089b56a8b1cfb75c upstream.
> > 
> > The erratum 1418040 workaround enables CNTVCT_EL1 access trapping in EL0
> > when executing compat threads. The workaround is applied when switching
> > between tasks, but the need for the workaround could also change at an
> > exec(), when a non-compat task execs a compat binary or vice versa. Apply
> > the workaround in arch_setup_new_exec().
> > 
> > This leaves a small window of time between SET_PERSONALITY and
> > arch_setup_new_exec where preemption could occur and confuse the old
> > workaround logic that compares TIF_32BIT between prev and next. Instead, we
> > can just read cntkctl to make sure it's in the state that the next task
> > needs. I measured cntkctl read time to be about the same as a mov from a
> > general-purpose register on N1. Update the workaround logic to examine the
> > current value of cntkctl instead of the previous task's compat state.
> > 
> > Fixes: d49f7d7376d0 ("arm64: Move handling of erratum 1418040 into C code")
> > Cc: <stable@vger.kernel.org> # 5.9.x
> 
> 5.9.x is long end-of-life, did you mean to do this for 5.10.y?

Ah, true, not sure how I ended up checking out the 5.9 stable branch
(maybe I had 4.9 in mind for an unrelated thing and just thought of
something .9).

I'll send you a backport to 5.10.

-- 
Catalin
