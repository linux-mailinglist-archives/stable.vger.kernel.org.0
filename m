Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 611001A0702
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 08:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgDGGJj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 Apr 2020 02:09:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34664 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgDGGJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 02:09:39 -0400
Received: from mail-pl1-f197.google.com ([209.85.214.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jLhQX-0005eo-Hx
        for stable@vger.kernel.org; Tue, 07 Apr 2020 06:09:37 +0000
Received: by mail-pl1-f197.google.com with SMTP id k10so1602496plx.17
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 23:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UZI8JedmnuHToXu7Q/I7xx7S7a3ItUDjPQAoytpljgU=;
        b=kq+rCDr9rJEWLu6r7Xg8GaSIxSdhfnzFfxt8hvDELY3SPUdBRMa0OwV9tql1U/pvAQ
         XrlaSwP9s3M6G7NFquR+JC7gwsczMXxYD69Yr8L+n6s8GphNFGIlZHGJzqSEGv3HiVtn
         W0K1YSaYd+9o2mFKI/nClGUtzwD9HBzFdHwcG3qRKxpaLSMqRZWcdVBqWroit4sCIMFc
         w8g8ibA2aof8bPGhOMA1wFC+Xzcg4blPpdJ7noY/kum2/ebg2Vh0/PZnqFRy8FJ9CQNM
         OBe7aaacuv5TorHhaC0iPz0dRzbpZxw9OzXPzamiUeXfFyiKijlgEu7Gra5uF0l6khIq
         zKxw==
X-Gm-Message-State: AGi0PuZCJANhS+QB/lSV8P2oXz3w1ysdhMxhAiAX06J5kRTcUdB6pVjT
        kRXjXX3frqyJ5jPsQCNvc2VIZ5pNvNPp9qprRQ6y1YepAxB2mD37m9eES0UDU3DZ5OWhJwsyS1S
        eMtj5YcjOJKTZUTXfdftxcG6Xwlsx4Vg/4w==
X-Received: by 2002:aa7:98c9:: with SMTP id e9mr1038784pfm.204.1586239775968;
        Mon, 06 Apr 2020 23:09:35 -0700 (PDT)
X-Google-Smtp-Source: APiQypLoN6nnx4YD3X7VJk9A66/0ZEp9elDgbImAvoNuoS7c7bQNoEObS/YpnSfIY6drzOS7Fwmadw==
X-Received: by 2002:aa7:98c9:: with SMTP id e9mr1038773pfm.204.1586239775668;
        Mon, 06 Apr 2020 23:09:35 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id o128sm12965746pfb.58.2020.04.06.23.09.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Apr 2020 23:09:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] libata: Return correct rc status in
 sata_pmp_eh_recover_pm() pwhen ATA_DFLAG_DETACH is set
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20190327090254.10365-1-kai.heng.feng@canonical.com>
Date:   Tue, 7 Apr 2020 14:09:33 +0800
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A7C20983-8C32-4B63-AAEB-BFA2AE0DBAE9@canonical.com>
References: <20190327090254.10365-1-kai.heng.feng@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens,

> On Mar 27, 2019, at 17:02, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
> 
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
> 
> BugLink: https://bugs.launchpad.net/bugs/1821434
> Cc: stable@vger.kernel.org
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Any suggestion for this patch?

Kai-Heng

> ---
> drivers/ata/libata-pmp.c | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
> index 2ae1799f4992..51eeaea65833 100644
> --- a/drivers/ata/libata-pmp.c
> +++ b/drivers/ata/libata-pmp.c
> @@ -764,6 +764,7 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
> 
> 	if (dev->flags & ATA_DFLAG_DETACH) {
> 		detach = 1;
> +		rc = -ENODEV;
> 		goto fail;
> 	}
> 
> -- 
> 2.17.1
> 

