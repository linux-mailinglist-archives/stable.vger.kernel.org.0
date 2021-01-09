Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76742F01DC
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 17:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbhAIQuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 11:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbhAIQuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 11:50:23 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07D7C061786;
        Sat,  9 Jan 2021 08:49:42 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 05B8923078;
        Sat,  9 Jan 2021 17:49:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1610210978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQdTDGsdDAuLmGfhZkbldybEA0xqL9BQeHyrwnZ7LIw=;
        b=r1u6SRAJTd2OfjecNlLDN8rWIrfpZ97loVez/sfp6p5IrJn4PkhVefKhNZ/Xq/JeyUmdUb
        Ta0nD4JwBVjVSSCdYmBCetwUrjaxYU8Xpx/K5VlLDEDHP0xdmT09DutO8tEMxzNEmyDT2U
        gSP5KiYJ9iqmiy0LKE92Ht9WFJL4PCw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 09 Jan 2021 17:49:37 +0100
From:   Michael Walle <michael@walle.cc>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] driver core: Fix device link device name collision
In-Reply-To: <CAGETcx-TT=ce+oSV2miKN5YdO-gY1oqCMVBkgs6D4kfFLpyn1w@mail.gmail.com>
References: <20210108012427.766318-1-saravanak@google.com>
 <9ec99f2f0e1e75e11f2d7d013dc78203@walle.cc>
 <CAGETcx-TT=ce+oSV2miKN5YdO-gY1oqCMVBkgs6D4kfFLpyn1w@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7f10c6c94729dfa48e18f7f4b038403a@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2021-01-08 18:22, schrieb Saravana Kannan:
> On Fri, Jan 8, 2021 at 12:16 AM Michael Walle <michael@walle.cc> wrote:
>> 
>> Am 2021-01-08 02:24, schrieb Saravana Kannan:
>> > The device link device's name was of the form:
>> > <supplier-dev-name>--<consumer-dev-name>
>> >
>> > This can cause name collision as reported here [1] as device names are
>> > not globally unique. Since device names have to be unique within the
>> > bus/class, add the bus/class name as a prefix to the device names used
>> > to
>> > construct the device link device name.
>> >
>> > So the devuce link device's name will be of the form:
>> > <supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>
>> >
>> > [1] -
>> > https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/
>> >
>> > Cc: stable@vger.kernel.org
>> > Fixes: 287905e68dd2 ("driver core: Expose device link details in
>> > sysfs")
>> > Reported-by: Michael Walle <michael@walle.cc>
>> > Signed-off-by: Saravana Kannan <saravanak@google.com>
>> > ---
>> [..]
>> 
>> The changes are missing for the error path and
>> devlink_remove_symlinks(),
>> right?
> 
> Removing symlinks doesn't need the name. Just needs the "handle". So
> we are good there.

I don't get it. What is the "handle"? Without the patch below
kernfs_remove_by_name() in sysfs_remove_link will return -ENOENT. With
the patch it will return 0.

And even if it would work, how is this even logical:

	snprintf(buf, len, "consumer:%s:%s", dev_bus_name(con), dev_name(con));
	ret = sysfs_create_link(&sup->kobj, &link->link_dev.kobj, buf);
	if (ret)
		goto err_con_dev;
	snprintf(buf, len, "supplier:%s:%s", dev_bus_name(sup), dev_name(sup));
	ret = sysfs_create_link(&con->kobj, &link->link_dev.kobj, buf);
	if (ret)
		goto err_sup_dev;
[..]
err_sup_dev:
	snprintf(buf, len, "consumer:%s", dev_name(con));
	sysfs_remove_link(&sup->kobj, buf);

You call sysfs_create_link("consumer:bus_name:dev_name") but the
corresponding rollback is sysfs_remove_link("consumer:dev_name"), that
is super confusing.

>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 4140a69dfe18..385e16d92874 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -485,7 +485,7 @@ static int devlink_add_symlinks(struct device 
>> *dev,
>>         goto out;
>> 
>>   err_sup_dev:
>> -       snprintf(buf, len, "consumer:%s", dev_name(con));
>> +       snprintf(buf, len, "consumer:%s:%s", dev_bus_name(con),
>> dev_name(con));
>>         sysfs_remove_link(&sup->kobj, buf);
>>   err_con_dev:
>>         sysfs_remove_link(&link->link_dev.kobj, "consumer");
>> @@ -508,7 +508,9 @@ static void devlink_remove_symlinks(struct device
>> *dev,
>>         sysfs_remove_link(&link->link_dev.kobj, "consumer");
>>         sysfs_remove_link(&link->link_dev.kobj, "supplier");
>> 
>> -       len = max(strlen(dev_name(sup)), strlen(dev_name(con)));
>> +       len = max(strlen(dev_bus_name(sup)) + strlen(dev_name(sup)),
>> +                 strlen(dev_bus_name(con)) + strlen(dev_name(con)));
>> +       len += strlen(":");
>>         len += strlen("supplier:") + 1;
>>         buf = kzalloc(len, GFP_KERNEL);
>>         if (!buf) {
>> @@ -516,9 +518,9 @@ static void devlink_remove_symlinks(struct device
>> *dev,
>>                 return;
>>         }
>> 
>> -       snprintf(buf, len, "supplier:%s", dev_name(sup));
>> +       snprintf(buf, len, "supplier:%s:%s", dev_bus_name(sup),
>> dev_name(sup));
>>         sysfs_remove_link(&con->kobj, buf);
>> -       snprintf(buf, len, "consumer:%s", dev_name(con));
>> +       snprintf(buf, len, "consumer:%s:%s", dev_bus_name(sup),
>> dev_name(con));

btw this should be dev_bus_name(con).

>>         sysfs_remove_link(&sup->kobj, buf);
>>         kfree(buf);
>>   }
>> 
>> With these changes:
>> 
>> Tested-by: Michael Walle <michael@walle.cc>
> 
> Greg,
> 
> I think it's good to pick up this version if you don't see any issues.

Why so fast?


>> This at least make the warning go away.
> 
> Phew!
> 
>> BUT, there is somesthing strange or at least I don't get it:
>> 
>> # find /sys/bus/pci/devices/0000:00:00.0/ -name "consumer\:*"
>> # find /sys/bus/pci/devices/0000:00:00.1/ -name "consumer\:*"
>> /sys/bus/pci/devices/0000:00:00.1/consumer:mdio_bus:0000:00:00.1:04
>> /sys/bus/pci/devices/0000:00:00.1/consumer:mdio_bus:0000:00:00.1
>> 
>> enetc0 (0000:00:00.0) has no consumers while enetc1 (0000:00:00.1)
>> has ones. Although both have PHYs connected. Here are the
>> corresonding device tree entries:
>> 
>> enetc0:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts?h=v5.11-rc2#n81
>> 
>> enetc1:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts?h=v5.11-rc2#n21
>> 
>> Why is there a link between enetc1 and its PHY (and MDIO bus)
>> but not for enetc0?
> 
> So a lot of subtle things could be going on here that make it look
> like it's not working correctly but it's actually working fine. Since
> fw_devlink=permissive is the default mode, all links that are created
> are SYNC_STATE_ONLY links. These links are deleted after their
> consumers probe. So if you really want to see all the "real" links
> persist, try booting with fw_devlink=on. You might have boot issues
> though -- I'm working on that separately [1]. Also, SYNC_STATE_ONLY
> links can be created between the parent of a consumer and the supplier
> (I won't get into the why here) depending on some ordering -- so that
> might be causing some spurious looking links, but they aren't.
> 
> Another way to do what you are trying to do is to enable the logs in
> device_link_add() and look at them to see if all the links are created
> as you'd expect.
> 
>> btw, here are all links:
>> 
>> # ls /sys/class/devlink/
>> pci:0000:00:00.1--mdio_bus:0000:00:00.1
>> platform:5000000.iommu--pci:0000:00:00.0
>> platform:5000000.iommu--pci:0000:00:00.1
>> platform:5000000.iommu--pci:0000:00:00.2
>> platform:5000000.iommu--pci:0000:00:00.3
>> platform:5000000.iommu--pci:0000:00:00.5
>> platform:5000000.iommu--pci:0000:00:00.6
>> platform:5000000.iommu--pci:0001:00:00.0
>> platform:5000000.iommu--pci:0002:00:00.0
>> platform:5000000.iommu--platform:2140000.mmc
>> platform:5000000.iommu--platform:2150000.mmc
>> platform:5000000.iommu--platform:22c0000.dma-controller
>> platform:5000000.iommu--platform:3100000.usb
>> platform:5000000.iommu--platform:3110000.usb
>> platform:5000000.iommu--platform:3200000.sata
>> platform:5000000.iommu--platform:8000000.crypto
>> platform:5000000.iommu--platform:8380000.dma-controller
>> platform:5000000.iommu--platform:f080000.display
>> platform:f1f0000.clock-controller--platform:f080000.display
>> regulator:regulator.0--i2c:0-0050
>> regulator:regulator.0--i2c:1-0057
>> regulator:regulator.0--i2c:2-0050
>> regulator:regulator.0--platform:3200000.sata
> 
> As you can see, most of the links that fw_devlink created are gone.
> Because all the consumers probed. Any remaining ones you see here are
> non-SYNC_STATE_ONLY links created by the driver/frameworks or cases
> where consumers haven't probed. My guess is that only the first one is
> of this criteria and it doesn't hurt anything here. Try booting with
> fw_devlink=on and check this list. That'll give you a better idea.

Thanks for explaining. I'll try that.

-michael
