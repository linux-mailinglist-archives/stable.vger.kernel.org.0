Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC6B557F77
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiFWQJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbiFWQJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:09:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F1765DA;
        Thu, 23 Jun 2022 09:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FEFEB82474;
        Thu, 23 Jun 2022 16:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF4DC3411B;
        Thu, 23 Jun 2022 16:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656000588;
        bh=9cm4/Qd/GQSx3E4fM4jQHKSS5u2kjgzQztJMkWQuqlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rk6+PXnjVHLBboaArveuhNqaOGualnoOcCg7D4qSjzRGvsKP9gOmguR8M/5dZQqP1
         A9SjREyqJKqwAZ8bkE/W15LC2cv/XjFt7LuLTkBVs0yyKFjMwPZ9D8OK+ZmWDcFPgC
         lgRs+xYUwM0p3xnnLbj9JWVbMjWKXW0dgnFTNDho=
Date:   Thu, 23 Jun 2022 18:09:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] fsnotify: consistent behavior for parent not
 watching children
Message-ID: <YrSQScmJ5C28cSt2@kroah.com>
References: <20220511190213.831646-1-amir73il@gmail.com>
 <20220511190213.831646-3-amir73il@gmail.com>
 <CAOQ4uxj6wdsoVf7pyJWhoJ9mcNWf0eU_ARsXf6rH_nwpG1DJDg@mail.gmail.com>
 <YrDZ2YOeHkneW8+9@kroah.com>
 <CAOQ4uxiBHzFExCZowFNggn+woOz8vfwK=PZvAnVVBYHvjG-udQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiBHzFExCZowFNggn+woOz8vfwK=PZvAnVVBYHvjG-udQ@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 06:04:33AM +0300, Amir Goldstein wrote:
> On Mon, Jun 20, 2022 at 11:34 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jun 20, 2022 at 05:16:16PM +0300, Amir Goldstein wrote:
> > > On Wed, May 11, 2022 at 10:02 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > The logic for handling events on child in groups that have a mark on
> > > > the parent inode, but without FS_EVENT_ON_CHILD flag in the mask is
> > > > duplicated in several places and inconsistent.
> > > >
> > > > Move the logic into the preparation of mark type iterator, so that the
> > > > parent mark type will be excluded from all mark type iterations in that
> > > > case.
> > > >
> > > > This results in several subtle changes of behavior, hopefully all
> > > > desired changes of behavior, for example:
> > > >
> > > > - Group A has a mount mark with FS_MODIFY in mask
> > > > - Group A has a mark with ignore mask that does not survive FS_MODIFY
> > > >   and does not watch children on directory D.
> > > > - Group B has a mark with FS_MODIFY in mask that does watch children
> > > >   on directory D.
> > > > - FS_MODIFY event on file D/foo should not clear the ignore mask of
> > > >   group A, but before this change it does
> > > >
> > > > And if group A ignore mask was set to survive FS_MODIFY:
> > > > - FS_MODIFY event on file D/foo should be reported to group A on account
> > > >   of the mount mark, but before this change it is wrongly ignored
> > > >
> > > > Fixes: 2f02fd3fa13e ("fanotify: fix ignore mask logic for events on child and on dir")
> > > > Reported-by: Jan Kara <jack@suse.com>
> > > > Link: https://lore.kernel.org/linux-fsdevel/20220314113337.j7slrb5srxukztje@quack3.lan/
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > >
> > > Greg,
> > >
> > > FYI, this needs the previous commit to apply to 5.18.y:
> >
> > What is "this" here?  What git id?
> 
> Sorry, this commit:
> 
> > > e730558adffb fsnotify: consistent behavior for parent not watching children
> 
> Needs this previous commit:
> 
> > > 14362a254179 fsnotify: introduce mark type iterator
> 
> > > They won't apply to earlier versions and this is a fix for a very minor bug
> > > that existed forever, so no need to bother.
> >
> > So what exactly needs to be applied in what order and to what trees?
> >
> 
> To apply to 5.18.y.

Now queued up, thanks.

> Don't bother trying to apply either to earlier trees.

So the Fixes: tag lied?  No wonder I was confused :)

thanks,

greg k-h
