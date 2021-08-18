Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1AB3EF8FD
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 06:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbhHREHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 00:07:05 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:45914
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229454AbhHREHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 00:07:05 -0400
Received: from [10.101.195.16] (61-220-137-34.HINET-IP.hinet.net [61.220.137.34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id B54443F105;
        Wed, 18 Aug 2021 04:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629259590;
        bh=ydqTE3cntPwVYCz0tJEj8aq5KjcGxoMf3Zx62OEimdY=;
        h=To:Cc:From:Subject:Message-ID:Date:MIME-Version:Content-Type;
        b=eoJDY4NVAd4XfhIaY0ic0TehMknSJKmolQ4S8fT66pdBDOi+0s9pU3ImH/H8u7XCn
         PVH4Yx9ok/3Pwg+ZmNHWMHh/sZnguM6U18Lds1P3oQBo3HLaIsmsVN9ksqdbTxgVQk
         8GModMGYx7HBBq7ehETGTPDMSi4+dleRQ/vJqbZUs4vszJwYwAKtvI8teSVR0tmRbO
         iPdcDv8nB7W1xvct55jl9QBrqigAwmMZw4S//7KTBIjBBXyD+OEEWRreQ9mLrbQ85r
         dwfbMbJmhWHXZNArL2YfViF2XSwvPyFbnN1ORWysif0/4SG+h4bqn0Ls3zSfhIn3Le
         taE3shjqw751g==
To:     marex@denx.de
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>
From:   Hui Wang <hui.wang@canonical.com>
Subject: the commit c434e5e48dc4 (rsi: Use resume_noirq for SDIO) introduced
 driver crash in the 4.15 kernel
Message-ID: <2b77868b-c1e6-9f30-9640-5c82a82f5b31@canonical.com>
Date:   Wed, 18 Aug 2021 12:06:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marex,

We backported this patch to ubuntu 4.15.0-generic kernel, and found this 
patch introduced the rsi driver crashing when running system resume on 
the Dell 300x IoT platform (100% rate). Below is the log, After seeing 
this log, the rsi wifi can't work anymore, need to run 'rmmod 
rsi_sdio;modprobe rsi_sdio" to make it work again.

So do you know what is missing apart from this patch or this patch is 
not suitable for 4.15 kernel at all?

Thanks,

Hui.


[  118.494238] Freezing user space processes ... (elapsed 0.001 seconds) 
done.
[  118.495866] OOM killer disabled.
[  118.495868] Freezing remaining freezable tasks ... (elapsed 0.001 
seconds) done.
[  118.497772] Suspending console(s) (use no_console_suspend to debug)
[  118.499120] rsi_91x: ===> Interface DOWN <===
[  129.013207] mmc1: Controller never released inhibit bit(s).
[  129.013216] mmc1: sdhci: ============ SDHCI REGISTER DUMP ===========
[  129.013226] mmc1: sdhci: Sys addr:  0xffffffff | Version: 0x0000ffff
[  129.013233] mmc1: sdhci: Blk size:  0x0000ffff | Blk cnt: 0x0000ffff
[  129.013240] mmc1: sdhci: Argument:  0xffffffff | Trn mode: 0x0000ffff
[  129.013247] mmc1: sdhci: Present:   0xffffffff | Host ctl: 0x000000ff
[  129.013254] mmc1: sdhci: Power:     0x000000ff | Blk gap: 0x000000ff
[  129.013261] mmc1: sdhci: Wake-up:   0x000000ff | Clock: 0x0000ffff
[  129.013268] mmc1: sdhci: Timeout:   0x000000ff | Int stat: 0xffffffff
[  129.013276] mmc1: sdhci: Int enab:  0xffffffff | Sig enab: 0xffffffff
[  129.013283] mmc1: sdhci: ACmd stat: 0x0000ffff | Slot int: 0x0000ffff
[  129.013290] mmc1: sdhci: Caps:      0xffffffff | Caps_1: 0xffffffff
[  129.013297] mmc1: sdhci: Cmd:       0x0000ffff | Max curr: 0xffffffff
[  129.013304] mmc1: sdhci: Resp[0]:   0xffffffff | Resp[1]: 0xffffffff
[  129.013311] mmc1: sdhci: Resp[2]:   0xffffffff | Resp[3]: 0xffffffff
[  129.013316] mmc1: sdhci: Host ctl2: 0x0000ffff
[  129.013323] mmc1: sdhci: ADMA Err:  0xffffffff | ADMA Ptr: 0xffffffff
[  129.013327] mmc1: sdhci: ============================================
[  129.113415] mmc1: Reset 0x2 never completed.
[  129.113417] mmc1: sdhci: ============ SDHCI REGISTER DUMP ===========
[  129.113421] mmc1: sdhci: Sys addr:  0xffffffff | Version: 0x0000ffff
[  129.113424] mmc1: sdhci: Blk size:  0x0000ffff | Blk cnt: 0x0000ffff
[  129.113428] mmc1: sdhci: Argument:  0xffffffff | Trn mode: 0x0000ffff
[  129.113431] mmc1: sdhci: Present:   0xffffffff | Host ctl: 0x000000ff
[  129.113435] mmc1: sdhci: Power:     0x000000ff | Blk gap: 0x000000ff
[  129.113439] mmc1: sdhci: Wake-up:   0x000000ff | Clock: 0x0000ffff
[  129.113442] mmc1: sdhci: Timeout:   0x000000ff | Int stat: 0xffffffff
[  129.113446] mmc1: sdhci: Int enab:  0xffffffff | Sig enab: 0xffffffff
[  129.113449] mmc1: sdhci: ACmd stat: 0x0000ffff | Slot int: 0x0000ffff
[  129.113453] mmc1: sdhci: Caps:      0xffffffff | Caps_1: 0xffffffff
[  129.113457] mmc1: sdhci: Cmd:       0x0000ffff | Max curr: 0xffffffff
[  129.113460] mmc1: sdhci: Resp[0]:   0xffffffff | Resp[1]: 0xffffffff
[  129.113464] mmc1: sdhci: Resp[2]:   0xffffffff | Resp[3]: 0xffffffff
[  129.113466] mmc1: sdhci: Host ctl2: 0x0000ffff
[  129.113470] mmc1: sdhci: ADMA Err:  0xffffffff | ADMA Ptr: 0xffffffff
[  129.113472] mmc1: sdhci: ============================================
[  129.213489] mmc1: Reset 0x4 never completed.
[  129.213490] mmc1: sdhci: ============ SDHCI REGISTER DUMP ===========
[  129.213494] mmc1: sdhci: Sys addr:  0xffffffff | Version: 0x0000ffff
[  129.213498] mmc1: sdhci: Blk size:  0x0000ffff | Blk cnt: 0x0000ffff
[  129.213501] mmc1: sdhci: Argument:  0xffffffff | Trn mode: 0x0000ffff
[  129.213505] mmc1: sdhci: Present:   0xffffffff | Host ctl: 0x000000ff
[  129.213508] mmc1: sdhci: Power:     0x000000ff | Blk gap: 0x000000ff
[  129.213512] mmc1: sdhci: Wake-up:   0x000000ff | Clock: 0x0000ffff
[  129.213515] mmc1: sdhci: Timeout:   0x000000ff | Int stat: 0xffffffff
[  129.213519] mmc1: sdhci: Int enab:  0xffffffff | Sig enab: 0xffffffff
[  129.213523] mmc1: sdhci: ACmd stat: 0x0000ffff | Slot int: 0x0000ffff
[  129.213526] mmc1: sdhci: Caps:      0xffffffff | Caps_1: 0xffffffff
[  129.213530] mmc1: sdhci: Cmd:       0x0000ffff | Max curr: 0xffffffff
[  129.213534] mmc1: sdhci: Resp[0]:   0xffffffff | Resp[1]: 0xffffffff
[  129.213537] mmc1: sdhci: Resp[2]:   0xffffffff | Resp[3]: 0xffffffff
[  129.213540] mmc1: sdhci: Host ctl2: 0x0000ffff
[  129.213543] mmc1: sdhci: ADMA Err:  0xffffffff | ADMA Ptr: 0xffffffff
[  129.213545] mmc1: sdhci: ============================================
[  129.213882] rsi_91x: rsi_sdio_enable_interrupts: Failed to read int 
enable register
[  129.240392] rsi_91x: ===> Interface UP <===
[  129.240443] rsi_91x: rsi_disable_ps: Cannot accept disable PS in 
PS_NONE state

