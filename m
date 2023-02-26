Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD266A2E74
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 06:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjBZFo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 00:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBZFo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 00:44:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4823D301;
        Sat, 25 Feb 2023 21:44:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2815460C09;
        Sun, 26 Feb 2023 05:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F039C433EF;
        Sun, 26 Feb 2023 05:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677390295;
        bh=tdqNtzVVQiNAGo+d23F6Rjsew/mx9y+fMs7cnvra67Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bUJc72SJrw994D6SiFP/QwiH3zQiYfy1kslI+lGU7nvqzpKabCVnBbw9BA24jKb5o
         hpOl8KPp5GQVHbH5DWOWbG4VFm3uSaIlaRtbOnK3efzwU+nOjqzy7RNLXUb9o26qj4
         /wKMLNhcNv3WK7Rn4ylq7oawj9mzKoW6XZgeHMIU=
Date:   Sat, 25 Feb 2023 21:44:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     bhe@redhat.com, pmladek@suse.com, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, dyoung@redhat.com,
        d.hatayama@jp.fujitsu.com, feng.tang@intel.com,
        hidehiro.kawai.ez@hitachi.com, keescook@chromium.org,
        mikelley@microsoft.com, vgoyal@redhat.com, kernel-dev@igalia.com,
        kernel@gpiccoli.net, stable@vger.kernel.org
Subject: Re: [PATCH v4] panic: Fixes the panic_print NMI backtrace setting
Message-Id: <20230225214454.5eb25ff8a937a99d357c44ad@linux-foundation.org>
In-Reply-To: <20230210203510.1734835-1-gpiccoli@igalia.com>
References: <20230210203510.1734835-1-gpiccoli@igalia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Feb 2023 17:35:10 -0300 "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:

> Commit 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in panic_print")
> introduced a setting for the "panic_print" kernel parameter to allow
> users to request a NMI backtrace on panic. Problem is that the panic_print
> handling happens after the secondary CPUs are already disabled, hence
> this option ended-up being kind of a no-op - kernel skips the NMI trace
> in idling CPUs, which is the case of offline CPUs.
> 
> Fix it by checking the NMI backtrace bit in the panic_print prior to
> the CPU disabling function.
> 
> ...
> 
> Notice that while at it, I got rid of the "crash_kexec_post_notifiers"
> local copy in panic(). This was introduced by commit b26e27ddfd2a
> ("kexec: use core_param for crash_kexec_post_notifiers boot option"),
> but it is not clear from comments or commit message why this local copy
> is required.
> 
> My understanding is that it's a mechanism to prevent some concurrency,
> in case some other CPU modify this variable while panic() is running.
> I find it very unlikely, hence I removed it - but if people consider
> this copy needed, I can respin this patch and keep it, even providing a
> comment about that, in order to be explict about its need.

Only two sites change crash_kexec_post_notifiers, in
arch/powerpc/kernel/fadump.c and drivers/hv/hv_common.c.  Yes, it's
very unlikely that this will be altered while panic() is running and
the consequences will be slight anyway.

But formally, we shouldn't do this, especially in a -stable
backportable patch.  So please, let's have the minimal bugfix for now
and we can look at removing that local at a later time?

