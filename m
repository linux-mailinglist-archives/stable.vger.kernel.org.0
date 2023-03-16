Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747536BC7E3
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 08:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjCPH4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 03:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjCPHyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 03:54:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8FBA9DE4;
        Thu, 16 Mar 2023 00:54:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AEC4B82032;
        Thu, 16 Mar 2023 07:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67697C433D2;
        Thu, 16 Mar 2023 07:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678953273;
        bh=xjSjqmrbWiXMTOAoJwX7RL6AxTGhMt5b0kzQkTF5WQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ChWHPE8s7UI9k95B9S1uAzokfkFm3YXf+eqC6juBttaHuKIV2QX/Oq0o3LcybDIBt
         Ouzz0o5PR/QzHozslqqezmcpZNjMixFhOjhy2CEFBN0RIsFraFkfWuVL91OncVScKL
         ZKxXYNKfqxaq2sNt0xHZbzGI49QbRfGH9n6BOcD8=
Date:   Thu, 16 Mar 2023 08:54:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/68] 5.4.237-rc1 review
Message-ID: <ZBLLN5G0XosxLD9A@kroah.com>
References: <20230315115726.103942885@linuxfoundation.org>
 <dce37bda-d5d9-72d8-2b22-2c69b6498870@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dce37bda-d5d9-72d8-2b22-2c69b6498870@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 08:59:42AM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 15/03/23 06:11, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.237 release.
> > There are 68 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.237-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Lots of build failures: arm, arm64 (Clang-16, Clang-nightly):
> 
> -----8<-----
> /builds/linux/drivers/gpu/drm/drm_edid.c:5119:21: error: passing 'const struct drm_connector *' to parameter of type 'struct drm_connector *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
>         if (!is_hdmi2_sink(connector) && vic > 64)
>                            ^~~~~~~~~
> /builds/linux/drivers/gpu/drm/drm_edid.c:4994:49: note: passing argument to parameter 'connector' here
> static bool is_hdmi2_sink(struct drm_connector *connector)
>                                                 ^
> 1 error generated.
> make[4]: *** [/builds/linux/scripts/Makefile.build:262: drivers/gpu/drm/drm_edid.o] Error 1
> ----->8-----

Odd this didn't show up on my builds.  Anyway, now dropped, thanks!

greg k-h
