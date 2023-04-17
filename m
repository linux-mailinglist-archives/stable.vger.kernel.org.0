Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D61A6E45E7
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 12:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjDQK7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 06:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjDQK7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 06:59:05 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5B865AF;
        Mon, 17 Apr 2023 03:58:10 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1poMWm-0003ND-Ls; Mon, 17 Apr 2023 12:56:08 +0200
Message-ID: <df216da9-cbcb-4579-3e09-ac444dd805d1@leemhuis.info>
Date:   Mon, 17 Apr 2023 12:56:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [REGRESSION] Asus X541UAK hangs on suspend and poweroff (v6.1.6
 onward)
Content-Language: en-US, de-DE
To:     Acid Bong <acidbong@tilde.cafe>
Cc:     bagasdotme@gmail.com, linux-acpi@vger.kernel.org,
        regressions@lists.linux.dev, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
References: <CRYTB8JBZ2LK.BAFK0AHDHPNA@bong>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <CRYTB8JBZ2LK.BAFK0AHDHPNA@bong>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681729090;57b0526b;
X-HE-SMSGID: 1poMWm-0003ND-Ls
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.04.23 09:37, Acid Bong wrote:
> So, I followed your advice and used the sources (6.3-rc6). Compiled even
> two versions: with my config (cf. head letter) and the Arch Linux one
> (I'm using Gentoo, but it still fits well), both updated with
> `olddefconfig`. Just to make sure that the problem is independent from
> the config.
> 
> Good news: I experienced the hanging 3 times with both kernels
> yesterday.
> 
> Two of them were on the custom kernel, and they were of the rare kind -
> they occured on shutdown. It goes normally, init disables the services,
> unmounts the filesystems, turns off the screen, but then - no response
> and the LED and the fan are still on. Another couple of shutdowns went
> normal, so the issue it still irregular.
> 
> One happened later on the Arch-based one and after a suspend.
> 
> /var/log/kern.log showed nothing specific in all cases.
> 
> Bad news: it seems, the fix hasn't arrived yet.
> 
> How do I proceed next?

Ideally you should still try to bisect this to find the change that
causes your problems.

But I'm CCing the ACPI and PCI maintainers nevertheless, now that it's
clear that it happens in vanilla mainline, too. *If* you are lucky they
have an idea what might be wrong and can point you in a direction to
narrow the cause down. But if you are unlucky, they will have no idea
and just ignore this until you bisect the problem.

FWIW, Rafael, Bjorn thread starts here:
https://lore.kernel.org/all/CRVU11I7JJWF.367PSO4YAQQEI@bong/

To quote some parts of it
```
Sometimes when I suspend (by closing the lid, less often - by pressing
Fn+F1 (sleep key combo)) or poweroff my laptop (both by pressing powerit
button and running "loginctl poweroff"), it goes in such a state when it
doesn't respond to opening/closing the lid, power button nor
Ctrl+Alt+Del, but, unlike in sleep mode, the fan is rotating and the
"awake status" LED is on.
[...]
The issue appeared when I was using pf-kernel with genpatches and
updated from 6.1-pf2 to 6.1-pf3 (corresponding to vanilla versions 6.1.3
-> 6.1.6). I used that fork until 6.2-pf2, but since then (early March)
moved to vanilla sources and started following the 6.1.y branch when it
was declared LTS. And the issue was present on all of them.
```

> P.S. On the `pci=nomsi` case: I don't consider it being related to the
> issue we're discussing. For me it seems like a hardware issue that can
> be bypassed by reconfiguration.

I wouldn't be so sure about that.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
