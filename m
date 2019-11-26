Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 757BB1099B7
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 08:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbfKZHxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 02:53:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfKZHxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 02:53:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0352F20722;
        Tue, 26 Nov 2019 07:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574754815;
        bh=wQdtNaWZwMn/VthN9UOum8HGrZ6SoeLpgE8ITQInHco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uh/RZq2HX9nYZVe4mG/SxhxTMAPdHlJWWaPFegqaTzNEh2+ua0rIps3b8Ql97KEDW
         J8EmxgWUBBWCCN174jr6vvpeVPaGl6NraEJlO0X8QrqNKFwhaA76grU+Vx/KxMjkyh
         9gl2GtFSGk6aNt2IkC+RQ+X0HcXe/fnQA25NjEYg=
Date:   Tue, 26 Nov 2019 08:53:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chanwoo Choi <cw00.choi@samsung.com>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, chanwoo@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] PM / devfreq: Add new name attribute for sysfs
Message-ID: <20191126075333.GA1231308@kroah.com>
References: <CGME20191125005755epcas1p2404d0f095e6ce543d36e55e2427282f8@epcas1p2.samsung.com>
 <20191125010357.27153-1-cw00.choi@samsung.com>
 <20191125085039.GA2301674@kroah.com>
 <48cadf42-4675-ffe1-a3d4-a97a37538955@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48cadf42-4675-ffe1-a3d4-a97a37538955@samsung.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 12:08:18PM +0900, Chanwoo Choi wrote:
> Hi Greg,
> 
> On 11/25/19 5:50 PM, Greg KH wrote:
> > On Mon, Nov 25, 2019 at 10:03:57AM +0900, Chanwoo Choi wrote:
> >> The commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for
> >> sysfs") changed the node name to devfreq(x). After this commit, it is not
> >> possible to get the device name through /sys/class/devfreq/devfreq(X)/*.
> >>
> >> Add new name attribute in order to get device name.
> >>
> >> Cc: stable@vger.kernel.org
> >> Fixes: 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for sysfs")
> >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> ---
> >>  Changes from v2:
> >> - Change the order of name_show() according to the sequence in devfreq_attrs[]
> >>
> >> Changes from v1:
> >> - Update sysfs-class-devfreq documentation
> >> - Show device name directly from 'devfreq->dev.parent'
> >>
> > 
> > Shouldn't you just revert the original patch here?  Why did the sysfs
> > file change?
> 
> The initial devfreq code used the parent device name for device name
> corresponding to devfreq object instead of 'devfreq%d' style.
> Before applied The commit 4585fbcb5331 ("PM / devfreq: Modify
> the device name as devfreq(X) for sysfs"), the devfreq sysfs
> showed the parent device name as following:
> 
> For example on Odroid-XU3 board before applied the commit 4585fbcb5331,
> 	/sys/class/devfreq/soc:bus_wcore
> 	/sys/class/devfreq/soc:bus_noc
> 	...(skip)
> 
> 
> But, I think that devfreq subsystem had to show the consistent
> sysfs entry name for devfreq device like input, thermal, hwmon subsystem.
> 
> For example on Odroid-XU3 board,
> - The input subsystem show the 'input%d' style for input device.
> $root@localhost:/# ls /sys/class/input/                                         
> event0  event1  input0  input1  mice  mouse0
> 
> - The thermal subsystem show the 'cooling_device%d' style for thermal cooling device.
> $ root@localhost:/# ls /sys/class/thermal/                                       
> cooling_device0  cooling_device2  thermal_zone1  thermal_zone3
> cooling_device1  thermal_zone0    thermal_zone2  thermal_zone4
> 
> - The hwmon subsystem show the 'hwmon%d' style for h/w monitor device.
> $root@localhost:/# ls /sys/class/hwmon/                                         
> hwmon0
> 
> 
> So, I tried to make the consistent sysfs entry name for devfreq device
> by contributing commit 4585fbcb5331 ("PM / devfreq: Modify the device name as
> devfreq(X) for sysfs"). But, The commit 4585fbcb5331 have missed that sysfs
> interface had to provide the real device name. Some subsystem like thermal
> and hwmon provide the device type or device name through sysfs interface.
> It is possible to make the user to find their own specific device by iteration
> on user-space.
> 
> root@localhost:/# cat /sys/class/thermal/cooling_device0/type 
> pwm-fan
> root@localhost:/# cat /sys/class/thermal/cooling_device1/type                  
> thermal-cpufreq-0
> root@localhost:/# cat /sys/class/thermal/cooling_device2/type                  
> thermal-cpufreq-1
> 
> root@localhost:/# cat /sys/class/hwmon/hwmon0/name                             
> pwmfan
> 
> 
> So, I add the new 'name' attribute of sysfs for devfreq device.
> 
> > 
> >> Documentation/ABI/testing/sysfs-class-devfreq | 7 +++++++
> >>  drivers/devfreq/devfreq.c                     | 9 +++++++++
> >>  2 files changed, 16 insertions(+)
> >>
> >> diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
> >> index 01196e19afca..75897e2fde43 100644
> >> --- a/Documentation/ABI/testing/sysfs-class-devfreq
> >> +++ b/Documentation/ABI/testing/sysfs-class-devfreq
> >> @@ -7,6 +7,13 @@ Description:
> >>  		The name of devfreq object denoted as ... is same as the
> >>  		name of device using devfreq.
> >>  
> >> +What:		/sys/class/devfreq/.../name
> >> +Date:		November 2019
> >> +Contact:	Chanwoo Choi <cw00.choi@samsung.com>
> >> +Description:
> >> +		The /sys/class/devfreq/.../name shows the name of device
> >> +		of the corresponding devfreq object.
> >> +
> >>  What:		/sys/class/devfreq/.../governor
> >>  Date:		September 2011
> >>  Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
> >> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> >> index 65a4b6cf3fa5..6f4d93d2a651 100644
> >> --- a/drivers/devfreq/devfreq.c
> >> +++ b/drivers/devfreq/devfreq.c
> >> @@ -1169,6 +1169,14 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
> >>  }
> >>  EXPORT_SYMBOL(devfreq_remove_governor);
> >>  
> >> +static ssize_t name_show(struct device *dev,
> >> +			struct device_attribute *attr, char *buf)
> >> +{
> >> +	struct devfreq *devfreq = to_devfreq(dev);
> >> +	return sprintf(buf, "%s\n", dev_name(devfreq->dev.parent));
> > 
> > Why is the parent's name being set here, and not the device name?
> 
> The device name style in struct devfreq is 'devfreq%d' instead of
> parent device name in order to keep the consistent naming style for devfreq device
> as I mentioned above. 'devfreq%d' name is consistent name style for devfreq device.
> But, it don't show the real h/w device name. So, show the parent device name
> which is specified on device-tree file.

I'm sorry, but I still do not understand.  Can you show me the directory
tree before and after here?

thanks,

greg k-h
