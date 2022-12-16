Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CE564F2ED
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 22:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiLPVGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 16:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiLPVGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 16:06:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5143DEFE;
        Fri, 16 Dec 2022 13:06:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 442316221A;
        Fri, 16 Dec 2022 21:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7663AC433EF;
        Fri, 16 Dec 2022 21:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671224812;
        bh=vQnEle8DIQDINZxnB4NynE9ZPfDylYmC1JKlkPCWync=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lw67mAqbYQewRYaBRK79ZyXVfd7uicKtXjRTP7rWqlPFcx4p8r4qJm9WleLTc/9m8
         Afj57BHi1WUzfLH1Lxo5o91LOvRYNBobnEZZHw7J/c+GvYDJnjRDjMo7mUYDk7HnXS
         tPkiXE1SPXm7AgxVv+GWXCBAG7Zv6vbDwyoxDVymffwBbRQ/rsolhHDCiduVlPkofI
         a3sYKxMNkEgQKmD2ZYkz8a4CCAZPS1R2r7S87MvDJPi1tQjgQXU84dDlFFcrtqbn7h
         /+JMg29kiV0wbYgBTSmTnFbvcrbK/radR1MK9d8dLg0WF8h1Y9DKtrmx7etugfndQ7
         gGg/dbKobgxKQ==
Date:   Fri, 16 Dec 2022 13:06:50 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] fsverity: don't check builtin signatures when
 require_signatures=0
Message-ID: <Y5zd6ucBc20CV7Le@sol.localdomain>
References: <20221208033523.122642-1-ebiggers@kernel.org>
 <CAMw=ZnQUmeOWQkMM9Kn5iYaT4dyDQ3j1K=dUgk9jFNcHPxxHrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMw=ZnQUmeOWQkMM9Kn5iYaT4dyDQ3j1K=dUgk9jFNcHPxxHrg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 08:42:56PM +0000, Luca Boccassi wrote:
> On Thu, 8 Dec 2022 at 03:35, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > An issue that arises when migrating from builtin signatures to userspace
> > signatures is that existing files that have builtin signatures cannot be
> > opened unless either CONFIG_FS_VERITY_BUILTIN_SIGNATURES is disabled or
> > the signing certificate is left in the .fs-verity keyring.
> >
> > Since builtin signatures provide no security benefit when
> > fs.verity.require_signatures=0 anyway, let's just skip the signature
> > verification in this case.
> >
> > Fixes: 432434c9f8e1 ("fs-verity: support builtin file signatures")
> > Cc: <stable@vger.kernel.org> # v5.4+
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  fs/verity/signature.c | 18 ++++++++++++++++--
> >  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> Acked-by: Luca Boccassi <bluca@debian.org>

So if I can't apply
https://lore.kernel.org/linux-fscrypt/20221208033548.122704-1-ebiggers@kernel.org
("fsverity: mark builtin signatures as deprecated") due to IPE, wouldn't I not
be able to apply this patch either?  Surely IPE isn't depending on
fs.verity.require_signatures=1, given that it enforces the policy itself?

- Eric
