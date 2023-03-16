Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1695F6BC8FD
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 09:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjCPIZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 04:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjCPIYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 04:24:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0FE13D6B;
        Thu, 16 Mar 2023 01:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09B4861F7F;
        Thu, 16 Mar 2023 08:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BBBC4339C;
        Thu, 16 Mar 2023 08:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678955084;
        bh=5Q/QIbLOXO7DCEdS2CkGNvVExG82N1FQBQzurDfaNbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BBVXTD+d2H/giNE16Fnu4bqvkkJk2n9kNNBGGlNWW09d32wNq/dLGloKfi5b2Zmu1
         mDKktg73vNd5UsftKZwdSyLOELquugliYYxVZtH/DjSDDwpH2jZsoMXO2277liLMkt
         g62aK8v7zkx+FpMX72mOVEfb/scQaW6H26vrVG40=
Date:   Thu, 16 Mar 2023 09:24:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Lecopzer Chen <lecopzer.chen@mediatek.com>
Subject: Re: [PATCH] Makefile: use -gdwarf-{4|5} for assembler for
 DEBUG_INFO_DWARF{4|5}
Message-ID: <ZBLSSWw4G86Ka6BZ@kroah.com>
References: <20230315214059.395939-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315214059.395939-1-ndesaulniers@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 02:40:59PM -0700, Nick Desaulniers wrote:
> This is _not_ an upstream commit and just for 5.15.y only. It is based
> on upstream
> commit 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files").
> 
> When the user has chosen not to use their compiler's implicit default
> DWARF version (which changes over time) via selecting
> - CONFIG_DEBUG_INFO_DWARF4 or
> - CONFIG_DEBUG_INFO_DWARF5
> we need to tell the compiler this for Asm sources as well as C sources.
> (We use the compiler to drive assembler jobs in kbuild, since most asm
> needs to be preprocessed first).  Otherwise, we will get object files
> built from Asm sources with the compiler's implicit default DWARF
> version.
> 
> For example, selecting CONFIG_DEBUG_INFO_DWARF4 would produce a DWARFv5
> vmlinux, since it was a mix of DWARFv4 object files from C sources and
> DWARFv5 object files from Asm sources when using Clang as the assembler
> (ex. `make LLVM=1`).
> 
> Fixes: 0ee2f0567a56 ("Makefile.debug: re-enable debug info for .S files")
> Reported-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  Makefile | 1 +
>  1 file changed, 1 insertion(+)

Now queued up, thanks,

greg k-h
