Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3C74F5C5D
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 13:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbiDFLiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 07:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiDFLge (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 07:36:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1315B30F9EC;
        Wed,  6 Apr 2022 01:26:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9539FB82176;
        Wed,  6 Apr 2022 08:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD351C385A5;
        Wed,  6 Apr 2022 08:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649233581;
        bh=679M1iA6yBnnGFHzU0BmZQpya0Qyjygd487CEYEKU9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yrLmGclX0eYKfbKaWuzkapCM16dPekIxEJ8ahchLPscDUoo+v79PjM0d3ySz/HtV/
         JmltR01BsbGvzYKVFvv+N7778qv4xZa5V9raz49Of4pBr7oA7YpxlFvDmsQ/+NXp/N
         Pk0Tfdb66yVFzIT+F14bD8IjyzrH2Az78qV2oQsc=
Date:   Wed, 6 Apr 2022 10:26:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Message-ID: <Yk1Op5c0mbtR0VLw@kroah.com>
References: <20220405070258.802373272@linuxfoundation.org>
 <20220406010749.GA1133386@roeck-us.net>
 <20220406023025.GA1926389@roeck-us.net>
 <20220405225212.061852f9@gandalf.local.home>
 <20220405230812.2feca4ed@gandalf.local.home>
 <20220405232413.6b38e966@gandalf.local.home>
 <Yk1LMYzEOv7vmEHR@kroah.com>
 <Yk1N5Vg+YrGxrfVo@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yk1N5Vg+YrGxrfVo@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 10:23:01AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 06, 2022 at 10:11:29AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Apr 05, 2022 at 11:24:13PM -0400, Steven Rostedt wrote:
> > > On Tue, 5 Apr 2022 23:08:12 -0400
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > Here's a thought, if you decide to backport a patch to stable, and you see
> > > > that there's another commit with a "Fixes" tag to the automatically
> > > > selected commit. DO NOT BACKPORT IF THE FIXES PATCH FAILS TO GO BACK TOO!
> > > 
> > > Seriously. This should be the case for *all* backported patches, not just
> > > the AUTOSEL ones.
> > > 
> > > Otherwise you are backporting a commit to "stable" that is KNOWN TO BE
> > > BROKEN!
> > 
> > My scripts usually do catch this, let me go see what went wrong...
> 
> Ok, my fault, my scripts _did_ catch this, but I ignored it as it was
> filled with other noise.  I've now queued this commit up.
> 
> thanks for catching this and sorry for missing it the first time around.

Wait, no, I did catch this!  And I sent you a "FAILED" email about it, 4
of them:
	https://lore.kernel.org/r/164905985821176@kroah.com
	https://lore.kernel.org/r/16490598521299@kroah.com
	https://lore.kernel.org/r/1649059845215213@kroah.com
	https://lore.kernel.org/r/16490598398133@kroah.com
as the commit applied, but broke the build:

kernel/trace/trace_events.c: In function ‘update_event_fields’:
kernel/trace/trace_events.c:2459:40: error: ‘TRACE_EVENT_FL_DYNAMIC’ undeclared (first use in this function); did you mean ‘FTRACE_OPS_FL_DYNAMIC’?
 2459 |         if (WARN_ON_ONCE(call->flags & TRACE_EVENT_FL_DYNAMIC))
      |                                        ^~~~~~~~~~~~~~~~~~~~~~
./include/asm-generic/bug.h:102:32: note: in definition of macro ‘WARN_ON_ONCE’
  102 |         int __ret_warn_on = !!(condition);                      \
      |                                ^~~~~~~~~
kernel/trace/trace_events.c:2459:40: note: each undeclared identifier is reported only once for each function it appears in
 2459 |         if (WARN_ON_ONCE(call->flags & TRACE_EVENT_FL_DYNAMIC))
      |                                        ^~~~~~~~~~~~~~~~~~~~~~
./include/asm-generic/bug.h:102:32: note: in definition of macro ‘WARN_ON_ONCE’
  102 |         int __ret_warn_on = !!(condition);                      \
      |                                ^~~~~~~~~
kernel/trace/trace_events.c:2491:25: error: ‘struct trace_event_call’ has no member named ‘module’
 2491 |                 if (call->module)
      |                         ^~
kernel/trace/trace_events.c:2492:47: error: ‘struct trace_event_call’ has no member named ‘module’
 2492 |                         add_str_to_module(call->module, str);
      |                                               ^~


But I didn't drop the offending commit, I should have done that.

I'll go and drop the offending commit here, if you could submit both of
them as working backports to stable@vger if/when you want them queued up
there, that would be great.

thanks,

greg k-h
