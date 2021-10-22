Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F45A4375C6
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 12:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhJVLBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 07:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbhJVLBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 07:01:47 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F686C061764;
        Fri, 22 Oct 2021 03:59:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x1-20020a17090a530100b001a1efa4ebe6so848832pjh.0;
        Fri, 22 Oct 2021 03:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HxstPaetl8rP5oCfye3Ujb/1cT4KWfz9LWxw06LelaQ=;
        b=dWlNOlqyS+Rhvv4mfTJEy2Epj4DoVTj3CWl3zmAFJk0avK7ubYcv7Zb5wzlNUEqt5W
         +aAiQERWMNcUepJF4WuUs3JKkSsw/L2RWBE/SC3l9bhOwu1JQd74fEA1EZL3GKIzKc8I
         G7Yf9wWVnQvGamTTRAFTs80mD+r/TE2bzjMB/8ygEksutOVCQfIDCxRzkEPBe6UkzEwp
         GHY7Cw5xOlyr7Epv8s90OBE+mUkauacgE3VIg0Lx/x9mTU49DWsuE3dA/GmpGLiZDm8s
         XWikgRMnsYWvXGrprUpeuQSafjUXpVCtgokPYtktV20XBJ3Tbx04rj5bySl5dtrWH0qI
         rZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HxstPaetl8rP5oCfye3Ujb/1cT4KWfz9LWxw06LelaQ=;
        b=gjxzIp1ySAL0/uN/Rltsx7Vr3AxlFikEsZZoTzyOjXbmYJTajH2EtBOKdU4F8LWbH7
         iy7wVb7n66XkyVwqUS2M+GZljyysInTbPFVdlcVDI+LPsr1So93/5hE33yoq+SgE0qWD
         Pq9GBkjIyw+R+9IWC5nCSv81m6tF7Su/ERpEEJIPExxNxYynHuLncBrPwiP903/iTH84
         A5922z+YbRzOeayuDbKLdyG69mRv3CtaWqJSJPBituhrkAvMYcBOOaROO4s8OIOuDhdd
         +7qnoU0OZiTpNU9r0mnEqdeSWAimJts/Vzto8mTID4xJzKhz94S3ueJBsw3inl29Ybdn
         viIw==
X-Gm-Message-State: AOAM531kFPnR9UIju8EzXlk7K0XA81NW/4BnlXzt2p72h5nU7+M9w0+6
        jNx+5Ob9NaTSyCBxbWg2mq8=
X-Google-Smtp-Source: ABdhPJxdD4kzU6GAjxJ0KgL/0i9EVU1q9/rKY61XWtMbcmHYXaXh7R5doYMCsQVKp7EOumwNgpel9Q==
X-Received: by 2002:a17:90b:3852:: with SMTP id nl18mr13752647pjb.9.1634900370015;
        Fri, 22 Oct 2021 03:59:30 -0700 (PDT)
Received: from localhost.localdomain ([193.118.60.165])
        by smtp.gmail.com with ESMTPSA id p14sm3787964pjk.47.2021.10.22.03.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 03:59:29 -0700 (PDT)
From:   youling257 <youling257@gmail.com>
To:     mathias.nyman@linux.intel.com
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        pkondeti@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH 4/5] xhci: Fix command ring pointer corruption while aborting a command
Date:   Fri, 22 Oct 2021 18:59:13 +0800
Message-Id: <20211022105913.7671-1-youling257@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008092547.3996295-5-mathias.nyman@linux.intel.com>
References: <20211008092547.3996295-5-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch cause suspend to disk resume usb not work, xhci_hcd 0000:00:14.0: Abort failed to stop command ring: -110.

[  189.292054] PM: hibernation: hibernation entry
[  189.295273] Filesystems sync: 0.000 seconds
[  189.295281] Freezing user space processes ... (elapsed 0.003 seconds) done.
[  189.298514] OOM killer disabled.
[  189.298590] PM: hibernation: Marking nosave pages: [mem 0x00000000-0x00000fff]
[  189.298594] PM: hibernation: Marking nosave pages: [mem 0x00058000-0x00058fff]
[  189.298596] PM: hibernation: Marking nosave pages: [mem 0x0009f000-0x000fffff]
[  189.298600] PM: hibernation: Marking nosave pages: [mem 0x00500000-0x005fffff]
[  189.298607] PM: hibernation: Marking nosave pages: [mem 0x850d7000-0x850d8fff]
[  189.298609] PM: hibernation: Marking nosave pages: [mem 0x8805d000-0x8809bfff]
[  189.298612] PM: hibernation: Marking nosave pages: [mem 0x8ac24000-0x8ac24fff]
[  189.298614] PM: hibernation: Marking nosave pages: [mem 0x8bea8000-0x8caeefff]
[  189.298689] PM: hibernation: Marking nosave pages: [mem 0x8cb9a000-0x8d3fefff]
[  189.298741] PM: hibernation: Marking nosave pages: [mem 0x8d400000-0xffffffff]
[  189.300918] PM: hibernation: Basic memory bitmaps created
[  189.301088] PM: hibernation: Preallocating image memory
[  189.812115] PM: hibernation: Allocated 779311 pages for snapshot
[  189.812118] PM: hibernation: Allocated 3117244 kbytes in 0.51 seconds (6112.24 MB/s)
[  189.812121] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  189.813884] printk: Suspending console(s) (use no_console_suspend to debug)
[  189.814016] wlan0: deauthenticating from b4:a8:98:22:f9:ac by local choice (Reason: 3=DEAUTH_LEAVING)
[  189.814310] rtc_cmos 00:05: suspend, ctrl 02
[  189.844670] r8169 0000:01:00.0 eth0: Link is Down
[  190.081522] ACPI: PM: Preparing to enter system sleep state S4
[  190.083051] ACPI: PM: Saving platform NVS memory
[  190.087556] Disabling non-boot CPUs ...
[  190.089802] smpboot: CPU 1 is now offline
[  190.092841] smpboot: CPU 2 is now offline
[  190.095235] smpboot: CPU 3 is now offline
[  190.098592] smpboot: CPU 4 is now offline
[  190.100660] smpboot: CPU 5 is now offline
[  190.102967] smpboot: CPU 6 is now offline
[  190.105047] smpboot: CPU 7 is now offline
[  190.106828] PM: hibernation: Creating image:
[  190.211897] PM: hibernation: Need to copy 775681 pages
[  190.211898] PM: hibernation: Normal pages needed: 775681 + 1024, available pages: 1300224
[  190.107012] ACPI: PM: Restoring platform NVS memory
[  190.108184] Enabling non-boot CPUs ...
[  190.108225] x86: Booting SMP configuration:
[  190.108225] smpboot: Booting Node 0 Processor 1 APIC 0x2
[  190.109416] CPU1 is up
[  190.109440] smpboot: Booting Node 0 Processor 2 APIC 0x4
[  190.110088] CPU2 is up
[  190.110111] smpboot: Booting Node 0 Processor 3 APIC 0x6
[  190.110775] CPU3 is up
[  190.110799] smpboot: Booting Node 0 Processor 4 APIC 0x1
[  190.111532] CPU4 is up
[  190.111558] smpboot: Booting Node 0 Processor 5 APIC 0x3
[  190.112280] CPU5 is up
[  190.112303] smpboot: Booting Node 0 Processor 6 APIC 0x5
[  190.113056] CPU6 is up
[  190.113084] smpboot: Booting Node 0 Processor 7 APIC 0x7
[  190.113886] CPU7 is up
[  190.116276] ACPI: PM: Waking up from system sleep state S4
[  190.187264] usb usb1: root hub lost power or was reset
[  190.187296] usb usb2: root hub lost power or was reset
[  190.188384] rtc_cmos 00:05: resume, ctrl 02
[  190.189946] i915 0000:00:02.0: [drm] [ENCODER:94:DDI B/PHY B] is disabled/in DSI mode with an ungated DDI clock, gate it
[  190.195185] nvme nvme0: 8/0/0 default/read/poll queues
[  190.354168] r8169 0000:01:00.0 eth0: Link is Down
[  190.526336] ata3: SATA link down (SStatus 4 SControl 300)
[  190.526389] ata4: SATA link down (SStatus 4 SControl 300)
[  191.214037] snd_hda_intel 0000:00:1f.3: azx_get_response timeout, switching to polling mode: last cmd=0x206f0015
[  191.214047] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, last cmd=0x206f0015
[  191.214054] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, last cmd=0x206f0015
[  191.214058] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, last cmd=0x206f0015
[  191.214061] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, last cmd=0x206f0015
[  191.214064] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, last cmd=0x206f0015
[  191.214067] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, last cmd=0x206f0015
[  191.214070] snd_hda_intel 0000:00:1f.3: spurious response 0x200:0x2, last cmd=0x206f0015
[  191.214073] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, last cmd=0x206f0015
[  191.214076] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, last cmd=0x206f0015
[  191.214079] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, last cmd=0x206f0015
[  192.216095] snd_hda_intel 0000:00:1f.3: No response from codec, disabling MSI: last cmd=0x20670100
[  193.218095] snd_hda_intel 0000:00:1f.3: azx_get_response timeout, switching to single_cmd mode: last cmd=0x20670100
[  193.547924] r8169 0000:01:00.0 eth0: Link is Up - 1Gbps/Full - flow control off
[  200.640141] xhci_hcd 0000:00:14.0: Abort failed to stop command ring: -110
[  200.640148] xhci_hcd 0000:00:14.0: xHCI host controller not responding, assume dead
[  200.640151] xhci_hcd 0000:00:14.0: HC died; cleaning up
[  200.640165] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[  201.056143] usb 2-1: device not accepting address 2, error -22
[  201.058193] PM: hibernation: Basic memory bitmaps freed
[  201.058197] OOM killer enabled.
[  201.058197] Restarting tasks ...
[  201.058212] usb 2-1: USB disconnect, device number 2
