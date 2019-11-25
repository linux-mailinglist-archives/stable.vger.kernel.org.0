Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D625108A52
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 09:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfKYIum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 03:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfKYIum (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 03:50:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 069582071E;
        Mon, 25 Nov 2019 08:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574671841;
        bh=EYDZogHNR80OurKQa482fcMeSSGrugoBB+rl4NZ8Qpk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BJSw/xxoG6F7JI9BGq9vZNLbF9UJ9nyMPs4H6wUtqlWfWP8AdA7npwZD/A0p4pq/f
         ljZrVFKpcEaK4hxavDwxzXz70xhJ0HXpAbf2ftzey/SJCQyy5YLqJG7imSvWr93ngF
         Xu650y88z2wwy0S015Uk6Bl6DNW06wxCnzvGZpnA=
Date:   Mon, 25 Nov 2019 09:50:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chanwoo Choi <cw00.choi@samsung.com>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, chanwoo@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] PM / devfreq: Add new name attribute for sysfs
Message-ID: <20191125085039.GA2301674@kroah.com>
References: <CGME20191125005755epcas1p2404d0f095e6ce543d36e55e2427282f8@epcas1p2.samsung.com>
 <20191125010357.27153-1-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125010357.27153-1-cw00.choi@samsung.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 10:03:57AM +0900, Chanwoo Choi wrote:
> The commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for
> sysfs") changed the node name to devfreq(x). After this commit, it is not
> possible to get the device name through /sys/class/devfreq/devfreq(X)/*.
> 
> Add new name attribute in order to get device name.
> 
> Cc: stable@vger.kernel.org
> Fixes: 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for sysfs")
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  Changes from v2:
> - Change the order of name_show() according to the sequence in devfreq_attrs[]
> 
> Changes from v1:
> - Update sysfs-class-devfreq documentation
> - Show device name directly from 'devfreq->dev.parent'
> 

Shouldn't you just revert the original patch here?  Why did the sysfs
file change?

> Documentation/ABI/testing/sysfs-class-devfreq | 7 +++++++
>  drivers/devfreq/devfreq.c                     | 9 +++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
> index 01196e19afca..75897e2fde43 100644
> --- a/Documentation/ABI/testing/sysfs-class-devfreq
> +++ b/Documentation/ABI/testing/sysfs-class-devfreq
> @@ -7,6 +7,13 @@ Description:
>  		The name of devfreq object denoted as ... is same as the
>  		name of device using devfreq.
>  
> +What:		/sys/class/devfreq/.../name
> +Date:		November 2019
> +Contact:	Chanwoo Choi <cw00.choi@samsung.com>
> +Description:
> +		The /sys/class/devfreq/.../name shows the name of device
> +		of the corresponding devfreq object.
> +
>  What:		/sys/class/devfreq/.../governor
>  Date:		September 2011
>  Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 65a4b6cf3fa5..6f4d93d2a651 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -1169,6 +1169,14 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
>  }
>  EXPORT_SYMBOL(devfreq_remove_governor);
>  
> +static ssize_t name_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct devfreq *devfreq = to_devfreq(dev);
> +	return sprintf(buf, "%s\n", dev_name(devfreq->dev.parent));

Why is the parent's name being set here, and not the device name?

The device name should be the name of the directory, and the parent's
name is the name of the parent directory, why is a sysfs attribute for a
name needed at all?

confused,

greg k-h
