Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD621A16F1
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 22:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgDGUpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 16:45:51 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44601 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgDGUpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 16:45:50 -0400
Received: by mail-pf1-f196.google.com with SMTP id b72so1335077pfb.11
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 13:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C88lZVacgBqVCx9fOOndyOqopaXcP4IkqPpQrquRUaE=;
        b=E7ztmKn5DIinrdB65ZxtV9BqWJ96hvR4RnwLJ3pVLBFcHhQYwlx8ErU4p03tVhzuaZ
         mdzMScU20+5lCgnkECaEDZoSUPr46fINUyYVMXHYw+gzhMFhs2nMHrPaJNk4SbOQ1DFW
         sfu63JKBWizzPmXipte4ZTNfEOS7OPwv2Gno42KUWG/Lq3j761JETDAOx9bINurCkeXk
         d8mMjHieRX8LdgfobuyIxxoJhz7/TUjN1qjjgBKjXWvyJDMOM/uiKgVwPLGoZdVtlQke
         s9akxu+THvX2r7Q9lAhX8wI5CB2h4NOiecnmknGZbxGZNKKci7BcOnN+ryuwrD1LFWg9
         qZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C88lZVacgBqVCx9fOOndyOqopaXcP4IkqPpQrquRUaE=;
        b=SD5A7J/K8F6MeQId/MfdixcmfLWICAGPAfIqVs6YFzRdKxlPlDf66+LguClQTkRvmr
         5Mwu6J02ZRoH1M4fM7zu+1fPn+GWxaADPXfTYp9G/+tbWzTP9NhwTyfUYSlBPfjiIg/P
         1Lfie0Lugv9dO74XP1FeJWsbCVvy/3BegIlmZA20DYTsLqxQsOKGco8WVOLxeOZjYcsQ
         852zyyCZR1FFzPhixy+dQne9X/vfVQsCmlNUYv9ndqCCKDRUfN3mVrIzMCQrrbrOYbs9
         SfTSSA48HhrvesJBVCtEXKXE/rHXvIHpf8fx0lnpE6hINu+kTCLhazbBpV74HVEqik2O
         Ewzw==
X-Gm-Message-State: AGi0PubmEL+Eif/HfflF0nY0AwOJ/mSfOuAc2N2FZh7Cy7BDKax8hpw9
        y55MzzFpFpe8N81oE7rytGRXECvs1Uqg4A==
X-Google-Smtp-Source: APiQypImd7G6uhM36TiwPi1QL4r5mkuVWEgspW/FrthCdBwyFXKd9TRK8OWmMMLjrbizn6oSgnCKgg==
X-Received: by 2002:a63:5c01:: with SMTP id q1mr3627155pgb.177.1586292347981;
        Tue, 07 Apr 2020 13:45:47 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab? ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id t1sm2419726pjf.26.2020.04.07.13.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 13:45:47 -0700 (PDT)
Subject: Re: [PATCH] libata: Return correct rc status in
 sata_pmp_eh_recover_pm() pwhen ATA_DFLAG_DETACH is set
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190327090254.10365-1-kai.heng.feng@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fad442bc-792e-5e6b-4c8c-db932eec3c96@kernel.dk>
Date:   Tue, 7 Apr 2020 13:45:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20190327090254.10365-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/27/19 2:02 AM, Kai-Heng Feng wrote:
> During system resume from suspend, this can be observed on ASM1062 PMP
> controller:
> <6>[12007.593358] ata10.01: SATA link down (SStatus 0 SControl 330)
> <6>[12007.593469] ata10.02: hard resetting link
> <6>[12007.908353] ata10.02: SATA link down (SStatus 0 SControl 330)
> <6>[12007.911149] ata10.00: configured for UDMA/133
> <0>[12007.972508] Kernel panic - not syncing: stack-protector: Kernel
> stack is corrupted in: sata_pmp_eh_recover+0xa2b/0xa40
> <0>[12007.972508]
> <4>[12007.972515] CPU: 2 PID: 230 Comm: scsi_eh_9 Tainted: P OE
> 4.15.0-46-generic #49-Ubuntu
> <4>[12007.972517] Hardware name: System manufacturer System Product
> Name/A320M-C, BIOS 1001 12/10/2017
> <4>[12007.972518] Call Trace:
> <4>[12007.972525] dump_stack+0x63/0x8b
> <4>[12007.972530] panic+0xe4/0x244
> <4>[12007.972533] ? sata_pmp_eh_recover+0xa2b/0xa40
> <4>[12007.972536] __stack_chk_fail+0x19/0x20
> <4>[12007.972538] sata_pmp_eh_recover+0xa2b/0xa40
> <4>[12007.972543] ? ahci_do_softreset+0x260/0x260 [libahci]
> <4>[12007.972545] ? ahci_do_hardreset+0x140/0x140 [libahci]
> <4>[12007.972547] ? ata_phys_link_offline+0x60/0x60
> <4>[12007.972549] ? ahci_stop_engine+0xc0/0xc0 [libahci]
> <4>[12007.972552] sata_pmp_error_handler+0x22/0x30
> <4>[12007.972554] ahci_error_handler+0x45/0x80 [libahci]
> <4>[12007.972556] ata_scsi_port_error_handler+0x29b/0x770
> <4>[12007.972558] ? ata_scsi_cmd_error_handler+0x101/0x140
> <4>[12007.972559] ata_scsi_error+0x95/0xd0
> <4>[12007.972562] ? scsi_try_target_reset+0x90/0x90
> <4>[12007.972563] scsi_error_handler+0xd0/0x5b0
> <4>[12007.972566] kthread+0x121/0x140
> <4>[12007.972567] ? scsi_eh_get_sense+0x200/0x200
> <4>[12007.972569] ? kthread_create_worker_on_cpu+0x70/0x70
> <4>[12007.972572] ret_from_fork+0x22/0x40
> <0>[12007.972591] Kernel Offset: 0xcc00000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> 
> Since sata_pmp_eh_recover_pmp() doens't set rc when ATA_DFLAG_DETACH is
> set, sata_pmp_eh_recover() continues to run. During retry it triggers
> the stack protector.
> 
> Set correct rc in sata_pmp_eh_recover_pmp() to let sata_pmp_eh_recover()
> jump to pmp_fail directly.

Applied, with the commit message and title fixed up a bit.

-- 
Jens Axboe

