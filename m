Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E7652D2AE
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 14:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiESMkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 08:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbiESMkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 08:40:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDB41705B
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2E0F3CE23D2
        for <stable@vger.kernel.org>; Thu, 19 May 2022 12:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2507C385AA;
        Thu, 19 May 2022 12:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652964046;
        bh=hMOdlctesNkJJ+kkF3QI7NKlIKtbahG4KlEpL8oSx9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UKNdW30tZ8+I3yEl8VeXH89MEEUgCC/UViTaHmPP8YaVZ9G7S9bNxTzyc+4fvaRGY
         f+LFl+gM/XFWz5MvpoavQ2MNHFJg5FvxtLL3DUocW59LX2lxNwdLRLIBWKF6/zt7NQ
         dp1uVxxPZzF+IvpRzN136gD7eBsGQeqbROO31mUQ=
Date:   Thu, 19 May 2022 14:40:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Denis Efremov <efremov@linux.com>
Cc:     stable@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 1/3] floppy: use a statically allocated error counter
Message-ID: <YoY6y+DYP4fjYh9o@kroah.com>
References: <20220508093709.24548-1-w@1wt.eu>
 <236c0048-49b5-2c37-4549-d8774f243ae3@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <236c0048-49b5-2c37-4549-d8774f243ae3@linux.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 09:47:57PM +0400, Denis Efremov wrote:
> Hi,
> 
> On 5/8/22 13:37, Willy Tarreau wrote:
> > Interrupt handler bad_flp_intr() may cause a UAF on the recently freed
> > request just to increment the error count. There's no point keeping
> > that one in the request anyway, and since the interrupt handler uses
> > a static pointer to the error which cannot be kept in sync with the
> > pending request, better make it use a static error counter that's
> > reset for each new request. This reset now happens when entering
> > redo_fd_request() for a new request via set_next_request().
> > 
> > One initial concern about a single error counter was that errors on
> > one floppy drive could be reported on another one, but this problem
> > is not real given that the driver uses a single drive at a time, as
> > that PC-compatible controllers also have this limitation by using
> > shared signals. As such the error count is always for the "current"
> > drive.
> > 
> > Reported-by: Minh Yuan <yuanmingbuaa@gmail.com>
> > Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
> > Tested-by: Denis Efremov <efremov@linux.com>
> > Signed-off-by: Willy Tarreau <w@1wt.eu>
> 
> Could you please take this patch (only this one) to the stable trees?
> 
> commit f71f01394f742fc4558b3f9f4c7ef4c4cf3b07c8 upstream.
> 
> The patch applies cleanly to 5.17, 5.15, 5.10 kernels.
> I'll send a backport for 5.4 and older kernels.

All now queued up, thanks.

greg k-h
