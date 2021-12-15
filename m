Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C275B4760E4
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 19:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343874AbhLOSk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 13:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbhLOSk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 13:40:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1477C061574;
        Wed, 15 Dec 2021 10:40:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21B5DB8207B;
        Wed, 15 Dec 2021 18:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC84C36AE3;
        Wed, 15 Dec 2021 18:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639593624;
        bh=VgZti/Y1MwzTJlMCoNXKf6jL3JZ03GEy/PdqNgRSkmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mjOYArg39ZiVAkwpRDtBKDUA2VIZimzD5YSsDHeY4rI+CJH8OO8zIVgEjtiSvnXuC
         mCC8ZbKhFjhnhBo970fi60rFsb8+f+myJtdGcIpPMiDZ2lREJ0jO1hvnyp6xkk4u/Q
         6V2toStCYoRToUwxBNp/30bWYjEjrADlvYT9uLn4=
Date:   Wed, 15 Dec 2021 19:40:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     chris.paterson2@renesas.com, alice.ferrazzi@miraclelinux.com,
        nobuhiro1.iwamatsu@toshiba.co.jp, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: 5.10.85 breaks CIP testing Re: [PATCH 5.10 00/33] 5.10.86-rc1
 review
Message-ID: <Ybo2lbHVaASDyAcC@kroah.com>
References: <20211215172024.787958154@linuxfoundation.org>
 <20211215183223.GB10909@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215183223.GB10909@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 07:32:23PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.86 release.
> > There are 33 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I'm getting the gmp.h failures :-(.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/430434332
> 
> I believe we should not change build requirements in the middle of
> stable series.
> 
> To our testing team: 5.10.85 introduced new requirements for the
> build. gmp.h is now required in our configs, and maybe something else.
> 
> Easiest fix might be to add
> 
> # CONFIG_GCC_PLUGINS is not set
> 
> to our configs. Alternatively I know which patch to revert.
> 
> But I believe -stable should be the one doing the revert, as the patch
> does not fix serious bug and introduces problem. Faster compile is
> nice but let mainline have those kind of changes.

But that commit is needed to get gcc11 plugins to work with the 5.10.y
kernel tree.  So either we "break" it for old and obsolete gcc versions
(i.e. gcc7), or newer supported versions break.

We are not in the business of keeping older versions of gcc always
working, right?

thanks,

greg k-h
