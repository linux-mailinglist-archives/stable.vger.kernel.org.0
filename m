Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E0B109AE9
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 10:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfKZJPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 04:15:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbfKZJPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 04:15:50 -0500
Received: from localhost (unknown [84.241.194.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C26620678;
        Tue, 26 Nov 2019 09:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574759749;
        bh=xU5slxWEQomkNhOAgoIOnTbVrLTSUpdMjGZHUb5nLxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RcNYzeVk09+Vyahnw5p2Cl5Hb1Kp4DOa5hKlvajob7ZbGvsPs+0CYQF6Scne0h5aU
         zIf5ngX7sTXuR0H26DY2udzHvDoMpGLLtqfoU5IRwgyOekatyrc1D6z11BDsgQXK9k
         XHeo+iaTZYsyZdzgex5rx3EPa4JIevVWkX38ISKE=
Date:   Tue, 26 Nov 2019 10:15:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chanwoo Choi <cw00.choi@samsung.com>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, chanwoo@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] PM / devfreq: Add new name attribute for sysfs
Message-ID: <20191126091541.GB1371943@kroah.com>
References: <CGME20191125005755epcas1p2404d0f095e6ce543d36e55e2427282f8@epcas1p2.samsung.com>
 <20191125010357.27153-1-cw00.choi@samsung.com>
 <20191125085039.GA2301674@kroah.com>
 <48cadf42-4675-ffe1-a3d4-a97a37538955@samsung.com>
 <20191126075333.GA1231308@kroah.com>
 <c5c9dc78-8209-3b42-4b16-cb40b00b8508@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5c9dc78-8209-3b42-4b16-cb40b00b8508@samsung.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 05:35:28PM +0900, Chanwoo Choi wrote:
> On 11/26/19 4:53 PM, Greg KH wrote:
> > On Tue, Nov 26, 2019 at 12:08:18PM +0900, Chanwoo Choi wrote:
> >> Hi Greg,
> >>
> >> On 11/25/19 5:50 PM, Greg KH wrote:
> >>> On Mon, Nov 25, 2019 at 10:03:57AM +0900, Chanwoo Choi wrote:
> >>>> The commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for
> >>>> sysfs") changed the node name to devfreq(x). After this commit, it is not
> >>>> possible to get the device name through /sys/class/devfreq/devfreq(X)/*.
> >>>>
> >>>> Add new name attribute in order to get device name.
> >>>>
> >>>> Cc: stable@vger.kernel.org
> >>>> Fixes: 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for sysfs")
> >>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> >>>> ---
> >>>>  Changes from v2:
> >>>> - Change the order of name_show() according to the sequence in devfreq_attrs[]
> >>>>
> >>>> Changes from v1:
> >>>> - Update sysfs-class-devfreq documentation
> >>>> - Show device name directly from 'devfreq->dev.parent'
> >>>>
> >>>
> >>> Shouldn't you just revert the original patch here?  Why did the sysfs
> >>> file change?
> >>
> >> The initial devfreq code used the parent device name for device name
> >> corresponding to devfreq object instead of 'devfreq%d' style.
> >> Before applied The commit 4585fbcb5331 ("PM / devfreq: Modify
> >> the device name as devfreq(X) for sysfs"), the devfreq sysfs
> >> showed the parent device name as following:
> >>
> >> For example on Odroid-XU3 board before applied the commit 4585fbcb5331,
> >> 	/sys/class/devfreq/soc:bus_wcore
> >> 	/sys/class/devfreq/soc:bus_noc
> >> 	...(skip)
> >>
> >>
> >> But, I think that devfreq subsystem had to show the consistent
> >> sysfs entry name for devfreq device like input, thermal, hwmon subsystem.
> >>
> >> For example on Odroid-XU3 board,
> >> - The input subsystem show the 'input%d' style for input device.
> >> $root@localhost:/# ls /sys/class/input/                                         
> >> event0  event1  input0  input1  mice  mouse0
> >>
> >> - The thermal subsystem show the 'cooling_device%d' style for thermal cooling device.
> >> $ root@localhost:/# ls /sys/class/thermal/                                       
> >> cooling_device0  cooling_device2  thermal_zone1  thermal_zone3
> >> cooling_device1  thermal_zone0    thermal_zone2  thermal_zone4
> >>
> >> - The hwmon subsystem show the 'hwmon%d' style for h/w monitor device.
> >> $root@localhost:/# ls /sys/class/hwmon/                                         
> >> hwmon0
> >>
> >>
> >> So, I tried to make the consistent sysfs entry name for devfreq device
> >> by contributing commit 4585fbcb5331 ("PM / devfreq: Modify the device name as
> >> devfreq(X) for sysfs"). But, The commit 4585fbcb5331 have missed that sysfs
> >> interface had to provide the real device name. Some subsystem like thermal
> >> and hwmon provide the device type or device name through sysfs interface.
> >> It is possible to make the user to find their own specific device by iteration
> >> on user-space.
> >>
> >> root@localhost:/# cat /sys/class/thermal/cooling_device0/type 
> >> pwm-fan
> >> root@localhost:/# cat /sys/class/thermal/cooling_device1/type                  
> >> thermal-cpufreq-0
> >> root@localhost:/# cat /sys/class/thermal/cooling_device2/type                  
> >> thermal-cpufreq-1
> >>
> >> root@localhost:/# cat /sys/class/hwmon/hwmon0/name                             
> >> pwmfan
> >>
> >>
> >> So, I add the new 'name' attribute of sysfs for devfreq device.
> >>
> >>>
> >>>> Documentation/ABI/testing/sysfs-class-devfreq | 7 +++++++
> >>>>  drivers/devfreq/devfreq.c                     | 9 +++++++++
> >>>>  2 files changed, 16 insertions(+)
> >>>>
> >>>> diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
> >>>> index 01196e19afca..75897e2fde43 100644
> >>>> --- a/Documentation/ABI/testing/sysfs-class-devfreq
> >>>> +++ b/Documentation/ABI/testing/sysfs-class-devfreq
> >>>> @@ -7,6 +7,13 @@ Description:
> >>>>  		The name of devfreq object denoted as ... is same as the
> >>>>  		name of device using devfreq.
> >>>>  
> >>>> +What:		/sys/class/devfreq/.../name
> >>>> +Date:		November 2019
> >>>> +Contact:	Chanwoo Choi <cw00.choi@samsung.com>
> >>>> +Description:
> >>>> +		The /sys/class/devfreq/.../name shows the name of device
> >>>> +		of the corresponding devfreq object.
> >>>> +
> >>>>  What:		/sys/class/devfreq/.../governor
> >>>>  Date:		September 2011
> >>>>  Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
> >>>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> >>>> index 65a4b6cf3fa5..6f4d93d2a651 100644
> >>>> --- a/drivers/devfreq/devfreq.c
> >>>> +++ b/drivers/devfreq/devfreq.c
> >>>> @@ -1169,6 +1169,14 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
> >>>>  }
> >>>>  EXPORT_SYMBOL(devfreq_remove_governor);
> >>>>  
> >>>> +static ssize_t name_show(struct device *dev,
> >>>> +			struct device_attribute *attr, char *buf)
> >>>> +{
> >>>> +	struct devfreq *devfreq = to_devfreq(dev);
> >>>> +	return sprintf(buf, "%s\n", dev_name(devfreq->dev.parent));
> >>>
> >>> Why is the parent's name being set here, and not the device name?
> >>
> >> The device name style in struct devfreq is 'devfreq%d' instead of
> >> parent device name in order to keep the consistent naming style for devfreq device
> >> as I mentioned above. 'devfreq%d' name is consistent name style for devfreq device.
> >> But, it don't show the real h/w device name. So, show the parent device name
> >> which is specified on device-tree file.
> > 
> > I'm sorry, but I still do not understand.  Can you show me the directory
> > tree before and after here?
> > 
> 
> I'm sorry for not enough description. I add the following example on Odroid-XU3 board.
> 
> 
> 1. Before applied commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X),
> 
> root@localhost:~# ls /sys/class/devfreq                                        
> soc:bus_disp1       soc:bus_fsys_apb  soc:bus_gscl_scaler  soc:bus_mscl
> soc:bus_disp1_fimd  soc:bus_g2d       soc:bus_jpeg         soc:bus_noc
> soc:bus_fsys        soc:bus_g2d_acp   soc:bus_jpeg_apb     soc:bus_peri
> soc:bus_fsys2       soc:bus_gen       soc:bus_mfc          soc:bus_wcore
> 
> root@localhost:~# ls -al /sys/class/devfreq
> total 0
> drwxr-xr-x  2 root root 0 Jan  1 09:00 .
> drwxr-xr-x 52 root root 0 Jan  1 09:00 ..
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_disp1 -> ../../devices/platform/soc/soc:bus_disp1/devfreq/soc:bus_disp1

Ah, that's odd, ok.

> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_disp1_fimd -> ../../devices/platform/soc/soc:bus_disp1_fimd/devfreq/soc:bus_did
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_fsys -> ../../devices/platform/soc/soc:bus_fsys/devfreq/soc:bus_fsys
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_fsys2 -> ../../devices/platform/soc/soc:bus_fsys2/devfreq/soc:bus_fsys2
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_fsys_apb -> ../../devices/platform/soc/soc:bus_fsys_apb/devfreq/soc:bus_fsys_ab
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_g2d -> ../../devices/platform/soc/soc:bus_g2d/devfreq/soc:bus_g2d
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_g2d_acp -> ../../devices/platform/soc/soc:bus_g2d_acp/devfreq/soc:bus_g2d_acp
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_gen -> ../../devices/platform/soc/soc:bus_gen/devfreq/soc:bus_gen
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_gscl_scaler -> ../../devices/platform/soc/soc:bus_gscl_scaler/devfreq/soc:bus_r
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_jpeg -> ../../devices/platform/soc/soc:bus_jpeg/devfreq/soc:bus_jpeg
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_jpeg_apb -> ../../devices/platform/soc/soc:bus_jpeg_apb/devfreq/soc:bus_jpeg_ab
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_mfc -> ../../devices/platform/soc/soc:bus_mfc/devfreq/soc:bus_mfc
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_mscl -> ../../devices/platform/soc/soc:bus_mscl/devfreq/soc:bus_mscl
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_noc -> ../../devices/platform/soc/soc:bus_noc/devfreq/soc:bus_noc
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_peri -> ../../devices/platform/soc/soc:bus_peri/devfreq/soc:bus_peri
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_wcore -> ../../devices/platform/soc/soc:bus_wcore/devfreq/soc:bus_wcore
> 
> 
> 
> 2. After applied commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X),
> 
> root@localhost:~# ls  /sys/class/devfreq                                       
> devfreq0   devfreq11  devfreq14  devfreq3  devfreq6  devfreq9
> devfreq1   devfreq12  devfreq15  devfreq4  devfreq7
> devfreq10  devfreq13  devfreq2   devfreq5  devfreq8

That's better.

> 
> root@localhost:~# ls -al /sys/class/devfreq                                    
> total 0
> drwxr-xr-x  2 root root 0 Jan  1 09:02 .
> drwxr-xr-x 52 root root 0 Jan  1 09:02 ..
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq0 -> ../../devices/platform/soc/soc:bus_wcore/devfreq/devfreq0
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq1 -> ../../devices/platform/soc/soc:bus_noc/devfreq/devfreq1
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq10 -> ../../devices/platform/soc/soc:bus_jpeg/devfreq/devfreq10
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq11 -> ../../devices/platform/soc/soc:bus_jpeg_apb/devfreq/devfreq11
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq12 -> ../../devices/platform/soc/soc:bus_disp1_fimd/devfreq/devfreq12
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq13 -> ../../devices/platform/soc/soc:bus_disp1/devfreq/devfreq13
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq14 -> ../../devices/platform/soc/soc:bus_gscl_scaler/devfreq/devfreq14
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq15 -> ../../devices/platform/soc/soc:bus_mscl/devfreq/devfreq15
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq2 -> ../../devices/platform/soc/soc:bus_fsys_apb/devfreq/devfreq2
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq3 -> ../../devices/platform/soc/soc:bus_fsys/devfreq/devfreq3
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq4 -> ../../devices/platform/soc/soc:bus_fsys2/devfreq/devfreq4
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq5 -> ../../devices/platform/soc/soc:bus_mfc/devfreq/devfreq5
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq6 -> ../../devices/platform/soc/soc:bus_gen/devfreq/devfreq6
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq7 -> ../../devices/platform/soc/soc:bus_peri/devfreq/devfreq7
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq8 -> ../../devices/platform/soc/soc:bus_g2d/devfreq/devfreq8
> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq9 -> ../../devices/platform/soc/soc:bus_g2d_acp/devfreq/devfreq9

Ok, this looks a bit better, but why is there the extra "devfreq"
directory in there?  That was in the original as well, but that feels
odd.

thanks,

greg k-h
