Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B644D6CA978
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 17:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbjC0Pqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 11:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbjC0PqW (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Mar 2023 11:46:22 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE83A55B2;
        Mon, 27 Mar 2023 08:46:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 193A8604F2;
        Mon, 27 Mar 2023 17:46:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1679931971; bh=kB+P1N+4RPMDv1e2HhvD7kV2dHk0AT6TukSryazX3DE=;
        h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
        b=Eyr8b73JusPM6z5Chc9NqqC2+gaiZRscBym0NU2YYx4LW/bO/VrSANSYUsFcCs2J2
         b530fvVDjGZni80EHEziQwO2Civw9b7FIgfiMd1prHjSuBirvi8IQ5H/NVCHgEKEr9
         dVJXEk+jBXsiTdE6BFtjnQU4CPW+rMxNAvHUBi+hbd+m0CCeDq45Dada6x0gxopPYL
         2M2OFHGWj3E91kIU2vuBJM7FT9C/TFCpmc2yUCAw9saY0RkpzIZoToeRQ9PdTrdF+w
         Ec24DljmIIeUV9IcgTthebMzV+X+w9fj3MF664Kgo/NKwmuRgi9zJihyAI+sHdarbK
         w3CMOfDw+vJYw==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cAvTwWYXfs8c; Mon, 27 Mar 2023 17:46:08 +0200 (CEST)
Received: from [192.168.1.3] (unknown [77.237.101.225])
        by domac.alu.hr (Postfix) with ESMTPSA id F2036604EF;
        Mon, 27 Mar 2023 17:46:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1679931968; bh=kB+P1N+4RPMDv1e2HhvD7kV2dHk0AT6TukSryazX3DE=;
        h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
        b=woegmFr6GR0EFaPiZl4H6TkNI3ZKmIIsVgTumO4FTp2vIFJKxtBzX7pezpuTN9h5r
         gEWuyYsSxpPW7sdQliXjbDzp1Mj6cDQqGLczMUSc6rb3De3dXEPvzcXesaYRpKqCT2
         4Wf5WOSnW6FCmyKi7lTHA+xBsmsoTufJZLSYqmWWPgfsID0Vanb7t8+8+VuSeSZvmq
         Bw1d18SH3QJX9MpgZaLfjEg7dwUiCsBbVQbn2P/PtRPPyT3gOgHbvpIq6botcVg/L5
         pBB4SIAB0v9Aa2zYeUi1Qw656a6a3/nDdhv9b2Zin55XHifDo4hEVmdv9qepBJyQKp
         DErLrUWEIsvjg==
Message-ID: <cd5d13c8-10b5-af8f-03b7-2a8e919e058a@alu.unizg.hr>
Date:   Mon, 27 Mar 2023 17:46:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: Re: [PATCH] xhci: Free the command allocated for setting LPM if we
 return early
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ubuntu-devel-discuss@lists.ubuntu.com, stern@rowland.harvard.edu,
        arnd@arndb.de, Stable@vger.kernel.org
References: <b86fcdbd-f1c6-846f-838f-b7679ec4e2b4@linux.intel.com>
 <20230327095019.1017159-1-mathias.nyman@linux.intel.com>
 <ZCGDRrT4Bo3-UYOZ@kroah.com>
 <70474413-fcb0-7527-d7a3-67c3e55d0f1b@linux.intel.com>
Content-Language: en-US, hr
In-Reply-To: <70474413-fcb0-7527-d7a3-67c3e55d0f1b@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27. 03. 2023. 15:31, Mathias Nyman wrote:
> On 27.3.2023 14.51, Greg KH wrote:
>> On Mon, Mar 27, 2023 at 12:50:19PM +0300, Mathias Nyman wrote:
>>> The command allocated to set exit latency LPM values need to be freed in
>>> case the command is never queued. This would be the case if there is no
>>> change in exit latency values, or device is missing.
>>>
>>> Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
>>> Cc: <Stable@vger.kernel.org>
>>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>>> ---
>>>   drivers/usb/host/xhci.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>
>> Do you want me to take this now, or will you be sending this to me in a
>> separate series of xhci fixes?  Either is fine with me.
> 
> I can send a separate series this week, there are some other fixes as well.

Hi, Mathias,

I can confirm from the original setup that triggered the bug:

root@marvin-IdeaPad-3-15ITL6:~# uname -rms
Linux 6.3.0-rc3-kobj-rlse-00317-g65aca32efdcb-dirty x86_64
root@marvin-IdeaPad-3-15ITL6:~# 

The version without the patch still manifests the issue:

root@marvin-IdeaPad-3-15ITL6:/home/marvin# uname -rms
Linux 6.3.0-rc3-kobj-rlse-wop-00317-g65aca32efdcb x86_64
root@marvin-IdeaPad-3-15ITL6:/home/marvin# echo scan > /sys/kernel/debug/kmemleak 
root@marvin-IdeaPad-3-15ITL6:/home/marvin# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff96e59c4e1400 (size 64):
  comm "systemd-udevd", pid 420, jiffies 4294893221 (age 260.340s)
  hex dump (first 32 bytes):
    c0 8b c3 98 e5 96 ff ff 00 00 00 00 00 00 00 00  ................
    60 8c c3 98 e5 96 ff ff 00 00 00 00 00 00 00 00  `...............
  backtrace:
    [<ffffffffacbde94c>] slab_post_alloc_hook+0x8c/0x320
    [<ffffffffacbe5107>] __kmem_cache_alloc_node+0x1c7/0x2b0
    [<ffffffffacb62f3b>] kmalloc_node_trace+0x2b/0xa0
    [<ffffffffad3af2ec>] xhci_alloc_command+0x7c/0x1b0
    [<ffffffffad3af451>] xhci_alloc_command_with_ctx+0x21/0x70
    [<ffffffffad3a8a3e>] xhci_change_max_exit_latency+0x2e/0x1c0
    [<ffffffffad3a8c5b>] xhci_disable_usb3_lpm_timeout+0x7b/0xb0
    [<ffffffffad3457a7>] usb_disable_link_state+0x57/0xe0
    [<ffffffffad345f46>] usb_disable_lpm+0x86/0xc0
    [<ffffffffad345fc1>] usb_unlocked_disable_lpm+0x31/0x60
    [<ffffffffad355db6>] usb_disable_device+0x136/0x250
    [<ffffffffad356b23>] usb_set_configuration+0x583/0xa70
    [<ffffffffad364c6d>] usb_generic_driver_disconnect+0x2d/0x40
    [<ffffffffad358612>] usb_unbind_device+0x32/0x90
    [<ffffffffad222295>] device_remove+0x65/0x70
    [<ffffffffad223903>] device_release_driver_internal+0xc3/0x140
unreferenced object 0xffff96e598c38c60 (size 32):
  comm "systemd-udevd", pid 420, jiffies 4294893221 (age 260.340s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    70 8c c3 98 e5 96 ff ff 70 8c c3 98 e5 96 ff ff  p.......p.......
  backtrace:
    [<ffffffffacbde94c>] slab_post_alloc_hook+0x8c/0x320
    [<ffffffffacbe5107>] __kmem_cache_alloc_node+0x1c7/0x2b0
    [<ffffffffacb62f3b>] kmalloc_node_trace+0x2b/0xa0
    [<ffffffffad3af364>] xhci_alloc_command+0xf4/0x1b0
    [<ffffffffad3af451>] xhci_alloc_command_with_ctx+0x21/0x70
    [<ffffffffad3a8a3e>] xhci_change_max_exit_latency+0x2e/0x1c0
    [<ffffffffad3a8c5b>] xhci_disable_usb3_lpm_timeout+0x7b/0xb0
    [<ffffffffad3457a7>] usb_disable_link_state+0x57/0xe0
    [<ffffffffad345f46>] usb_disable_lpm+0x86/0xc0
    [<ffffffffad345fc1>] usb_unlocked_disable_lpm+0x31/0x60
    [<ffffffffad355db6>] usb_disable_device+0x136/0x250
    [<ffffffffad356b23>] usb_set_configuration+0x583/0xa70
    [<ffffffffad364c6d>] usb_generic_driver_disconnect+0x2d/0x40
    [<ffffffffad358612>] usb_unbind_device+0x32/0x90
    [<ffffffffad222295>] device_remove+0x65/0x70
    [<ffffffffad223903>] device_release_driver_internal+0xc3/0x140
unreferenced object 0xffff96e598c38bc0 (size 32):
  comm "systemd-udevd", pid 420, jiffies 4294893221 (age 260.340s)
  hex dump (first 32 bytes):
    02 00 00 00 20 04 00 00 00 90 79 9c e5 96 ff ff  .... .....y.....
    00 90 79 1c 01 00 00 00 00 00 00 00 00 00 00 00  ..y.............
  backtrace:
    [<ffffffffacbde94c>] slab_post_alloc_hook+0x8c/0x320
    [<ffffffffacbe5107>] __kmem_cache_alloc_node+0x1c7/0x2b0
    [<ffffffffacb62f3b>] kmalloc_node_trace+0x2b/0xa0
    [<ffffffffad3ad86e>] xhci_alloc_container_ctx+0x7e/0x140
    [<ffffffffad3af469>] xhci_alloc_command_with_ctx+0x39/0x70
    [<ffffffffad3a8a3e>] xhci_change_max_exit_latency+0x2e/0x1c0
    [<ffffffffad3a8c5b>] xhci_disable_usb3_lpm_timeout+0x7b/0xb0
    [<ffffffffad3457a7>] usb_disable_link_state+0x57/0xe0
    [<ffffffffad345f46>] usb_disable_lpm+0x86/0xc0
    [<ffffffffad345fc1>] usb_unlocked_disable_lpm+0x31/0x60
    [<ffffffffad355db6>] usb_disable_device+0x136/0x250
    [<ffffffffad356b23>] usb_set_configuration+0x583/0xa70
    [<ffffffffad364c6d>] usb_generic_driver_disconnect+0x2d/0x40
.
.
.

It is completely the same commit save to the difference of applying your patch
kobj-rlse-dirty version and removing it and rebuilding -kobj-rlse-wop- version

Congratulations, for further bisect appears obsoleted.

I haven't been able to iterate the bug, or cause more leaks by unplugging and
plugging in again USB devices, so I cannot estimate severity of this bug, but
I really wouldn't have an idea without bisecting first.

Best regards,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

