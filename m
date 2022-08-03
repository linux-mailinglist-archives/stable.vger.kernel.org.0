Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0E5588B7F
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 13:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbiHCLqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 07:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiHCLq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 07:46:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7F76350;
        Wed,  3 Aug 2022 04:46:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0364611ED;
        Wed,  3 Aug 2022 11:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985DBC433C1;
        Wed,  3 Aug 2022 11:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659527188;
        bh=nZKYmWlSa9XmyEdXHQ+cFtuL6uqFDd9bmmvA2/joacM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lKkKLODzWGt19SS6paH+uYnJ5WxQXsAszaZ7AR1vzbKUKoSB/WM4jsgXsFP2VXGW6
         dMVEVVscVmkm3p1CJ+hugPdfDmRK99vq/r1MhATi+uhk5NZr1tS4jMKtaZoWLrMaJT
         gjCkX0NNSbX/3uxpqPgxe2Kj6/Jg3lpcnGFEl5uE=
Date:   Wed, 3 Aug 2022 13:46:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, yj.chiang@mediatek.com,
        Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, llvm@lists.linux.dev
Subject: Re: [PATCH 5.4] thermal: Fix NULL pointer dereferences in
 of_thermal_ functions
Message-ID: <YupgEZ7jrxfpnE9s@kroah.com>
References: <20220802034238.27127-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802034238.27127-1-mark-pk.tsai@mediatek.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 02, 2022 at 11:42:16AM +0800, Mark-PK Tsai wrote:
> From: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
> 
> commit 96cfe05051fd8543cdedd6807ec59a0e6c409195 upstream.
> 
> of_parse_thermal_zones() parses the thermal-zones node and registers a
> thermal_zone device for each subnode. However, if a thermal zone is
> consuming a thermal sensor and that thermal sensor device hasn't probed
> yet, an attempt to set trip_point_*_temp for that thermal zone device
> can cause a NULL pointer dereference. Fix it.
> 
>  console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
>  ...
>  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
>  ...
>  Call trace:
>   of_thermal_set_trip_temp+0x40/0xc4
>   trip_point_temp_store+0xc0/0x1dc
>   dev_attr_store+0x38/0x88
>   sysfs_kf_write+0x64/0xc0
>   kernfs_fop_write_iter+0x108/0x1d0
>   vfs_write+0x2f4/0x368
>   ksys_write+0x7c/0xec
>   __arm64_sys_write+0x20/0x30
>   el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
>   do_el0_svc+0x28/0xa0
>   el0_svc+0x14/0x24
>   el0_sync_handler+0x88/0xec
>   el0_sync+0x1c0/0x200
> 
> While at it, fix the possible NULL pointer dereference in other
> functions as well: of_thermal_get_temp(), of_thermal_set_emul_temp(),
> of_thermal_get_trend().
> 
> Suggested-by: David Collins <quic_collinsd@quicinc.com>
> Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> ---
>  drivers/thermal/of-thermal.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 

Now queued up, thanks.

greg k-h
