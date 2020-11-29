Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3552C779D
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 06:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgK2FWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 00:22:12 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:42526 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgK2FWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Nov 2020 00:22:12 -0500
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Nov 2020 00:22:11 EST
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 1157F2EA00C;
        Sun, 29 Nov 2020 00:12:23 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id OpmIgPKamWzG; Sun, 29 Nov 2020 00:02:10 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 865D72EA01E;
        Sun, 29 Nov 2020 00:12:21 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: ses: Fix crash caused by kfree an invalid pointer
To:     jejb@linux.ibm.com, Ding Hui <dinghui@sangfor.com.cn>,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
References: <20201128122302.9490-1-dinghui@sangfor.com.cn>
 <c5deac044ac409e32d9ad9968ce0dcbc996bfc7a.camel@linux.ibm.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <4b83e264-2a7e-e877-5f52-16b14b563a87@interlog.com>
Date:   Sun, 29 Nov 2020 00:12:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c5deac044ac409e32d9ad9968ce0dcbc996bfc7a.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-11-28 6:27 p.m., James Bottomley wrote:
> On Sat, 2020-11-28 at 20:23 +0800, Ding Hui wrote:
>> We can get a crash when disconnecting the iSCSI session,
>> the call trace like this:
>>
>>    [ffff00002a00fb70] kfree at ffff00000830e224
>>    [ffff00002a00fba0] ses_intf_remove at ffff000001f200e4
>>    [ffff00002a00fbd0] device_del at ffff0000086b6a98
>>    [ffff00002a00fc50] device_unregister at ffff0000086b6d58
>>    [ffff00002a00fc70] __scsi_remove_device at ffff00000870608c
>>    [ffff00002a00fca0] scsi_remove_device at ffff000008706134
>>    [ffff00002a00fcc0] __scsi_remove_target at ffff0000087062e4
>>    [ffff00002a00fd10] scsi_remove_target at ffff0000087064c0
>>    [ffff00002a00fd70] __iscsi_unbind_session at ffff000001c872c4
>>    [ffff00002a00fdb0] process_one_work at ffff00000810f35c
>>    [ffff00002a00fe00] worker_thread at ffff00000810f648
>>    [ffff00002a00fe70] kthread at ffff000008116e98
>>
>> In ses_intf_add, components count could be 0, and kcalloc 0 size
>> scomp,
>> but not saved in edev->component[i].scratch
>>
>> In this situation, edev->component[0].scratch is an invalid pointer,
>> when kfree it in ses_intf_remove_enclosure, a crash like above would
>> happen
>> The call trace also could be other random cases when kfree cannot
>> catch
>> the invalid pointer
>>
>> We should not use edev->component[] array when the components count
>> is 0
>> We also need check index when use edev->component[] array in
>> ses_enclosure_data_process
>>
>> Tested-by: Zeng Zhicong <timmyzeng@163.com>
>> Cc: stable <stable@vger.kernel.org> # 2.6.25+
>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> 
> This doesn't really look to be the right thing to do: an enclosure
> which has no component can't usefully be controlled by the driver since
> there's nothing for it to do, so what we should do in this situation is
> refuse to attach like the proposed patch below.
> 
> It does seem a bit odd that someone would build an enclosure that
> doesn't enclose anything, so would you mind running
> 
> sg_ses -e

'-e' is the short form of '--enumerate'. That will report the names
and abbreviations of the diagnostic pages that the utility itself
knows about (and supports). It won't show anything specific about
the environment that sg_ses is executed in.

You probably meant:
   sg_ses <ses_device>

Examples of the likely forms are:
   sg_ses /dev/bsg/1:0:0:0
   sg_ses /dev/sg2
   sg_ses /dev/ses0

This from a nearby machine:

$ lsscsi -gs
[3:0:0:0]  disk  ATA      Samsung SSD 850  1B6Q  /dev/sda   /dev/sg0    120GB
[4:0:0:0]  disk  IBM-207x HUSMM8020ASS20   J4B6  /dev/sdc   /dev/sg2    200GB
[4:0:1:0]  disk  ATA      INTEL SSDSC2KW25 003C  /dev/sdd   /dev/sg3    256GB
[4:0:2:0]  disk  SEAGATE  ST10000NM0096    E005  /dev/sde   /dev/sg4   10.0TB
[4:0:3:0]  enclosu Areca Te ARC-802801.37.69 0137  -        /dev/sg5        -
[4:0:4:0]  enclosu Intel    RES2SV240        0d00  -        /dev/sg6        -
[7:0:0:0]  disk    Kingston DataTravelerMini PMAP  /dev/sdb /dev/sg1   1.03GB
[N:0:0:1]  disk    WDC WDS256G1X0C-00ENX0__1       /dev/nvme0n1  -      256GB

# sg_ses /dev/sg5
   Areca Te  ARC-802801.37.69  0137
Supported diagnostic pages:
   Supported Diagnostic Pages [sdp] [0x0]
   Configuration (SES) [cf] [0x1]
   Enclosure Status/Control (SES) [ec,es] [0x2]
   String In/Out (SES) [str] [0x4]
   Threshold In/Out (SES) [th] [0x5]
   Element Descriptor (SES) [ed] [0x7]
   Additional Element Status (SES-2) [aes] [0xa]
   Supported SES Diagnostic Pages (SES-2) [ssp] [0xd]
   Download Microcode (SES-2) [dm] [0xe]
   Subenclosure Nickname (SES-2) [snic] [0xf]
   Protocol Specific (SAS transport) [] [0x3f]

# sg_ses -p cf /dev/sg5
   Areca Te  ARC-802801.37.69  0137
Configuration diagnostic page:
   number of secondary subenclosures: 0
   generation code: 0x0
   enclosure descriptor list
     Subenclosure identifier: 0 [primary]
       relative ES process id: 1, number of ES processes: 1
       number of type descriptor headers: 9
       enclosure logical identifier (hex): d5b401503fc0ec16
       enclosure vendor: Areca Te  product: ARC-802801.37.69  rev: 0137
       vendor-specific data:
         11 22 33 44 55 00 00 00                             ."3DU...

   type descriptor header and text list
     Element type: Array device slot, subenclosure id: 0
       number of possible elements: 24
       text: ArrayDevicesInSubEnclsr0
     Element type: Enclosure, subenclosure id: 0
       number of possible elements: 1
       text: EnclosureElementInSubEnclsr0
     Element type: SAS expander, subenclosure id: 0
       number of possible elements: 1
       text: SAS Expander
     Element type: Cooling, subenclosure id: 0
       number of possible elements: 5
       text: CoolingElementInSubEnclsr0
     Element type: Temperature sensor, subenclosure id: 0
       number of possible elements: 2
       text: TempSensorsInSubEnclsr0
     Element type: Voltage sensor, subenclosure id: 0
       number of possible elements: 2
       text: VoltageSensorsInSubEnclsr0
     Element type: SAS connector, subenclosure id: 0
       number of possible elements: 3
       text: ConnectorsInSubEnclsr0
     Element type: Power supply, subenclosure id: 0
       number of possible elements: 2
       text: PowerSupplyInSubEnclsr0
     Element type: Audible alarm, subenclosure id: 0
       number of possible elements: 1
       text: AudibleAlarmInSubEnclsr0

Doug Gilbert

> on it and reporting back what it shows?  It's possible there's another
> type that the enclosure device should be tracking.
> 
> Regards,
> 
> James
> 
> ---8>8>8><8<8<8--------
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Subject: [PATCH] scsi: ses: don't attach if enclosure has no components
> 
> An enclosure with no components can't usefully be operated by the
> driver (since effectively it has nothing to manage), so report the
> problem and don't attach.  Not attaching also fixes an oops which
> could occur if the driver tries to manage a zero component enclosure.
> 
> Reported-by: Ding Hui <dinghui@sangfor.com.cn>
> Cc: stable@vger.kernel.org
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>   drivers/scsi/ses.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index c2afba2a5414..9624298b9c89 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -690,6 +690,11 @@ static int ses_intf_add(struct device *cdev,
>   		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
>   			components += type_ptr[1];
>   	}
> +	if (components == 0) {
> +		sdev_printk(KERN_ERR, sdev, "enclosure has no enumerated components\n");
> +		goto err_free;
> +	}
> +
>   	ses_dev->page1 = buf;
>   	ses_dev->page1_len = len;
>   	buf = NULL;
> 

