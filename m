Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C8B5525D3
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 22:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245715AbiFTUei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 16:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245505AbiFTUei (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 16:34:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509DB19288;
        Mon, 20 Jun 2022 13:34:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D67A761030;
        Mon, 20 Jun 2022 20:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76C7C341C4;
        Mon, 20 Jun 2022 20:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655757276;
        bh=AXFiRQNpSy49E3iCKEeM6ZOAc94p/GsSzEDPQKkOYuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D93r15oTo7FEKYtvjHMVNpqI/v+7Bicd/IhSl1bvtieqrAH2vn5lcEpqNbzG+C4cf
         MCNO/khU75rxIKnF1j2rYL6BCpj3izcN1YDD7tiRf7ZAnqvWRE9NKIxjcy6DC67CKg
         pyHkp/wzUGr+81BUQ2jFWeYBxsu9kzRgzcBrQ5uA=
Date:   Mon, 20 Jun 2022 22:34:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] fsnotify: consistent behavior for parent not
 watching children
Message-ID: <YrDZ2YOeHkneW8+9@kroah.com>
References: <20220511190213.831646-1-amir73il@gmail.com>
 <20220511190213.831646-3-amir73il@gmail.com>
 <CAOQ4uxj6wdsoVf7pyJWhoJ9mcNWf0eU_ARsXf6rH_nwpG1DJDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj6wdsoVf7pyJWhoJ9mcNWf0eU_ARsXf6rH_nwpG1DJDg@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 05:16:16PM +0300, Amir Goldstein wrote:
> On Wed, May 11, 2022 at 10:02 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > The logic for handling events on child in groups that have a mark on
> > the parent inode, but without FS_EVENT_ON_CHILD flag in the mask is
> > duplicated in several places and inconsistent.
> >
> > Move the logic into the preparation of mark type iterator, so that the
> > parent mark type will be excluded from all mark type iterations in that
> > case.
> >
> > This results in several subtle changes of behavior, hopefully all
> > desired changes of behavior, for example:
> >
> > - Group A has a mount mark with FS_MODIFY in mask
> > - Group A has a mark with ignore mask that does not survive FS_MODIFY
> >   and does not watch children on directory D.
> > - Group B has a mark with FS_MODIFY in mask that does watch children
> >   on directory D.
> > - FS_MODIFY event on file D/foo should not clear the ignore mask of
> >   group A, but before this change it does
> >
> > And if group A ignore mask was set to survive FS_MODIFY:
> > - FS_MODIFY event on file D/foo should be reported to group A on account
> >   of the mount mark, but before this change it is wrongly ignored
> >
> > Fixes: 2f02fd3fa13e ("fanotify: fix ignore mask logic for events on child and on dir")
> > Reported-by: Jan Kara <jack@suse.com>
> > Link: https://lore.kernel.org/linux-fsdevel/20220314113337.j7slrb5srxukztje@quack3.lan/
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> 
> Greg,
> 
> FYI, this needs the previous commit to apply to 5.18.y:

What is "this" here?  What git id?

> e730558adffb fsnotify: consistent behavior for parent not watching children
> 14362a254179 fsnotify: introduce mark type iterator
> 
> They won't apply to earlier versions and this is a fix for a very minor bug
> that existed forever, so no need to bother.

So what exactly needs to be applied in what order and to what trees?

confused,

greg k-h
