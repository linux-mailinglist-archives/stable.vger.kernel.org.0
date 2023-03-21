Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96FF6C2BA8
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 08:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjCUHsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 03:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbjCUHsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 03:48:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D56513D6D;
        Tue, 21 Mar 2023 00:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF778B80EC5;
        Tue, 21 Mar 2023 07:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03E2C433EF;
        Tue, 21 Mar 2023 07:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679384900;
        bh=YsRomgHu98oQV4g6Q5/iQRj/o0GYfbUtrYkz2JQb4YA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j6w5nQhXo7VqIUJMh/CF5qRzifcULCHyFl6FcfeKr1cZ3VjClvy5PE9qTKifi/PmO
         iecXm/5seIJDxO+HBaIU3vKzbebvjenUfD9Usj9Gxw2IVz7iOr5DSHPmg4YoU4kFaj
         25wJBh3ls2SCY2ZXb9Xwj63/teWrPI5FXLsXCg6s=
Date:   Tue, 21 Mar 2023 08:48:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        llvm@lists.linux.dev
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
Message-ID: <ZBlhQjcEfoISYutj@kroah.com>
References: <20230320145513.305686421@linuxfoundation.org>
 <CA+G9fYvNEThYX-c204_knup5G_1vA27j+HouS-n=HMUsdJpC_g@mail.gmail.com>
 <CAKwvOdnmwkoeToovShcmfpSAmBmKDTzZNv4R2jFA37hi=+ynaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKwvOdnmwkoeToovShcmfpSAmBmKDTzZNv4R2jFA37hi=+ynaQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 11:49:49AM -0700, Nick Desaulniers wrote:
> On Mon, Mar 20, 2023 at 11:40 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> 
> Thanks for the report!
> 
> > The bisection pointed to this commit,
> >   45f7091aac35 ("powerpc/64: Set default CPU in Kconfig")
> >
> >
> > Follow up fix patch is here as per Christophe Leroy comments,
> >  powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG
> 
> Greg, Sasha,
> Can you please also pick up
> commit 4b10306e9845 ("powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG")
> 
> 4b10306e9845 is missing a fixes tag.  I've filed
> https://github.com/ClangBuiltLinux/linux/issues/1820 to track getting
> these -mcpu= values for ppc added to clang.

Now queued up, thanks.

greg k-h
