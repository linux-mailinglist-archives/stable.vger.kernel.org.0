Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5AE445FDD
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 07:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhKEGxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 02:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhKEGxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 02:53:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E63761279;
        Fri,  5 Nov 2021 06:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636095026;
        bh=iOlcR/PXYd3wFZqZIEBNWke5n/MV5QKcCVMgd18wod4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WuQASi6VfeMaAwTYNjLG5LSskN2Jy5N4/FvnN8UmftyNYdVq/0FeAtYb54O9Z/Kiz
         rO6YmW+H2IvIX+A9S3doOqtVURF4qgIOXAZNw9vdOnoPJdeqo3qEIaNLlzUpiaxYd8
         v+tW7g6idX9d2Ce2wnR789uRWYZy0xN/W7/N3OKg=
Date:   Fri, 5 Nov 2021 07:50:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Collins <quic_collinsd@quicinc.com>,
        Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>,
        stable@vger.kernel.org
Subject: Re: [RESEND PATCH v2] thermal: Fix a NULL pointer dereference
Message-ID: <YYTUMBWsqfiAYnCy@kroah.com>
References: <1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 04:57:07PM -0700, Subbaraman Narayanamurthy wrote:
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
> ---
>  drivers/thermal/thermal_of.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
