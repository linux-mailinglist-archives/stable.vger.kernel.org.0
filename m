Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3F16A9B43
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 16:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjCCP46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 10:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCCP45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 10:56:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5C122A18
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 07:56:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84A4961830
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 15:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65529C433D2;
        Fri,  3 Mar 2023 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677859015;
        bh=vtYHv+2Qksc3UZX9ab2kKeTbzqe0+8gQSAJllUz61kc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BcTUs/orOUhbhimbb6/9fi+TNf7Ve7HmqR4YJHdhE4vnnlBxrVEkDa9d9ZK4iNCy5
         wdoSp9lzUPeQr7B2/nIPF0cOYAkzlhr7FqSU/ejGhCQEAgQimBkxfCX03OYF/nLvn9
         BOHDsVz1HUTCJQc14WzWIWtVNTVuiLztNkNNZrEU=
Date:   Fri, 3 Mar 2023 16:56:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, nathan@kernel.org,
        christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        linux- stable <stable@vger.kernel.org>
Subject: Re: Stable backport request: powerpc/mm radix_tlb warnings
Message-ID: <ZAIYxdqc+c9QSKMt@kroah.com>
References: <CAEUSe784QOG=iSoSNBRsTyp7QFqGCnzZzY2KwVaAWYJJmgQDxQ@mail.gmail.com>
 <CAEUSe78zcj5AHbubraAK-00N073Uij66hCd7Uqn6_KEXQasZgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe78zcj5AHbubraAK-00N073Uij66hCd7Uqn6_KEXQasZgQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 10:33:55PM -0600, Daniel Díaz wrote:
> On Wed, 1 Mar 2023 at 22:31, Daniel Díaz <daniel.diaz@linaro.org> wrote:
> > Hello!
> >
> > Would the stable maintainers please consider backporting the following
> > commit to the 5.15, 6.1, and 6.2 stable branches? It's been
> > build-tested and verified it fixes the problem described therein.
> >
> > commit d78c8e32890ef7eca79ffd67c96022c7f9d8cce4
> > Author: Anders Roxell <anders.roxell@linaro.org>
> > Date:   Wed Aug 10 13:43:18 2022 +0200
> >
> >     powerpc/mm: Rearrange if-else block to avoid clang warning
> >
> > Clang (13, 14, 15, 16, nightly) warns as follows:
> > -----8<----------8<----------8<-----
> > arch/powerpc/mm/book3s64/radix_tlb.c:1191:23: error: variable 'hstart'
> > is uninitialized when used here
> >   __tlbiel_va_range(hstart, hend, pid,
> >                     ^~~~~~
> > arch/powerpc/mm/book3s64/radix_tlb.c:1191:31: error: variable 'hend'
> > is uninitialized when used here
> >   __tlbiel_va_range(hstart, hend, pid,
> >                             ^~~~
> > ----->8---------->8---------->8-----
> >
> > Those warnings make the builds fail.
> >
> > The same patch applies to 5.10 with fuzz 2 (offset -243 lines).
> > Attached is that updated patch.
> >
> > The code for 5.4 (and below) is different, so this patch would not apply there.
> >
> > Thanks and greetings!
> >
> > Daniel Díaz
> > daniel.diaz@linaro.org
> 
> + stable mailing list

Now queued up, thanks.

greg k-h
