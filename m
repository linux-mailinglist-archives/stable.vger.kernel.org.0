Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCDD567409
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 18:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiGEQSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 12:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiGEQSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 12:18:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905771A831;
        Tue,  5 Jul 2022 09:18:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3092861BCE;
        Tue,  5 Jul 2022 16:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0555BC341C7;
        Tue,  5 Jul 2022 16:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657037888;
        bh=U9SEXIphH47fozamRVtALjBYNhqVcBWpGsnbl/LNUVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pPQ2gKq+048j/SAlVdyScVmMS2Euc3aXkaI6fuc/QhmoyO+qJHwdRFchnbhPnLAJ6
         VAqAXU9AUXTYqTwyCsWpO4MUO1/l/FD7Oi1gJ3AvOU4x7nXc+Z9580FjFZKEiLBRUo
         omYkzBZTDXCK6u7TTB4cOfhBOeEXz95stx4+TTig=
Date:   Tue, 5 Jul 2022 18:18:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Varad Gautam <varadgautam@google.com>
Cc:     linux-kernel@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] thermal: sysfs: Perform bounds check when storing
 thermal states
Message-ID: <YsRkPUcrMj+JU0Om@kroah.com>
References: <20220705150002.2016207-1-varadgautam@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705150002.2016207-1-varadgautam@google.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 03:00:02PM +0000, Varad Gautam wrote:
> Check that a user-provided thermal state is within the maximum
> thermal states supported by a given driver before attempting to
> apply it. This prevents a subsequent OOB access in
> thermal_cooling_device_stats_update() while performing
> state-transition accounting on drivers that do not have this check
> in their set_cur_state() handle.
> 
> Signed-off-by: Varad Gautam <varadgautam@google.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/thermal/thermal_sysfs.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
> index 1c4aac8464a7..0c6b0223b133 100644
> --- a/drivers/thermal/thermal_sysfs.c
> +++ b/drivers/thermal/thermal_sysfs.c
> @@ -607,7 +607,7 @@ cur_state_store(struct device *dev, struct device_attribute *attr,
>  		const char *buf, size_t count)
>  {
>  	struct thermal_cooling_device *cdev = to_cooling_device(dev);
> -	unsigned long state;
> +	unsigned long state, max_state;
>  	int result;
>  
>  	if (sscanf(buf, "%ld\n", &state) != 1)
> @@ -618,10 +618,20 @@ cur_state_store(struct device *dev, struct device_attribute *attr,
>  
>  	mutex_lock(&cdev->lock);
>  
> +	result = cdev->ops->get_max_state(cdev, &max_state);
> +	if (result)
> +		goto unlock;
> +
> +	if (state > max_state) {
> +		result = -EINVAL;
> +		goto unlock;
> +	}
> +
>  	result = cdev->ops->set_cur_state(cdev, state);

Why doesn't set_cur_state() check the max state before setting it?  Why
are the callers forced to always check it before?  That feels wrong...

thanks,

greg k-h
