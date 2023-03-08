Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EFD6AFEF1
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 07:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCHGe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 01:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCHGe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 01:34:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D578F50D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 22:34:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C460D61582
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 06:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05445C433EF;
        Wed,  8 Mar 2023 06:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678257265;
        bh=sSofSLgI4lmTAgIXqrN80IcPOHpOWQH4pQxZA2In1aU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=isjAtsjkXWQWGLcOgEfl6wqXuyIyJVYmtX93M7GSXP7CZlT5ccbeqaFJ3aYjtHd5T
         T5lCcRmE8+Ddp/J9R2v9mQMwzmaY91/5naGlOTzY4rYmDJMB9G6xkEEmDYMtuUvWgP
         AcqP636Vz7HDqQXJEEWpBW6Z30v5rYzbgKB4ylz0cuRwYEdH+6w1Ux4J0ViLiW/W4N
         sjCg2+0zr9sroccQ5GNN0g0/4PEtEejY3hLvRdv+3pWWzujXgPWXYMyzh+W1slSyyw
         T68in0yM9//m361YsF8KoxwOQBkOHopVRouF7ya2X0Awy11AyuQ65cF6Doyb10FLMz
         ljlO94zMISFBA==
Date:   Tue, 7 Mar 2023 22:34:23 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     bug-make@gnu.org, stable@vger.kernel.org,
        Dmitry Goncharov <dgoncharov@users.sf.net>
Subject: Re: No progress output when make 4.4.1 builds Linux 4.19 and earlier
Message-ID: <ZAgsb/P1NLugNeUl@sol.localdomain>
References: <ZAgnmbYtGa80L731@sol.localdomain>
 <ZAgogdFlu69QlYwu@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAgogdFlu69QlYwu@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 07:17:37AM +0100, Greg KH wrote:
> On Tue, Mar 07, 2023 at 10:13:45PM -0800, Eric Biggers wrote:
> > After upgrading to make v4.4.1 (released last week), there's no longer any
> > progress output from builds of the Linux kernel v4.19 and earlier.  It seems the
> > actual build still works, but it's now silent except for warnings and errors.
> > 
> > It bisects to the following 'make' commit:
> > 
> >     commit dc2d963989b96161472b2cd38cef5d1f4851ea34
> >     Author: Dmitry Goncharov <dgoncharov@users.sf.net>
> >     Date:   Sun Nov 27 14:09:17 2022 -0500
> > 
> >         [SV 63347] Always add command line variable assignments to MAKEFLAGS
> > 
> > Is this an intentional breakage from the 'make' side?
> 
> Ah, thanks for figuring this out, it's been bugging me locally for a bit
> as well!  The fact that kernels 5.4 and newer imply to me that there is
> a kernel build fix that should resolve this if someone can take the time
> to bisect it...
> 

Fix bisection comes up with the following kernel commit:

    commit 80463f1b7bf9f822fd3495139bcf3ef254fdca10
    Author: Masahiro Yamada <yamada.masahiro@socionext.com>
    Date:   Fri Sep 14 15:33:23 2018 +0900
    
        kbuild: add --include-dir flag only for out-of-tree build

But only for in-tree builds.  Out-of-tree builds need:

    commit 3812b8c5c5d527239ac015f1f2c7654da7fcfbba
    Author: Masahiro Yamada <yamada.masahiro@socionext.com>
    Date:   Fri Feb 22 16:40:07 2019 +0900

        kbuild: make -r/-R effective in top Makefile for old Make versions

Masahiro, what dependencies (if any) do the above two commits have in order to
be backported to 4.19 and 4.14?

- Eric
