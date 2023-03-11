Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5182D6B598A
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 09:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCKIsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 03:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCKIsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 03:48:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E76F4ED0
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 00:48:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B758A60A3B
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 08:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16FFC433EF;
        Sat, 11 Mar 2023 08:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678524479;
        bh=BZxsxAAKadbRC1cabraZr8KXG2MmL+vb7Oz/fgv57q0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ww6cPJCSSxpCFj44L4bJVYaLbaPEMrqJbaITnrrt2ddWkkjp5pvNEBqgNaRPwd3u6
         +FFNrFhG7XfXikoWfVQQsBN6tTczunVnmGkUkgTydTK0jAwEgkiYq6Vq1CuRp8jWo4
         8869Jv5Q3AgQSnFKc7IlLYsbn+gZctWYBvi8TnEY=
Date:   Sat, 11 Mar 2023 09:47:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org,
        yujie.liu@intel.com, zhengyejian1@huawei.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Free buffers when a used dynamic
 event is removed" failed to apply to 4.19-stable tree
Message-ID: <ZAxAPNF7gGOM7Xh9@kroah.com>
References: <167006641591124@kroah.com>
 <20221203173655.1b1b2fac@gandalf.local.home>
 <Y4xYg2i7lS6z3eIe@kroah.com>
 <20221204111451.2741a499@gandalf.local.home>
 <Y4zMB/CCg63nyugh@kroah.com>
 <20230310145237.154f4c3f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310145237.154f4c3f@gandalf.local.home>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 02:52:37PM -0500, Steven Rostedt wrote:
> On Sun, 4 Dec 2022 17:34:15 +0100
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > > > > > Depends-on: 5448d44c38557 ("tracing: Add unified dynamic event framework")    
> > > > > 
> > > > > ^^^    
> > > > 
> > > > Did you just make up a new field?  We have a documented way to show
> > > > dependancies for stable patches, please let's not create a new one :(  
> > > 
> > > Ug, I've seen this tag used before: 
> > > 
> > >  example:  e3f0c638f428fd66b5871154b62706772045f91a
> > > 
> > > And just assumed that was the method. I guess I should have looked deeper.
> > >   
> 
> I may need to denote patches again that are to be marked for stable but
> depend on other commits. I'm looking for the "proper" way to do this so
> that your scripts pick this up.
> 
> I searched Documentation for "depends" and the only thing I see in there is
> in Documentation/process/submitting-patches.rst:
> 
>    If one patch depends on another patch in order for a change to be
>    complete, that is OK.  Simply note **"this patch depends on patch X"**
>    in your patch description.
> 
> But that looks to be used for a patch that depends on some other patch in
> the series. I'm doing something that will depend on an existing commit. And
> do your scripts pick up on that line anyway?
> 
> Where's this documented way to show dependencies for stable patches?

Please see:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly, specifically the section below "Option 3"
that starts with, "Additionally, some patches submitted..."

does that help?

thanks,

greg k-h
