Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06B84FE737
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 19:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354531AbiDLRhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 13:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358377AbiDLRhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 13:37:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DA347042;
        Tue, 12 Apr 2022 10:34:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5DB861A2F;
        Tue, 12 Apr 2022 17:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3194C385A1;
        Tue, 12 Apr 2022 17:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649784893;
        bh=O2kmzvOUPNo/Gzjs/O2fY687QJ+m+7OsUjR0dUhc5k8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fypyXBpjYwTXShiykqb0KVjdAhC/Y3ZyjnWI/NsZ19oCbZ35WU5fE+EIKl94sAmoW
         wGsUG8NkZk2Ztx16kv50pInxKRH+7EyY4r1V8EfmPgAZpikGImH3XfKflDGvXJZket
         IlugAoQv/Zc7zhyiHMzqowLENOSM+h+5Nv67oSGk=
Date:   Tue, 12 Apr 2022 19:34:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.15 000/277] 5.15.34-rc1 review
Message-ID: <YlW4Ok8uUqitUDIl@kroah.com>
References: <20220412062942.022903016@linuxfoundation.org>
 <6d0ce49e-06e8-ce9b-ee8d-8bbabbe398f5@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d0ce49e-06e8-ce9b-ee8d-8bbabbe398f5@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 08:39:59AM -0700, Guenter Roeck wrote:
> On 4/11/22 23:26, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.34 release.
> > There are 277 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> > Anything received after that time might be too late.
> > 
> 
> 
> Building powerpc:skiroot_defconfig ... failed
> --------------
> Error log:
> arch/powerpc/lib/code-patching.c:119:19: error: conflicting types for 'unmap_patch_area'; have 'int(long unsigned int)'
>   119 | static inline int unmap_patch_area(unsigned long addr)
>       |                   ^~~~~~~~~~~~~~~~
> arch/powerpc/lib/code-patching.c:51:13: note: previous declaration of 'unmap_patch_area' with type 'void(long unsigned int)'
>    51 | static void unmap_patch_area(unsigned long addr);
>       |             ^~~~~~~~~~~~~~~~
> arch/powerpc/lib/code-patching.c:51:13: error: 'unmap_patch_area' used but never defined [-Werror]
> 
> Commit 520c23a20890 ("powerpc/code-patching: Pre-map patch area")
> is the last patch in a series of patches applied to the file since v5.15.
> It is not tagged for stable, and it does not include a Fixes: tag.
> I am not sure if it makes sense to apply it on its own. Copying
> Michael.

Yeah, that's not right.  I'll drop it from 5.10 and 5.15 (and older),
for some reason Sasha skipped 5.16, probably because he saw this build
error there.

thanks for the report, I'll push out a -rc2 soon.

greg k-h
