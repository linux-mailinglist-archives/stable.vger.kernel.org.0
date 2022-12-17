Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BDF64F76D
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 04:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiLQDxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 22:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiLQDxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 22:53:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E40C6C723;
        Fri, 16 Dec 2022 19:53:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B60D56231A;
        Sat, 17 Dec 2022 03:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2F8C433EF;
        Sat, 17 Dec 2022 03:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671249190;
        bh=tvtSBxOjRjr8AD1Nit2OYvq2xfn8/939ipq48vK7DLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQ2qyig1Ro+5frbEspzt9RXufwAwYshGg5d/dnepFr7yiNB6dz+tgePcHbW3H1RT7
         8d6i52uzaJJyvYaWAVgr19fW4UdciX/9S1s+C6SNHKoGAXFV0QFHu8bwtVAcClSo8p
         kOV6h2wVMqvmCis34nqkPTeRqwqxPC+GsoBhuGquiUVVdiDW6Z/m5tDHT/+79HUzsV
         pjzmUlxnremRXcnNzaH3wrqw2Hi2D++kss1HCA8m3PNijYr8JELSHf54b1fzz00O9s
         DZ8XBgSOtMmMoBQ+jkerirWRfZ1IxljS3goEfWl9Dz2gXH15Y5aTcWjR4a40EKqkwF
         mENXqYKlr8Vag==
Date:   Fri, 16 Dec 2022 19:53:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] fsverity: don't check builtin signatures when
 require_signatures=0
Message-ID: <Y509I/WlKJWwRhM2@sol.localdomain>
References: <20221208033523.122642-1-ebiggers@kernel.org>
 <CAMw=ZnQUmeOWQkMM9Kn5iYaT4dyDQ3j1K=dUgk9jFNcHPxxHrg@mail.gmail.com>
 <Y5zd6ucBc20CV7Le@sol.localdomain>
 <CAMw=ZnS5mXpQYtGHEK7-Q-VEojhooXiQVsGPT3e8NCW8uxnWyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMw=ZnS5mXpQYtGHEK7-Q-VEojhooXiQVsGPT3e8NCW8uxnWyA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 17, 2022 at 02:06:04AM +0000, Luca Boccassi wrote:
> On Fri, 16 Dec 2022 at 21:06, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Thu, Dec 08, 2022 at 08:42:56PM +0000, Luca Boccassi wrote:
> > > On Thu, 8 Dec 2022 at 03:35, Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > From: Eric Biggers <ebiggers@google.com>
> > > >
> > > > An issue that arises when migrating from builtin signatures to userspace
> > > > signatures is that existing files that have builtin signatures cannot be
> > > > opened unless either CONFIG_FS_VERITY_BUILTIN_SIGNATURES is disabled or
> > > > the signing certificate is left in the .fs-verity keyring.
> > > >
> > > > Since builtin signatures provide no security benefit when
> > > > fs.verity.require_signatures=0 anyway, let's just skip the signature
> > > > verification in this case.
> > > >
> > > > Fixes: 432434c9f8e1 ("fs-verity: support builtin file signatures")
> > > > Cc: <stable@vger.kernel.org> # v5.4+
> > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > > ---
> > > >  fs/verity/signature.c | 18 ++++++++++++++++--
> > > >  1 file changed, 16 insertions(+), 2 deletions(-)
> > >
> > > Acked-by: Luca Boccassi <bluca@debian.org>
> >
> > So if I can't apply
> > https://lore.kernel.org/linux-fscrypt/20221208033548.122704-1-ebiggers@kernel.org
> > ("fsverity: mark builtin signatures as deprecated") due to IPE, wouldn't I not
> > be able to apply this patch either?  Surely IPE isn't depending on
> > fs.verity.require_signatures=1, given that it enforces the policy itself?
> 
> I'm not sure what you mean? Skipping verification when this syscfg is
> disabled makes sense to me, as you noted it doesn't serve any purpose
> in that case.

Currently, fsverity builtin signatures are only useful if
fs.verity.require_signatures is set to 1 *and* userspace actually checks that
files have fsverity enabled.  However, IPE would change that if it actually gets
merged upstream, at least based on the version that was most recently sent out.
It would introduce a use of fsverity builtin signatures directly in the kernel
(https://lore.kernel.org/r/1654714889-26728-14-git-send-email-deven.desai@linux.microsoft.com
and
https://lore.kernel.org/r/1654714889-26728-15-git-send-email-deven.desai@linux.microsoft.com).

IIUC, the IPE patches add code that checks whether a file has a fsverity builtin
signature, and if so it assumes that it was verified by fs/verity/ and creates a
*boolean* file property "fsverity_signature" for IPE to operate on.

Since the IPE patches check for the presence of a builtin signature directly,
instead of indirectly by checking whether the inode has fsverity enabled at all,
there would be no need for the fs.verity.require_signatures setting with IPE.

The IPE patches do assume that the signature, if present, always gets verified
by fs/verity/.  That's what this patch would break.

Of course, for upstream I shouldn't care about breaking out-of-tree code.  So I
could apply this anyway.  But I'd at least like to be consistent.  If "fsverity:
mark builtin signatures as deprecated" isn't going to be applied because of IPE,
then I'd think this patch shouldn't be applied either, for the same reason...

- Eric
