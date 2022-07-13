Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB83A573ACC
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 18:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiGMQGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 12:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiGMQGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 12:06:43 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E27D99;
        Wed, 13 Jul 2022 09:06:42 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 70so10641593pfx.1;
        Wed, 13 Jul 2022 09:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JimlERLsMqT2Nz9D7lFX5LO4ZwAh+FG1kON4oOM8cGs=;
        b=k9iKibiGCQuD2zEA86fVvLcPdZeaZhbMm30uCS5qrDfJKrxGvMrCunxhZ64YlBnGiU
         Bjt4T23URvFHJc0j40lV20oEN5RSqLrZE9nrmCIXF2h2poMxlURZKOsQSdr3Mk7SyoKn
         DmZkvFyCv+4Tg7L9spBd3/BqtzBG1mYLWFxJgXYhAf2uRfhKIZAcfnB10yDBVoRXwKee
         GAuHHwGMV/fThFhz8upRxub53/LM4KFyiBERF7vTl8G5u804zDJ51EAKJP051p9gOaz+
         3+5RmozlrJ2xgwKe8mPZXQMJVGjKAquTjF7RcYc70As4sDLgJhPRhImKxCKNH7auSCsb
         vsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=JimlERLsMqT2Nz9D7lFX5LO4ZwAh+FG1kON4oOM8cGs=;
        b=ckud+XQ2nV/HEjtKwCHN2Zx8mzCqwECzlAQjQmMAg4pTza1kFlgY1sG/RmzSNT6skI
         STGnU/7Kg2JAft9Q0vNyR/P7ngbeGoJHDkD35ty5ZMwsYy3sOI6EALEXlA4lgR0AoDmp
         jYUsqvhOzNjvhsHupHK6FCtGlL+Rjau26Rlf9Z0F9xZm7N+KmzSnGz/ohkb2T/7bJt7t
         LieP6oyOzRhB/MQdbSiUoOgHYvKRLCDB4WOXW6GGgOa187B4MSVBb8a+UHBYzCbY1YAP
         d6ohFC7zbnj56TvOyhESWx9+hvfnLQxYPKIXs3mm6oeBe9foT1ET///vgjYdX/PZnv1V
         BOJA==
X-Gm-Message-State: AJIora/PxvgnEf/wUXnmSFyNZyvQOOKa7ZoeYl+u5Xc2LR22l8YxXFID
        rARbVXU9C0koTZp5Fcct1Y8=
X-Google-Smtp-Source: AGRyM1sxWxwNAU9KCujOdPjh/B4ozr+yo25FEIDSupXBxRp4hR/L9lq5BXxxDl91BbftNP1WRz0aXA==
X-Received: by 2002:a65:6786:0:b0:415:c67a:49a9 with SMTP id e6-20020a656786000000b00415c67a49a9mr3524413pgr.395.1657728402380;
        Wed, 13 Jul 2022 09:06:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a205-20020a621ad6000000b00528bc6d8939sm9039761pfa.157.2022.07.13.09.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 09:06:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 13 Jul 2022 09:06:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/131] 5.10.131-rc2 review
Message-ID: <20220713160639.GB2194204@roeck-us.net>
References: <20220713094820.698453505@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713094820.698453505@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 03:10:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.131 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 Jul 2022 09:47:55 +0000.
> Anything received after that time might be too late.
> 

All boots with efi32 bios crash. This seems to affect all stable release
candidates; so far I have seen it with v5.10.130-132-g6729599d99f and with
v5.18.11-62-g18f94637a014. Test results from mainline and from v5.15.54-rc1
are still pending.

[    0.709966] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    0.709966] BUG: unable to handle page fault for address: 0000000021803b80
[    0.709966] #PF: supervisor instruction fetch in kernel mode
[    0.709966] #PF: error_code(0x0011) - permissions violation
[    0.709966] PGD 175a063 P4D 175a063 PUD 175b063 PMD 1766063 PTE 8000000021803063
[    0.709966] Oops: 0011 [#1] SMP PTI
[    0.709966] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.131-rc2+ #1
[    0.709966] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    0.709966] RIP: 0010:0x21803b80
[    0.709966] Code: Unable to access opcode bytes at RIP 0x21803b56.
[    0.709966] RSP: 0018:ffffffffb9403e80 EFLAGS: 00000046
[    0.709966] RAX: 0000000000000000 RBX: 0000000001798000 RCX: 00000000df24be60
[    0.709966] RDX: 000000003feab058 RSI: 0000000000000600 RDI: 000000003fe7e038
[    0.709966] RBP: 0000000000000600 R08: 0000000001798000 R09: 00000000229ed067
[    0.709966] R10: 0000000000000000 R11: 00000000229ed067 R12: 0000000000000030
[    0.709966] R13: 0000000000000001 R14: ffff9aca41790000 R15: 0000000000000282
[    0.709966] FS:  0000000000000000(0000) GS:ffff9aca7f800000(0000) knlGS:0000000000000000
[    0.709966] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
[    0.709966] CR2: 0000000021803b80 CR3: 0000000001758000 CR4: 00000000000406b0
[    0.709966] Call Trace:
[    0.709966]  ? efi_set_virtual_address_map+0x87/0x160
[    0.709966]  ? efi_enter_virtual_mode+0x39a/0x3f5
[    0.709966]  ? start_kernel+0x4aa/0x544
[    0.709966]  ? secondary_startup_64_no_verify+0xc2/0xcb
[    0.709966] Modules linked in:
[    0.709966] CR2: 0000000021803b80
[    0.709966] ---[ end trace 1b5f45b6ffd42130 ]---
[    0.709966] RIP: 0010:0x21803b80
[    0.709966] Code: Unable to access opcode bytes at RIP 0x21803b56.
[    0.709966] RSP: 0018:ffffffffb9403e80 EFLAGS: 00000046
[    0.709966] RAX: 0000000000000000 RBX: 0000000001798000 RCX: 00000000df24be60
[    0.709966] RDX: 000000003feab058 RSI: 0000000000000600 RDI: 000000003fe7e038
[    0.709966] RBP: 0000000000000600 R08: 0000000001798000 R09: 00000000229ed067
[    0.709966] R10: 0000000000000000 R11: 00000000229ed067 R12: 0000000000000030
[    0.709966] R13: 0000000000000001 R14: ffff9aca41790000 R15: 0000000000000282
[    0.709966] FS:  0000000000000000(0000) GS:ffff9aca7f800000(0000) knlGS:0000000000000000
[    0.709966] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
[    0.709966] CR2: 0000000021803b80 CR3: 0000000001758000 CR4: 00000000000406b0
[    0.709966] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.709966] ACPI MEMORY or I/O RESET_REG.

Guenter
