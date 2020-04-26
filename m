Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEB31B91A9
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 18:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgDZQYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 12:24:17 -0400
Received: from cloudserver094114.home.pl ([79.96.170.134]:58234 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgDZQYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Apr 2020 12:24:17 -0400
Received: from 185.80.35.16 (185.80.35.16) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.415)
 id 5c6f423f88d0ad3c; Sun, 26 Apr 2020 18:24:14 +0200
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     decui@microsoft.com
Cc:     linux-pm@vger.kernel.org, len.brown@intel.com, pavel@ucw.cz,
        bvanassche@acm.org, mikelley@microsoft.com, longli@microsoft.com,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com,
        wei.liu@kernel.org, sthemmin@microsoft.com, haiyangz@microsoft.com,
        kys@microsoft.com, stable@vger.kernel.org
Subject: Re: [PATCH] PM: hibernate: Freeze kernel threads in software_resume()
Date:   Sun, 26 Apr 2020 18:24:14 +0200
Message-ID: <2420808.aENraY2TMt@kreacher>
In-Reply-To: <20200424034016.42046-1-decui@microsoft.com>
References: <20200424034016.42046-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday, April 24, 2020 5:40:16 AM CEST Dexuan Cui wrote:
> Currently the kernel threads are not frozen in software_resume(), so
> between dpm_suspend_start(PMSG_QUIESCE) and resume_target_kernel(),
> system_freezable_power_efficient_wq can still try to submit SCSI
> commands and this can cause a panic since the low level SCSI driver
> (e.g. hv_storvsc) has quiesced the SCSI adapter and can not accept
> any SCSI commands: https://lkml.org/lkml/2020/4/10/47
> 
> At first I posted a fix (https://lkml.org/lkml/2020/4/21/1318) trying
> to resolve the issue from hv_storvsc, but with the help of
> Bart Van Assche, I realized it's better to fix software_resume(),
> since this looks like a generic issue, not only pertaining to SCSI.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  kernel/power/hibernate.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index 86aba8706b16..30bd28d1d418 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -898,6 +898,13 @@ static int software_resume(void)
>  	error = freeze_processes();
>  	if (error)
>  		goto Close_Finish;
> +
> +	error = freeze_kernel_threads();
> +	if (error) {
> +		thaw_processes();
> +		goto Close_Finish;
> +	}
> +
>  	error = load_image_and_restore();
>  	thaw_processes();
>   Finish:
> 

Applied as a fix for 5.7-rc4, thanks!



