Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953EB2D024E
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 10:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgLFJp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 04:45:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgLFJp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 04:45:28 -0500
Date:   Sun, 6 Dec 2020 10:46:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607247887;
        bh=AdMCsFUCPvhREyGXJQ7Ie8nrtYsSWzDA4PhmNXIg4sI=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=u9w6crCanNLt4Fnivds3AWGLYLbRklR7BnOoSrQTTPe4Du2eJkHAZqA4xg48E8iSV
         gffPqa2BFmiXs+wyCz/H7QeivL3Bq8PyIX/pkzRmVXRiJphgx+n1BUXolRHXrCIlGk
         nU8Ildv55S5doKxhRyrgNTiLc6pTfS3OSND+wbjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH 4.4 17/70] crypto: arm64/sha - avoid non-standard inline
 asm tricks
Message-ID: <X8yoWHNzfl7vHVRA@kroah.com>
References: <20181126105046.722096341@linuxfoundation.org>
 <20181126105048.515352194@linuxfoundation.org>
 <X7wgQ0EW4wKERbkq@xps13.dannf>
 <X8vwAPhPyKwElFa5@xps13.dannf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8vwAPhPyKwElFa5@xps13.dannf>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 05, 2020 at 01:39:28PM -0700, dann frazier wrote:
> On Mon, Nov 23, 2020 at 01:49:07PM -0700, dann frazier wrote:
> > On Mon, Nov 26, 2018 at 11:50:32AM +0100, Greg Kroah-Hartman wrote:
> > > 4.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > fyi, I bisected a regression down to this commit. This apparently
> > causes an ADR_PREL_PG_HI21 relocation to be added to the sha{1,2}_ce
> > modules. Back in 4.4 ADR_PREL_PG_HI21 relocations were forbidden if
> > built with CONFIG_ARM64_ERRATUM_843419=y, so now the sha{1,2}_ce modules
> > fail to load:
> > 
> > [   37.866250] module sha1_ce: unsupported RELA relocation: 275
> > 
> > Looks like it should be an issue for 4.14.y as well, but I haven't yet
> > tested it.
> 
> This regression appears to be limited to 4.4.y. I didn't find it when
> testing 4.9.y, and a 2nd bisection determined that it is because
> 4.9.y+ also contains a backport of commit 41c066f ("arm64: assembler:
> make adr_l work in modules under KASLR"). That was pulled from 4.4.y
> because it caused a build failure:
> 
>   https://www.spinics.net/lists/stable/msg179709.html
> 
> Shall I submit a revert of this patch for 4.4.y, or is it worth trying
> to get a backport of 41c066f to work?

Which ever you think would be best is fine.

thanks,

greg k-h
