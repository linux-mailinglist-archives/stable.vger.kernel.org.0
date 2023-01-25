Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D672167B9C1
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 19:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbjAYSou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 13:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbjAYSo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 13:44:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D2554219;
        Wed, 25 Jan 2023 10:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4CB7615B2;
        Wed, 25 Jan 2023 18:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C55C433EF;
        Wed, 25 Jan 2023 18:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674672265;
        bh=3u6/lxS5IX3ovbSHqGpPThtcCTCs5Ru+lWTUelavCI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cGEb8BIpcGeoG4Zi9MwvRUN+6VCTdNaT/rqz7/XbpCPWimYRZld4Gc6Zy43UP3ON3
         kbk3DuPb+7D9JHHAkaOyPdUH3V4+gn03Gcp3tpzMQ+/kH4V9VjRgelf6qM4NQ2ARCa
         zzevjCFzM7rgGgTzU2P72byK+nUzrJ07XDJZqlv6uKpljRCFfbOL1MEhCzpo9Z2fwu
         sotiy6aN8z3w6aycCnIyxiiW2JJcTROMpiGlZJ44EGeo1xvdyTypf5NVO9WkwxlG9F
         Y2HLJMQAay5jY4r99mrAGzUhOZ5bhlHgP9DfMqPCplJ6AJyhVfDMHD7AvRxujYds9s
         0KjIBsfrFh+Hw==
Date:   Wed, 25 Jan 2023 10:44:23 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 5.15 13/20] exit: Put an upper limit on how often we can
 oops
Message-ID: <Y9F4hxtZnE2GssUo@sol.localdomain>
References: <20230124185110.143857-1-ebiggers@kernel.org>
 <20230124185110.143857-14-ebiggers@kernel.org>
 <033ca877-5091-cbfb-6e6c-e49c4adb9a10@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <033ca877-5091-cbfb-6e6c-e49c4adb9a10@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Harshit,

On Wed, Jan 25, 2023 at 07:39:10PM +0530, Harshit Mogalapalli wrote:
> 
> Thanks for the backports.
> 
> I have tried backporting the oops_limit patches to LTS 5.15.y and had a
> similar set of patches, just want to add a note here on an alternate way for
> backporting this patch without resolving conflicts manually:
> 
> Here is the sequence:
> 
> * Patch 12:  [panic: Separate sysctl logic from CONFIG_SMP]
> --> Cherry-pick Commit: 05ea0424f0e2 ("exit: Move oops specific logic from
> do_exit into make_task_dead") upstream
> --> Cherry-pick Commit: de77c3a5b95c ("exit: Move force_uaccess back into
> do_exit") upstream
> * Patch 13 which is Commit: d4ccd54d28d3 ("exit: Put an upper limit on how
> often we can oops") upstream, will be a clean cherry-pick.
> 
> The benefit may be making future backports simpler in make_task_dead().
> 
> This was the only difference, so your backport looks good to me.
> 

It's certainly an option.  The reason why I didn't do it that way is to reduce
the impact of any potential bugs where do_exit() is still called when the new
make_task_dead() function should be used instead.  With my series, the effect is
just that oops_limit won't take effect in such cases.  If we also backported
commit 05ea0424f0e2 ("exit: Move oops specific logic from do_exit into
make_task_dead"), then do_exit() will lose various other things, such as
panicing when called from an interrupt handler.  That would increase the chance
of regressions, unless we made absolutely sure that everywhere that should be
using make_task_dead() is indeed using it instead of do_exit().

Commit 0e25498f8cd4 ("exit: Add and use make_task_dead."), which I backported,
did the vast majority of conversions to make_task_dead().

Some architectures still have uses of do_exit() that got cleaned up later,
though.  It seems it was mostly unreachable code, and some cases that should
have been doing something else such as BUG() or sending a signal to userspace.
So, generally not super important cases.

Still, getting all that would bring in many more patches.  We could do that, but
since this is already a 20-patch series, I wanted to limit the scope a bit.
These extra patches could always be backported later on top of this if desired.

- Eric
