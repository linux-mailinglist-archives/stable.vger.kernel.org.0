Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BEA549DE7
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344104AbiFMTm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344627AbiFMTmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:42:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB406129A;
        Mon, 13 Jun 2022 11:11:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DB1461224;
        Mon, 13 Jun 2022 18:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F9EC34114;
        Mon, 13 Jun 2022 18:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655143881;
        bh=r/uQoIAptd2kdH1sDPm8Dl5Ok9Z2t+kx5mOqVHxzwHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oRlwMuHdrdha/YRPgL48dWRuDAB2I+9v1s68B6cwvOAFMGYE45MgdO9fFWO9Yddvt
         7DM6HxgbVaNSjdfQ+MwWTP1sy7QY3kmC09577rVITa+zQBgEJIaecUzizPBRbfIV1d
         eRHxJRS18mV2I8+Epp866LNxbCPbzPhozn+8iwJE=
Date:   Mon, 13 Jun 2022 20:11:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yongqin Liu <yongqin.liu@linaro.org>
Cc:     stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Benjamin Copeland <benjamin.copeland@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        Alistair Delva <adelva@google.com>,
        Steve Muckle <smuckle@google.com>,
        Todd Kjos <tkjos@google.com>,
        "Bajjuri, Praneeth" <praneeth@ti.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: Please help cherry pick four mmc related changes into the 4.14
 stable kernel
Message-ID: <Yqd9xjOiOapfBt/A@kroah.com>
References: <CAMSo37WW9veYH6=tHqUR2pa_7YX1UuzHqLBHit60P2QyzQmCEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMSo37WW9veYH6=tHqUR2pa_7YX1UuzHqLBHit60P2QyzQmCEw@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 01:09:54AM +0800, Yongqin Liu wrote:
> Hi, All
> 
> With the 4.14.281 version[1], there were three mmc related changes merged,
> but that causes one boot failure with the X15 Android builds, a problem
> similar to one reported before here[2].
> After being confirmed with Ulf Hansson, and verified with the X15 Android build,
> it needs to have the following four commits cherry-picked to the 4.14
> branch as well.
> 
>     4f32b45c9a2c mmc: core: Allow host controllers to require R1B for CMD6
>     5fc615c1e3eb mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
>     d091259b8d7a mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command
>     23161bed631a mmc: sdhci-omap: Fix busy detection by enabling
> MMC_CAP_NEED_RSP_BUSY
> 
> The above four commits are from the 4.19 branch, as they are a little
> easier to be cherry-picked
> into the 4.14 branch, compared to the commits from the mainline branch.
> (I have confirmed that the four commits are all in 4.19, 5.4, 5.10 and
> mainline branches already).
> 
> Saying that, there will be still one merge conflict reported when
> cherry picking the commit of
> 4f32b45c9a2c, it's easy to resolve though.
> To avoid the merge conflict, it could be done like this as well:
> 1. revert the 327b6689898b commit from 4.14 first, so that the commits in step#2
>     could be cherry-picked without any problem
>         327b6689898b mmc: core: Default to generic_cmd6_time as
> timeout in __mmc_switch()
> 2. git cherry-pick the following commits from 4.19 into the 4.14 branch
>         4f32b45c9a2c mmc: core: Allow host controllers to require R1B for CMD6
>         5fc615c1e3eb mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for
> erase/trim/discard
>         d091259b8d7a mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC
> sleep command
>         23161bed631a mmc: sdhci-omap: Fix busy detection by enabling
> MMC_CAP_NEED_RSP_BUSY
>         26c6f614cf02 mmc: mmc: core: Default to generic_cmd6_time as
> timeout in __mmc_switch()
>     The last commit of 26c6f614cf02 is for the revert in step#1.
> 
> I am not sure which way is more convenient for the maintenance work
> here, so just list both of them here
> for your information.
> And please let me know if there is anything else I could help on this
> cherry pick work here.

Please send properly backported patches to us, trying to do the revert
and fixup like you describe above is going to be hard to verify I got it
right.  A series of patches is best as that way we know you tested it
properly and sent us the correct patches.

thanks,

greg k-h
