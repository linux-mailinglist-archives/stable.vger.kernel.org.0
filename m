Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14581650B0C
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 12:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiLSL7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 06:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiLSL7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 06:59:01 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775C98FFC;
        Mon, 19 Dec 2022 03:58:59 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id CC4B860293A85;
        Mon, 19 Dec 2022 12:58:56 +0100 (CET)
Message-ID: <48e83fa7-00a6-ba11-0db3-a165ce3c0699@molgen.mpg.de>
Date:   Mon, 19 Dec 2022 12:58:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: matroxfb: cannot determine memory size
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>
Cc:     "Z. Liu" <liuzx@knownsec.com>, linux-fbdev@vger.kernel.org,
        it+linux-fbdev@molgen.mpg.de, regressions@lists.linux.dev,
        stable@vger.kernel.org
References: <5da53ec5-3a9c-ec87-da20-69f140aaaa6b@molgen.mpg.de>
 <6ef71be5-def9-4578-3f73-c43c35d7e4a9@gmx.de>
 <dc0b1487-04f9-5a2f-e0f8-d157a74b6bcb@molgen.mpg.de> <Y5zhUl7r9z0lFJxc@p100>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <Y5zhUl7r9z0lFJxc@p100>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Dear Helge,


Am 16.12.22 um 22:21 schrieb Helge Deller:
> * Paul Menzel <pmenzel@molgen.mpg.de>:
>> [Cc: +regressions@, +stable@]
>>
>> #regzbot ^introduced: 62d89a7d49afe46e6b9bbe9e23b004ad848dbde4

>> Am 16.12.22 um 00:02 schrieb Helge Deller:
>>> On 12/15/22 17:39, Paul Menzel wrote:
>>
>>>> Between Linux 5.10.103 and 5.10.110/5.15.77, matrixfb fails to load.

[…]

>>>> ### 5.15.77
>>>>
>>>>       [    0.000000] Linux version 5.15.77.mx64.440 (root@theinternet.molgen.mpg.de) (gcc (GCC) 10.4.0, GNU ld (GNU Binutils) 2.37) #1 SMP Tue Nov 8 15:42:33 CET 2022
>>>>       [    0.000000] Command line: root=LABEL=root ro crashkernel=64G-:256M console=ttyS0,115200n8 console=tty0 init=/bin/systemd audit=0 random.trust_cpu=on systemd.unified_cgroup_hierarchy
>>>>       […]
>>>>       [    0.000000] DMI: Dell Inc. PowerEdge R715/0G2DP3, BIOS 1.5.2 04/19/2011
>>>>       […]
>>>>       [    9.436420] matroxfb: Matrox MGA-G200eW (PCI) detected
>>>>       [    9.444502] matroxfb: cannot determine memory size
>>>>       [    9.449316] matroxfb: probe of 0000:0a:03.0 failed with error -1
>>>>
>>>> We see it on several systems:
>>>>
>>>>       $ lspci -nn -s 0a:03.0 # Dell PowerEdge R715
>>>>       0a:03.0 VGA compatible controller [0300]: Matrox Electronics Systems Ltd. MGA G200eW WPCM450 [102b:0532] (rev 0a)
>>>>
>>>>       $ lspci -nn -s 09:03.0 # Dell PowerEdge R910
>>>>       09:03.0 VGA compatible controller [0300]: Matrox Electronics Systems Ltd. MGA G200eW WPCM450 [102b:0532] (rev 0a)

Also Dell PowerEdge R815.

[…]

>> I tested Linus’ master with commit 84e57d292203 (Merge tag
>> 'exfat-for-6.2-rc1' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/exfat) and the
>> error is still there. Reverting commit fixes the issue.
>>
>> Tested on:
>>
>>      DMI: Dell Inc. PowerEdge R910/0KYD3D, BIOS 2.10.0 08/29/2013
>>
>> Current master:
>>
>>      [   36.221595] matroxfb 0000:09:03.0: vgaarb: deactivate vga console
>>      [   36.228355] Console: switching to colour dummy device 80x25
>>      [   36.234069] matroxfb: Matrox MGA-G200eW (PCI) detected
>>      [   36.239316] PInS memtype = 7
>>      [   36.242198] matroxfb: cannot determine memory size
>>      [   36.242209] matroxfb: probe of 0000:09:03.0 failed with error -1
>>
>> After reverting 62d89a7d49af (video: fbdev: matroxfb: set maxvram of
>> vbG200eW to the same as vbG200 to avoid black screen):
>>
>>      [   38.140763] matroxfb 0000:09:03.0: vgaarb: deactivate vga console
>>      [   38.148057] Console: switching to colour dummy device 80x25
>>      [   38.153789] matroxfb: Matrox MGA-G200eW (PCI) detected
>>      [   38.159042] PInS memtype = 7
>>      [   38.161953] matroxfb: 640x480x8bpp (virtual: 640x13107)
>>      [   38.167175] matroxfb: framebuffer at 0xC5000000, mapped to 0x000000006f41c38c, size 8388608
>>
>>>> The master commit 62d89a7d49a was added to v5.18-rc1, and was also
>>>> backported to the Linux 5.15 series in 5.15.33.
> 
> Good.
> 
> Could you test if the patch below works for you as well (on top of
> git master) ? I believe the commit f8bf19f7f311 (video: fbdev:
> matroxfb: set maxvram of vbG200eW to the same as vbG200 to avoid
> black screen) changed the wrong value...

> diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/fbdev/matrox/matroxfb_base.c
> index 0d3cee7ae726..5192c7ac459a 100644
> --- a/drivers/video/fbdev/matrox/matroxfb_base.c
> +++ b/drivers/video/fbdev/matrox/matroxfb_base.c
> @@ -1378,8 +1378,8 @@ static struct video_board vbG200 = {
>   	.lowlevel = &matrox_G100
>   };
>   static struct video_board vbG200eW = {
> -	.maxvram = 0x100000,
> -	.maxdisplayable = 0x800000,
> +	.maxvram = 0x800000,
> +	.maxdisplayable = 0x100000,
>   	.accelID = FB_ACCEL_MATROX_MGAG200,
>   	.lowlevel = &matrox_G100
>   };

Thank you. That worked.

     $ dmesg | grep -e matroxfb -e "Linux version" -e "DMI:"
     [    0.000000] Linux version 6.1.0.mx64.440-13147-gfa99506bedb1 
(pmenzel@dontpanic.molgen.mpg.de) (gcc (GCC) 11.1.0, GNU ld (GNU 
Binutils) 2.37) #1 SMP PREEMPT_DYNAMIC Mon Dec 19 12:13:21 CET 2022
     [    0.000000] DMI: Dell Inc. PowerEdge R815/04Y8PT, BIOS 3.4.0 
03/23/2018
     [   29.033666] matroxfb 0000:0a:03.0: vgaarb: deactivate vga console
     [   29.046608] matroxfb: Matrox MGA-G200eW (PCI) detected
     [   29.054769] matroxfb: 640x480x8bpp (virtual: 640x1638)
     [   29.059901] matroxfb: framebuffer at 0xE4000000, mapped to 
0x00000000d36c9776, size 8388608
     [   34.917829] matroxfb: Pixel PLL not locked after 5 secs
     $ lspci -nn -s 0a:03.0
     0a:03.0 VGA compatible controller [0300]: Matrox Electronics 
Systems Ltd. MGA G200eW WPCM450 [102b:0532] (rev 0a)

> If it works, can you send a patch?

Will do. If you have some explanation though, I could add to the commit 
message, that’d be great.


Kind regards,

Paul
