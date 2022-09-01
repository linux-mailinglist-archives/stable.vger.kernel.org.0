Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0013D5A9364
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 11:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiIAJls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 05:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbiIAJl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 05:41:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0629B133F24;
        Thu,  1 Sep 2022 02:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9756D61A28;
        Thu,  1 Sep 2022 09:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B172C433D6;
        Thu,  1 Sep 2022 09:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662025285;
        bh=hOvI5AL4tVf2yu2jeAaQEqV77KwuQl9I2U3Mr2oG9Rs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M60ziHDl26Rj2jWczFWOIB0D5nmBNPVx+sfcmK+ADzOJrasycvUQlPTKeIGPXBZZc
         KMsFck1WRlpPoRbimvKVaHPzyL6WoSeuBb3X/qQ2uuPjCu6tTejVjW+QGsMzpJU0eO
         0nZAdftu7/L4LVPArx4k2x6JHjfPDw943rPvCnyw=
Date:   Thu, 1 Sep 2022 11:41:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Frank Hofmann <fhofmann@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5.10 v2 6/7] xfs: reorder iunlink remove operation in
 xfs_ifree
Message-ID: <YxB+QmIwCgMtj1r+@kroah.com>
References: <20220901054854.2449416-1-amir73il@gmail.com>
 <20220901054854.2449416-7-amir73il@gmail.com>
 <CABEBQikqj+Uwae0XMHSbU7FVcrTR7cMb6zgbiRHC0PwFfB7+qw@mail.gmail.com>
 <CAOQ4uxhNV=-nVO_ezP=Lc42+Q+A+wxdiCBqhVQz8qVkBJba1iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhNV=-nVO_ezP=Lc42+Q+A+wxdiCBqhVQz8qVkBJba1iA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 12:30:13PM +0300, Amir Goldstein wrote:
> On Thu, Sep 1, 2022 at 12:04 PM Frank Hofmann <fhofmann@cloudflare.com> wrote:
> >
> > On Thu, Sep 1, 2022 at 6:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.
> > >
> > > [backport for 5.10.y]
> >
> > Hi Amir, hi Dave,
> >
> > I've got no objections to backporting this change at all. We've been
> > using the patch on our internal 5.15 tracker branch happily for
> > several months now.
> >
> > Would like to highlight though that it's currently not yet merged in
> > linux-stable 5.15 branch either (it's in 5.19 and mainline alright).
> > If this gets queued for 5.10 then maybe it also should be for 5.15 ?
> >
> 
> Hi Frank,
> 
> Quoting from my cover letter:
> 
> Patches 6-7 in this 5.10.y update have not been applied to 5.15.y yet.
> I pointed Leah's attention to these patches and she said she will
> include them in a following 5.15.y update.

And as you know, this means I can't take this series at all until that
series is ready, so to help us out, in the future, just don't even send
them until they are all ready together.

thanks,

greg k-h
