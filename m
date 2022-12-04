Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6D4641DD4
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 17:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiLDQPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 11:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiLDQO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 11:14:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9081403C
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 08:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D2A3B80AC6
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 16:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EDDC433D7;
        Sun,  4 Dec 2022 16:14:52 +0000 (UTC)
Date:   Sun, 4 Dec 2022 11:14:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org,
        yujie.liu@intel.com, zhengyejian1@huawei.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Free buffers when a used
 dynamic event is removed" failed to apply to 4.19-stable tree
Message-ID: <20221204111451.2741a499@gandalf.local.home>
In-Reply-To: <Y4xYg2i7lS6z3eIe@kroah.com>
References: <167006641591124@kroah.com>
        <20221203173655.1b1b2fac@gandalf.local.home>
        <Y4xYg2i7lS6z3eIe@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 4 Dec 2022 09:21:23 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> > > 5448d44c3855 ("tracing: Add unified dynamic event framework")  
> > 
> > And this is mentioned below.
> > 
> > [..]
> >   
> > > If any dynamic event that is being removed was enabled, then make sure the
> > > buffers they were enabled in are now cleared.
> > > 
> > > Link: https://lkml.kernel.org/r/20221123171434.545706e3@gandalf.local.home
> > > Link: https://lore.kernel.org/all/20221110020319.1259291-1-zhengyejian1@huawei.com/
> > > 
> > > Cc: stable@vger.kernel.org
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Depends-on: e18eb8783ec49 ("tracing: Add tracing_reset_all_online_cpus_unlocked() function")  
> >   
> > > Depends-on: 5448d44c38557 ("tracing: Add unified dynamic event framework")  
> > 
> > ^^^  
> 
> Did you just make up a new field?  We have a documented way to show
> dependancies for stable patches, please let's not create a new one :(

Ug, I've seen this tag used before: 

 example:  e3f0c638f428fd66b5871154b62706772045f91a

And just assumed that was the method. I guess I should have looked deeper.

> 
> > > Depends-on: 6212dd29683ee ("tracing/kprobes: Use dyn_event framework for kprobe events")
> > > Depends-on: 065e63f951432 ("tracing: Only have rmmod clear buffers that its events were active in")
> > > Depends-on: 575380da8b469 ("tracing: Only clear trace buffer on module unload if event was traced")
> > > Fixes: 77b44d1b7c283 ("tracing/kprobes: Rename Kprobe-tracer to kprobe-event")  
> 
> Adding the "unified framework" seems like way too much for a stable
> patch, are you sure all of these are required and should be applied to
> 4.19.y?
> 

It's that balance between rewriting it to the bare minimum, which is not as
intrusive, but tested much less and may be even more buggy, to backporting
a larger change that has been verified by real world use cases.

Or we just do not backport it. The bug will still exist, but you really
have to work hard to hit it. And because it's only controlled by privileged
users, maybe it's OK to just ignore it. I think I've seen only one report
of this issue in the last 10 years.

Thoughts?

-- Steve
