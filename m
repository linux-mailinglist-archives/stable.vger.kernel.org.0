Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BC0653BF4
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 07:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiLVGBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 01:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiLVGBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 01:01:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D2F11A1F;
        Wed, 21 Dec 2022 22:01:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30D60619C0;
        Thu, 22 Dec 2022 06:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D3BC433D2;
        Thu, 22 Dec 2022 06:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671688874;
        bh=ybjHvhL/1jq6BZd3kBdQpE/ZJ8FrY0TIzuOINUpC9qY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Px5TOGyQ4CMon3fdusADeVf25TIJzrJTaDMfgbMj7feJGc2aCGm6h8S6N+2zd95SX
         S3y+s3sqIH+Vv/Wpwfl5k7pfGHx9zBUr5aGBdcN3K7eB7t/JjF+zXj+EFedovP9xW2
         qTQ9Z3tTYOrCzc3Yqid3w4a/FvO8XOspqwRGfbeI=
Date:   Thu, 22 Dec 2022 07:01:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <Y6Pyp+7Udn6x/UVg@kroah.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <Y6M090tsVRIBNlNG@kroah.com>
 <20221221205210.6oolnwkzqo2d6q5h@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221205210.6oolnwkzqo2d6q5h@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 02:52:10PM -0600, Tom Saeger wrote:
> On Wed, Dec 21, 2022 at 05:31:51PM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Dec 15, 2022 at 04:18:18PM -0700, Tom Saeger wrote:
> > > Backport of:
> > > commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > > breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
> > > from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > 
> > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > after df202b452fe6 which included:
> > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > 
> > Why can't we add this one instead of a custom change?
> 
> I quickly abandoned that route - there are too many dependencies.

How many?  Why?  Whenever we add a "this is not upstream" patch, 90% of
the time it is incorrect and causes problems (merge issues included.)
So please please please let's try to keep in sync with what is in
Linus's tree.

thanks,

greg k-h
