Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E19A2C7CC1
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 03:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgK3C3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 21:29:24 -0500
Received: from mail-m1272.qiye.163.com ([115.236.127.2]:47342 "EHLO
        mail-m1272.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgK3C3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Nov 2020 21:29:24 -0500
Received: from [172.23.68.66] (unknown [119.123.242.56])
        by mail-m1272.qiye.163.com (Hmail) with ESMTPA id 17034B02048;
        Mon, 30 Nov 2020 10:28:35 +0800 (CST)
Subject: Re: [PATCH] scsi: ses: Fix crash caused by kfree an invalid pointer
To:     dgilbert@interlog.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
References: <20201128122302.9490-1-dinghui@sangfor.com.cn>
 <c5deac044ac409e32d9ad9968ce0dcbc996bfc7a.camel@linux.ibm.com>
 <4b83e264-2a7e-e877-5f52-16b14b563a87@interlog.com>
From:   Ding Hui <dinghui@sangfor.com.cn>
Message-ID: <8fbbe4de-13f0-6c99-98f9-5c47c8251a9f@sangfor.com.cn>
Date:   Mon, 30 Nov 2020 10:26:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <4b83e264-2a7e-e877-5f52-16b14b563a87@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZQ09OGU4aHkMfQkkYVkpNS01MS0hISk5PT0xVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hOT1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MEk6TTo5Dj8fQk0eIh0MTihW
        OgwwCRBVSlVKTUtNTEtISEpNSUlCVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKSkJVSklIVUlPSVVOTVlXWQgBWUFJS01LQzcG
X-HM-Tid: 0a7616faf96e98b7kuuu17034b02048
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/11/29 13:12, Douglas Gilbert wrote:
> On 2020-11-28 6:27 p.m., James Bottomley wrote:
>> On Sat, 2020-11-28 at 20:23 +0800, Ding Hui wrote:
>>> We can get a crash when disconnecting the iSCSI session,
>>> the call trace like this:
>>>
>>>    [ffff00002a00fb70] kfree at ffff00000830e224
>>>    [ffff00002a00fba0] ses_intf_remove at ffff000001f200e4
>>>    [ffff00002a00fbd0] device_del at ffff0000086b6a98
>>>    [ffff00002a00fc50] device_unregister at ffff0000086b6d58
>>>    [ffff00002a00fc70] __scsi_remove_device at ffff00000870608c
>>>    [ffff00002a00fca0] scsi_remove_device at ffff000008706134
>>>    [ffff00002a00fcc0] __scsi_remove_target at ffff0000087062e4
>>>    [ffff00002a00fd10] scsi_remove_target at ffff0000087064c0
>>>    [ffff00002a00fd70] __iscsi_unbind_session at ffff000001c872c4
>>>    [ffff00002a00fdb0] process_one_work at ffff00000810f35c
>>>    [ffff00002a00fe00] worker_thread at ffff00000810f648
>>>    [ffff00002a00fe70] kthread at ffff000008116e98
>>>
>>> In ses_intf_add, components count could be 0, and kcalloc 0 size
>>> scomp,
>>> but not saved in edev->component[i].scratch
>>>
>>> In this situation, edev->component[0].scratch is an invalid pointer,
>>> when kfree it in ses_intf_remove_enclosure, a crash like above would
>>> happen
>>> The call trace also could be other random cases when kfree cannot
>>> catch
>>> the invalid pointer
>>>
>>> We should not use edev->component[] array when the components count
>>> is 0
>>> We also need check index when use edev->component[] array in
>>> ses_enclosure_data_process
>>>
>>> Tested-by: Zeng Zhicong <timmyzeng@163.com>
>>> Cc: stable <stable@vger.kernel.org> # 2.6.25+
>>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>>
>> This doesn't really look to be the right thing to do: an enclosure
>> which has no component can't usefully be controlled by the driver since
>> there's nothing for it to do, so what we should do in this situation is
>> refuse to attach like the proposed patch below.
>>
>> It does seem a bit odd that someone would build an enclosure that
>> doesn't enclose anything, so would you mind running
>>
>> sg_ses -e
> 
> '-e' is the short form of '--enumerate'. That will report the names
> and abbreviations of the diagnostic pages that the utility itself
> knows about (and supports). It won't show anything specific about
> the environment that sg_ses is executed in.
> 
> You probably meant:
>    sg_ses <ses_device>
> 
> Examples of the likely forms are:
>    sg_ses /dev/bsg/1:0:0:0
>    sg_ses /dev/sg2
>    sg_ses /dev/ses0
> 
> This from a nearby machine:
> 
> $ lsscsi -gs
> [3:0:0:0]  disk  ATA      Samsung SSD 850  1B6Q  /dev/sda   /dev/sg0    
> 120GB
> [4:0:0:0]  disk  IBM-207x HUSMM8020ASS20   J4B6  /dev/sdc   /dev/sg2    
> 200GB
> [4:0:1:0]  disk  ATA      INTEL SSDSC2KW25 003C  /dev/sdd   /dev/sg3    
> 256GB
> [4:0:2:0]  disk  SEAGATE  ST10000NM0096    E005  /dev/sde   /dev/sg4   
> 10.0TB
> [4:0:3:0]  enclosu Areca Te ARC-802801.37.69 0137  -        
> /dev/sg5        -
> [4:0:4:0]  enclosu Intel    RES2SV240        0d00  -        
> /dev/sg6        -
> [7:0:0:0]  disk    Kingston DataTravelerMini PMAP  /dev/sdb /dev/sg1   
> 1.03GB
> [N:0:0:1]  disk    WDC WDS256G1X0C-00ENX0__1       /dev/nvme0n1  -      
> 256GB
> 
> # sg_ses /dev/sg5
>    Areca Te  ARC-802801.37.69  0137
> Supported diagnostic pages:
>    Supported Diagnostic Pages [sdp] [0x0]
>    Configuration (SES) [cf] [0x1]
>    Enclosure Status/Control (SES) [ec,es] [0x2]
>    String In/Out (SES) [str] [0x4]
>    Threshold In/Out (SES) [th] [0x5]
>    Element Descriptor (SES) [ed] [0x7]
>    Additional Element Status (SES-2) [aes] [0xa]
>    Supported SES Diagnostic Pages (SES-2) [ssp] [0xd]
>    Download Microcode (SES-2) [dm] [0xe]
>    Subenclosure Nickname (SES-2) [snic] [0xf]
>    Protocol Specific (SAS transport) [] [0x3f]
> 
> # sg_ses -p cf /dev/sg5
>    Areca Te  ARC-802801.37.69  0137
> Configuration diagnostic page:
>    number of secondary subenclosures: 0
>    generation code: 0x0
>    enclosure descriptor list
>      Subenclosure identifier: 0 [primary]
>        relative ES process id: 1, number of ES processes: 1
>        number of type descriptor headers: 9
>        enclosure logical identifier (hex): d5b401503fc0ec16
>        enclosure vendor: Areca Te  product: ARC-802801.37.69  rev: 0137
>        vendor-specific data:
>          11 22 33 44 55 00 00 00                             ."3DU...
> 
>    type descriptor header and text list
>      Element type: Array device slot, subenclosure id: 0
>        number of possible elements: 24
>        text: ArrayDevicesInSubEnclsr0
>      Element type: Enclosure, subenclosure id: 0
>        number of possible elements: 1
>        text: EnclosureElementInSubEnclsr0
>      Element type: SAS expander, subenclosure id: 0
>        number of possible elements: 1
>        text: SAS Expander
>      Element type: Cooling, subenclosure id: 0
>        number of possible elements: 5
>        text: CoolingElementInSubEnclsr0
>      Element type: Temperature sensor, subenclosure id: 0
>        number of possible elements: 2
>        text: TempSensorsInSubEnclsr0
>      Element type: Voltage sensor, subenclosure id: 0
>        number of possible elements: 2
>        text: VoltageSensorsInSubEnclsr0
>      Element type: SAS connector, subenclosure id: 0
>        number of possible elements: 3
>        text: ConnectorsInSubEnclsr0
>      Element type: Power supply, subenclosure id: 0
>        number of possible elements: 2
>        text: PowerSupplyInSubEnclsr0
>      Element type: Audible alarm, subenclosure id: 0
>        number of possible elements: 1
>        text: AudibleAlarmInSubEnclsr0
> 
> Doug Gilbert
> 
>> on it and reporting back what it shows?  It's possible there's another
>> type that the enclosure device should be tracking.

kernel log:

2020-11-30 09:29:44.228339 info [kernel:] [425726.567579] scsi host18: 
iSCSI Initiator over TCP/IP
2020-11-30 09:29:44.476319 notice [kernel:] [425726.817417] scsi 
18:0:0:0: Direct-Access     DELL     MD32xxi          0784 PQ: 0 ANSI: 5
2020-11-30 09:29:44.480314 notice [kernel:] [425726.820591] scsi 
18:0:0:0: rdac: LUN 0 (IOSHIP) (owned)
2020-11-30 09:29:44.480319 notice [kernel:] [425726.820810] sd 18:0:0:0: 
Attached scsi generic sg30 type 0
2020-11-30 09:29:44.480320 notice [kernel:] [425726.820812] sd 18:0:0:0: 
Embedded Enclosure Device
2020-11-30 09:29:44.480321 warning [kernel:] [425726.821119] sd 
18:0:0:0: Mode parameters changed
2020-11-30 09:29:44.492316 info [kernel:] [425726.831444] sd 18:0:0:0: 
[ses_intf_add]:777 sdev: ffff8027ca170000   edev:ffff80271459cc00  com: 
0 edev->component[0].scratch: 0000000000000000
2020-11-30 09:29:44.492326 notice [kernel:] [425726.832326] sd 18:0:0:0: 
[sdt] 31457280 512-byte logical blocks: (16.1 GB/15.0 GiB)
2020-11-30 09:29:44.496308 notice [kernel:] [425726.836252] sd 18:0:0:0: 
[sdt] Write Protect is off
2020-11-30 09:29:44.496313 debug [kernel:] [425726.836255] sd 18:0:0:0: 
[sdt] Mode Sense: 83 00 10 08
2020-11-30 09:29:44.500310 notice [kernel:] [425726.838436] sd 18:0:0:0: 
[sdt] Write cache: enabled, read cache: enabled, supports DPO and FUA
2020-11-30 09:29:44.500315 notice [kernel:] [425726.838573] scsi 
18:0:0:1: Direct-Access     DELL     MD32xxi          0784 PQ: 0 ANSI: 5
2020-11-30 09:29:44.501437 notice [kernel:] [425726.842314] scsi 
18:0:0:1: rdac: LUN 1 (IOSHIP) (owned)
2020-11-30 09:29:44.501442 notice [kernel:] [425726.842501] sd 18:0:0:1: 
Attached scsi generic sg31 type 0
2020-11-30 09:29:44.501442 notice [kernel:] [425726.842502] sd 18:0:0:1: 
Embedded Enclosure Device
2020-11-30 09:29:44.501443 warning [kernel:] [425726.842688] sd 
18:0:0:1: Mode parameters changed
2020-11-30 09:29:44.512325 info [kernel:] [425726.852905] sd 18:0:0:1: 
[ses_intf_add]:777 sdev: ffff8027ca162000   edev:ffff80271459d400  com: 
0 edev->component[0].scratch: 0000000000000000
2020-11-30 09:29:44.512335 notice [kernel:] [425726.853249] sd 18:0:0:1: 
[sdu] 104857600 512-byte logical blocks: (53.7 GB/50.0 GiB)
2020-11-30 09:29:44.514333 notice [kernel:] [425726.853778] sd 18:0:0:1: 
[sdu] Write Protect is off
2020-11-30 09:29:44.514338 debug [kernel:] [425726.853780] sd 18:0:0:1: 
[sdu] Mode Sense: 83 00 10 08
2020-11-30 09:29:44.514339 notice [kernel:] [425726.853908] scsi 
18:0:0:31: Direct-Access     DELL     Universal Xport  0784 PQ: 0 ANSI: 5
2020-11-30 09:29:44.514340 notice [kernel:] [425726.854524] sd 18:0:0:1: 
[sdu] Write cache: enabled, read cache: enabled, supports DPO and FUA
2020-11-30 09:29:44.514340 notice [kernel:] [425726.855140] sd 18:0:0:0: 
[sdt] Attached SCSI disk
2020-11-30 09:29:44.514341 notice [kernel:] [425726.855221] scsi 
18:0:0:31: Attached scsi generic sg32 type 0
2020-11-30 09:29:44.514342 notice [kernel:] [425726.855223] scsi 
18:0:0:31: Embedded Enclosure Device
2020-11-30 09:29:44.514383 warning [kernel:] [425726.855571] scsi 
18:0:0:31: Power-on or device reset occurred
2020-11-30 09:29:44.514383 err [kernel:] [425726.855587] scsi 18:0:0:31: 
Failed to get diagnostic page 0x1
2020-11-30 09:29:44.514384 err [kernel:] [425726.855594] scsi 18:0:0:31: 
Failed to bind enclosure -19
2020-11-30 09:29:44.514388 info [kernel:] [425726.855599] scsi 
18:0:0:31: sdev: ffff8027ca173000
2020-11-30 09:29:44.524329 notice [kernel:] [425726.863747] sd 18:0:0:1: 
[sdu] Attached SCSI disk
2020-11-30 09:29:44.764335 err [kernel:] [425727.103405] I/O scheduler 
mq-deadline not found
2020-11-30 09:29:44.888323 err [kernel:] [425727.228994] I/O scheduler 
mq-deadline not found
2020-11-30 09:29:45.001274 warning [kernel:] [425727.342284] 
device-mapper: multipath round-robin: repeat_count > 1 is deprecated, 
using 1 instead
2020-11-30 09:31:41.116334 info [kernel:] [425843.460697] scsi host19: 
iSCSI Initiator over TCP/IP
2020-11-30 09:31:41.356325 notice [kernel:] [425843.700556] scsi 
19:0:0:0: Direct-Access     DELL     MD32xxi          0784 PQ: 0 ANSI: 5
2020-11-30 09:31:41.360325 notice [kernel:] [425843.704270] scsi 
19:0:0:0: rdac: LUN 0 (IOSHIP) (owned)
2020-11-30 09:31:41.360334 notice [kernel:] [425843.704478] sd 19:0:0:0: 
Attached scsi generic sg33 type 0
2020-11-30 09:31:41.360334 notice [kernel:] [425843.704480] sd 19:0:0:0: 
Embedded Enclosure Device
2020-11-30 09:31:41.360335 warning [kernel:] [425843.704732] sd 
19:0:0:0: Mode parameters changed
2020-11-30 09:31:41.380310 info [kernel:] [425843.723464] sd 19:0:0:0: 
[ses_intf_add]:777 sdev: ffff8027c8984000   edev:ffff802723f68400  com: 
0 edev->component[0].scratch: 0000000000000000
2020-11-30 09:31:41.380317 notice [kernel:] [425843.724232] sd 19:0:0:0: 
[sdv] 31457280 512-byte logical blocks: (16.1 GB/15.0 GiB)
2020-11-30 09:31:41.384308 notice [kernel:] [425843.729742] sd 19:0:0:0: 
[sdv] Write Protect is off
2020-11-30 09:31:41.384313 debug [kernel:] [425843.729745] sd 19:0:0:0: 
[sdv] Mode Sense: 83 00 10 08
2020-11-30 09:31:41.388310 notice [kernel:] [425843.730436] sd 19:0:0:0: 
[sdv] Write cache: enabled, read cache: enabled, supports DPO and FUA
2020-11-30 09:31:41.388316 notice [kernel:] [425843.730557] scsi 
19:0:0:1: Direct-Access     DELL     MD32xxi          0784 PQ: 0 ANSI: 5
2020-11-30 09:31:41.392312 notice [kernel:] [425843.736948] scsi 
19:0:0:1: rdac: LUN 1 (IOSHIP) (owned)
2020-11-30 09:31:41.392317 notice [kernel:] [425843.737146] sd 19:0:0:1: 
Attached scsi generic sg34 type 0
2020-11-30 09:31:41.392317 notice [kernel:] [425843.737148] sd 19:0:0:1: 
Embedded Enclosure Device
2020-11-30 09:31:41.392318 warning [kernel:] [425843.737829] sd 
19:0:0:1: Mode parameters changed
2020-11-30 09:31:41.404316 info [kernel:] [425843.749482] sd 19:0:0:1: 
[ses_intf_add]:777 sdev: ffff8027c899e000   edev:ffff802723f6e800  com: 
0 edev->component[0].scratch: 0000000000000000
2020-11-30 09:31:41.404326 notice [kernel:] [425843.749862] sd 19:0:0:1: 
[sdw] 104857600 512-byte logical blocks: (53.7 GB/50.0 GiB)
2020-11-30 09:31:41.408331 notice [kernel:] [425843.750597] sd 19:0:0:1: 
[sdw] Write Protect is off
2020-11-30 09:31:41.408346 debug [kernel:] [425843.750598] sd 19:0:0:1: 
[sdw] Mode Sense: 83 00 10 08
2020-11-30 09:31:41.408347 notice [kernel:] [425843.751325] scsi 
19:0:0:31: Direct-Access     DELL     Universal Xport  0784 PQ: 0 ANSI: 5
2020-11-30 09:31:41.408347 notice [kernel:] [425843.751979] sd 19:0:0:1: 
[sdw] Write cache: enabled, read cache: enabled, supports DPO and FUA
2020-11-30 09:31:41.408348 notice [kernel:] [425843.753105] scsi 
19:0:0:31: Attached scsi generic sg35 type 0
2020-11-30 09:31:41.408349 notice [kernel:] [425843.753109] scsi 
19:0:0:31: Embedded Enclosure Device
2020-11-30 09:31:41.408350 notice [kernel:] [425843.753165] sd 19:0:0:0: 
[sdv] Attached SCSI disk
2020-11-30 09:31:41.408351 warning [kernel:] [425843.753377] scsi 
19:0:0:31: Power-on or device reset occurred
2020-11-30 09:31:41.408352 err [kernel:] [425843.753388] scsi 19:0:0:31: 
Failed to get diagnostic page 0x1
2020-11-30 09:31:41.408352 err [kernel:] [425843.753390] scsi 19:0:0:31: 
Failed to bind enclosure -19
2020-11-30 09:31:41.408353 info [kernel:] [425843.753391] scsi 
19:0:0:31: sdev: ffff8027c899c000
2020-11-30 09:31:41.416332 notice [kernel:] [425843.759795] sd 19:0:0:1: 
[sdw] Attached SCSI disk


# cat /sys/class/enclosure/18\:0\:0\:0/components
0
# cat /sys/class/enclosure/18\:0\:0\:1/components
0
# cat /sys/class/enclosure/19\:0\:0\:0/components
0
# cat /sys/class/enclosure/19\:0\:0\:1/components
0

# sg_ses -e
Diagnostic pages, followed by abbreviation(s) then page code:
     Supported Diagnostic Pages  [sdp] [0x0]
     Configuration (SES)  [cf] [0x1]
     Enclosure Status/Control (SES)  [ec,es] [0x2]
     Help Text (SES)  [ht] [0x3]
     String In/Out (SES)  [str] [0x4]
     Threshold In/Out (SES)  [th] [0x5]
     Array Status/Control (SES, obsolete)  [ac,as] [0x6]
     Element Descriptor (SES)  [ed] [0x7]
     Short Enclosure Status (SES)  [ses] [0x8]
     Enclosure Busy (SES-2)  [eb] [0x9]
     Additional Element Status (SES-2)  [aes] [0xa]
     Subenclosure Help Text (SES-2)  [sht] [0xb]
     Subenclosure String In/Out (SES-2)  [sstr] [0xc]
     Supported SES Diagnostic Pages (SES-2)  [ssp] [0xd]
     Download Microcode (SES-2)  [dm] [0xe]
     Subenclosure Nickname (SES-2)  [snic] [0xf]
     Protocol Specific (SAS transport)  [] [0x3f]
     Translate Address (SBC)  [] [0x40]
     Device Status (SBC)  [] [0x41]
     Rebuild Assist (SBC)  [] [0x42]

SES element type names, followed by abbreviation and element type code:
     Unspecified  [un] [0x0]
     Device slot  [dev] [0x1]
     Power supply  [ps] [0x2]
     Cooling  [coo] [0x3]
     Temperature sensor  [ts] [0x4]
     Door  [do] [0x5]
     Audible alarm  [aa] [0x6]
     Enclosure services controller electronics  [esc] [0x7]
     SCC controller electronics  [sce] [0x8]
     Nonvolatile cache  [nc] [0x9]
     Invalid operation reason  [ior] [0xa]
     Uninterruptible power supply  [ups] [0xb]
     Display  [dis] [0xc]
     Key pad entry  [kpe] [0xd]
     Enclosure  [enc] [0xe]
     SCSI port/transceiver  [sp] [0xf]
     Language  [lan] [0x10]
     Communication port  [cp] [0x11]
     Voltage sensor  [vs] [0x12]
     Current sensor  [cs] [0x13]
     SCSI target port  [stp] [0x14]
     SCSI initiator port  [sip] [0x15]
     Simple subenclosure  [ss] [0x16]
     Array device slot  [arr] [0x17]
     SAS expander  [sse] [0x18]
     SAS connector  [ssc] [0x19]

# sg_ses /dev/sdu
   DELL      MD32xxi           0784
     disk device has EncServ bit set
Supported diagnostic pages:
   Supported Diagnostic Pages [sdp] [0x0]
   Configuration (SES) [cf] [0x1]
   Enclosure Status/Control (SES) [ec,es] [0x2]
   Array Status/Control (SES, obsolete) [ac,as] [0x6]

# sg_ses -p cf /dev/sdu
   DELL      MD32xxi           0784
     disk device has EncServ bit set
Configuration diagnostic page:
   number of secondary subenclosures: 0
   generation code: 0x12c
   enclosure descriptor list
     Subenclosure identifier: 0 (primary)
       relative ES process id: 0, number of ES processes: 0
       number of type descriptor headers: 5
       enclosure logical identifier (hex): 0000000000000000
       enclosure vendor: DELL      product: MD32xxi           rev: 0784
       vendor-specific data:
         30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30
         00 00 00 00
   type descriptor header/text list
     Element type: Device slot, subenclosure id: 0
       number of possible elements: 12
     Element type: Power supply, subenclosure id: 0
       number of possible elements: 2
     Element type: Cooling, subenclosure id: 0
       number of possible elements: 4
     Element type: Temperature sensor, subenclosure id: 0
       number of possible elements: 4
     Element type: SCC controller electronics, subenclosure id: 0
       number of possible elements: 1

I'm not goot at ses, but it seems that ses does not get the right 
component count

>>
>> Regards,
>>
>> James
>>
>> ---8>8>8><8<8<8--------
>> From: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Subject: [PATCH] scsi: ses: don't attach if enclosure has no components
>>
>> An enclosure with no components can't usefully be operated by the
>> driver (since effectively it has nothing to manage), so report the
>> problem and don't attach.  Not attaching also fixes an oops which
>> could occur if the driver tries to manage a zero component enclosure.
>>
>> Reported-by: Ding Hui <dinghui@sangfor.com.cn>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>> ---
>>   drivers/scsi/ses.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
>> index c2afba2a5414..9624298b9c89 100644
>> --- a/drivers/scsi/ses.c
>> +++ b/drivers/scsi/ses.c
>> @@ -690,6 +690,11 @@ static int ses_intf_add(struct device *cdev,
>>               type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
>>               components += type_ptr[1];
>>       }
>> +    if (components == 0) {
>> +        sdev_printk(KERN_ERR, sdev, "enclosure has no enumerated 
>> components\n");
>> +        goto err_free;
>> +    }
>> +
>>       ses_dev->page1 = buf;
>>       ses_dev->page1_len = len;
>>       buf = NULL;
>>
> 


-- 
Thanks,
- Ding Hui
