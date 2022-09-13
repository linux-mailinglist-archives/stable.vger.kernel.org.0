Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0658B5B6C69
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 13:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiIMLe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 07:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiIMLeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 07:34:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0258453D14
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:34:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91AD86140F
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 11:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D63C433C1;
        Tue, 13 Sep 2022 11:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663068863;
        bh=mn0K4P8a9XEW4ixy1V/1+lEX8Y/HzJhmcEJphmPI6zU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XbgPBtOFlt4xknbYlyrN0M4P4c8r+ApKZpLk61xyQKiciF3clL45tqcmZ0aMLODpd
         Aa9s/V6h0vCKMh/nbfFxAKPYL/g3KCbo6bZMTd2maxVWfinzu0Vk26OxmpS+71/Hxm
         LSneKvrAOMXk8fHKwg2xyB4+FE6czNnrJ+L8o+qI=
Date:   Tue, 13 Sep 2022 13:34:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracefs: Only clobber mode/uid/gid on
 remount if asked" failed to apply to 5.15-stable tree
Message-ID: <YyBq1zS13gwI7luy@kroah.com>
References: <166274826116451@kroah.com>
 <CA+ASDXNVxj-fCM94p5sbAn5-TShamWvTXN2r6KRp9+J9xJNqkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ASDXNVxj-fCM94p5sbAn5-TShamWvTXN2r6KRp9+J9xJNqkQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 12, 2022 at 03:23:42PM -0700, Brian Norris wrote:
> Hi Greg,
> 
> On Fri, Sep 9, 2022 at 11:31 AM <gregkh@linuxfoundation.org> wrote:
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Did something go wrong in your automation? The same patch applies
> cleanly to me (currently, on top of v5.15.67).
> 
> > Possible dependencies:
> >
> > 47311db8e8f3 ("tracefs: Only clobber mode/uid/gid on remount if asked")
> 
> That's $subject patch. OK, so not that one.
> 
> > 851e99ebeec3 ("tracefs: Set the group ownership in apply_options() not parse_options()")
> 
> That one *is* a dependency, but it's already backported to 5.15.y as
> of several months ago:
> 
> commit 6db927ce66ac68bf732f0b14190791458e75047a
> Author:     Steven Rostedt (Google) <rostedt@goodmis.org>
> AuthorDate: Fri Feb 25 15:34:26 2022 -0500
> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CommitDate: Wed Mar 2 11:48:05 2022 +0100
> 
>     tracefs: Set the group ownership in apply_options() not parse_options()
> 
>     commit 851e99ebeec3f4a672bb5010cf1ece095acee447 upstream.
> 
> So I'm not sure what to do to fix the backporting, other than ping back here.
> 
> I think the same applies to the 5.10.y rejection notice, and possibly
> a few others.

Here is what patch says:

Applying tracefs-only-clobber-mode-uid-gid-on-remount-if-asked.patch to linux-5.15.y
Applying patch tracefs-only-clobber-mode-uid-gid-on-remount-if-asked.patch
patching file fs/tracefs/inode.c
Hunk #3 FAILED at 278.
1 out of 5 hunks FAILED -- rejects in file fs/tracefs/inode.c
Patch tracefs-only-clobber-mode-uid-gid-on-remount-if-asked.patch does not apply (enforce with -f)
quilt returned 1, with 0 fuzz and 1 rejects

How did you apply the patch to 5.15.y that worked?

thanks,

greg k-h
