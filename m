Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD5E6B0B40
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 15:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjCHOby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 09:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbjCHObi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 09:31:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C653C85B4
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 06:31:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD39BB81CC0
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 14:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27197C433EF;
        Wed,  8 Mar 2023 14:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678285880;
        bh=COn9POqoWzmPVv9UtHyaBBnKmHQe0Q6765Ud7G5URXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uD1hrQ6nr3Ne58HJtcwNQyu6DRsy7EVDumprW5T6UHjGZ8NpqGBknRqNWGq/hkbeI
         UBEHpLqv0bV6mQtsYgeAVUoZkEHwIAebSWhUIXT8u9FjxHKqCZxm8ykRg/Hka2IyYn
         mmUsylYULYaUhQZ3m8wozKxEfrt/+IH8p34ftKFE=
Date:   Wed, 8 Mar 2023 15:31:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Smith <psmith@gnu.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, bug-make@gnu.org,
        stable@vger.kernel.org
Subject: Re: No progress output when make 4.4.1 builds Linux 4.19 and earlier
Message-ID: <ZAicNUe2XfdQudex@kroah.com>
References: <ZAgnmbYtGa80L731@sol.localdomain>
 <ZAgogdFlu69QlYwu@kroah.com>
 <CAG+Z0CuAQsq-1DNaX0_qHnqSBt1YrUBbBaypxgwT0USFyOkk4g@mail.gmail.com>
 <4e731dfbe197f5c0a6c1093aee503b7f4d76cc1a.camel@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e731dfbe197f5c0a6c1093aee503b7f4d76cc1a.camel@gnu.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 08:57:34AM -0500, Paul Smith wrote:
> On Wed, 2023-03-08 at 08:12 -0500, Dmitry Goncharov wrote:
> > > > Is this an intentional breakage from the 'make' side?
> > No it is not an intentional breakage.
> > This is a fix for https://savannah.gnu.org/bugs/?63347.
> 
> Just to note, it was possible to run into this problem with earlier
> versions of GNU Make as well, it just became much simpler once the
> variables were available since it's easier to have an "s" in some
> variable.  But it is possible to have an "s" in a MAKEFLAGS flag which
> is not introduced with a "--", and doesn't represent the short option.
> 
> I give some examples in that Savannah bug.
> 
> > > The fact that kernels 5.4 and newer imply to me that there is
> > > a kernel build fix that should resolve this if someone can take the
> > > time to bisect it...
> > 
> > Kernel makefile was updated to work with old and new make in
> > 4bf73588165ba7d32131a043775557a54b6e1db5.
> > If you wanted to backport, try this commit.
> 
> Does anyone know why this commit is using a make version comparison? 
> That seems totally unnecessary to me; am I forgetting something?  As
> far as I remember,
> 
>     silence := $(findstring s,$(firstword -$(MAKEFLAGS)))
> 
> has always been the proper way to check for the short option "s", and
> has always worked in every version of GNU Make.
> 
> https://github.com/torvalds/linux/commit/4bf73588165ba7d32131a043775557a54b6e1db5

No idea, sorry, submit a patch to the kbuild maintainer and they will
probably accept it.

thanks,

greg k-h
