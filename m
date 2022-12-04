Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E20641B87
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 09:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLDIVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 03:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiLDIVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 03:21:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDED164BE
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 00:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F496B80066
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 08:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2784BC433C1;
        Sun,  4 Dec 2022 08:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670142087;
        bh=uPp4tolj7bXQHMRl5uWups9Rq9kBNg239XQLSfieY3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K5/d0yfd8BYqMoOl+R7Jj3fE3gkwtQsHbu4XtRmAovuWqeAZ8OIW4r2IDrCl+gaRl
         1nzRwcPk3wYhuqzFaJgEirxAqZADuS0J5M+x6I0ncrcC74NhAjCr0crdYaGPFcV5BG
         LDCCFsOUmE2URWW+j1JUBR2olMCytAwAopgFIuuw=
Date:   Sun, 4 Dec 2022 09:21:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org,
        yujie.liu@intel.com, zhengyejian1@huawei.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Free buffers when a used dynamic
 event is removed" failed to apply to 4.19-stable tree
Message-ID: <Y4xYg2i7lS6z3eIe@kroah.com>
References: <167006641591124@kroah.com>
 <20221203173655.1b1b2fac@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221203173655.1b1b2fac@gandalf.local.home>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 03, 2022 at 05:36:55PM -0500, Steven Rostedt wrote:
> On Sat, 03 Dec 2022 12:20:15 +0100
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > Possible dependencies:
> > 
> > 4313e5a61304 ("tracing: Free buffers when a used dynamic event is removed")
> 
> Hmm, isn't the above the patch that failed to apply?

yes, tools are not the smartest at times :)

> > 5448d44c3855 ("tracing: Add unified dynamic event framework")
> 
> And this is mentioned below.
> 
> [..]
> 
> > If any dynamic event that is being removed was enabled, then make sure the
> > buffers they were enabled in are now cleared.
> > 
> > Link: https://lkml.kernel.org/r/20221123171434.545706e3@gandalf.local.home
> > Link: https://lore.kernel.org/all/20221110020319.1259291-1-zhengyejian1@huawei.com/
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Depends-on: e18eb8783ec49 ("tracing: Add tracing_reset_all_online_cpus_unlocked() function")
> 
> > Depends-on: 5448d44c38557 ("tracing: Add unified dynamic event framework")
> 
> ^^^

Did you just make up a new field?  We have a documented way to show
dependancies for stable patches, please let's not create a new one :(

> > Depends-on: 6212dd29683ee ("tracing/kprobes: Use dyn_event framework for kprobe events")
> > Depends-on: 065e63f951432 ("tracing: Only have rmmod clear buffers that its events were active in")
> > Depends-on: 575380da8b469 ("tracing: Only clear trace buffer on module unload if event was traced")
> > Fixes: 77b44d1b7c283 ("tracing/kprobes: Rename Kprobe-tracer to kprobe-event")

Adding the "unified framework" seems like way too much for a stable
patch, are you sure all of these are required and should be applied to
4.19.y?

thanks,

greg k-h
