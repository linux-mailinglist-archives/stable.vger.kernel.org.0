Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7351F65FC62
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 09:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjAFIBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 03:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjAFIBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 03:01:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F3278172;
        Fri,  6 Jan 2023 00:01:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B9D22CE1C69;
        Fri,  6 Jan 2023 08:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609F8C433EF;
        Fri,  6 Jan 2023 08:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672992092;
        bh=H1MNmUv9zi49BtgN8dDqufBCCL3CbJ/8Jtkvf9ANGP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=slxW8ef7lFjKWgTR8kDTCueRhrGR68WKZzLuW6eBtl3HEUDslbRzXGilR8Jy38uMI
         EbmywjeC13A6cMdB8SHG7/KSyoan0+nVcq/igJD2uR9QT69gFZkQ4E7iomVoHbxoRb
         NaWp/EJokvn1HgK1VTcxF8Xmy6P8G59WpLOgrjfZ+SHIN3m38csTGg4EcFcoH3s+X8
         OGi7mupqVtCeZNCP+h66/ZMaHhZA4aBPZF9p5TZEBgk3J2faOWEfql98IA9R665GHr
         QX8SiTI8UjqDNYvuyzAwP6hziHz51CaXex/Bv6fv8AghxPwRADnOiGHBRb3G1YPcFN
         aEllcslQs8Crg==
Date:   Fri, 6 Jan 2023 00:01:30 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Riccardo Schirone <sirmy15@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] ext4: Fix function prototype mismatch for
 ext4_feat_ktype
Message-ID: <Y7fVWulL0/yq7KaO@sol.localdomain>
References: <20230104210908.gonna.388-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104210908.gonna.388-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 01:09:12PM -0800, Kees Cook wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed.
> 
> ext4_feat_ktype was setting the "release" handler to "kfree", which
> doesn't have a matching function prototype. Add a simple wrapper
> with the correct prototype.
> 
> This was found as a result of Clang's new -Wcast-function-type-strict
> flag, which is more sensitive than the simpler -Wcast-function-type,
> which only checks for type width mismatches.
> 
> Note that this code is only reached when ext4 is a loadable module and
> it is being unloaded:
> 
>  CFI failure at kobject_put+0xbb/0x1b0 (target: kfree+0x0/0x180; expected type: 0x7c4aa698)
>  ...
>  RIP: 0010:kobject_put+0xbb/0x1b0
>  ...
>  Call Trace:
>   <TASK>
>   ext4_exit_sysfs+0x14/0x60 [ext4]
>   cleanup_module+0x67/0xedb [ext4]
> 
> Fixes: b99fee58a20a ("ext4: create ext4_feat kobject dynamically")
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: stable@vger.kernel.org
> Build-tested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Link: https://lore.kernel.org/r/20230103234616.never.915-kees@kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2: rename callback, improve commit log (ebiggers)
> v1: https://lore.kernel.org/lkml/20230103234616.never.915-kees@kernel.org
> ---
>  fs/ext4/sysfs.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
