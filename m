Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A18E123771
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbfLQUkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:40:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59376 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726836AbfLQUkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 15:40:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576615199;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=3pm/HT4ZIaGozPB6mMkf61xkwKmu8TGFcOacsu4Vtco=;
        b=YJs1BRPjaHT/VPu9VBO50NnZHc7d80kCQypkUFGGUPAHyOzQ44nS/prmu3+ac45j/5Nv5n
        CwHsO7243HlqIMtyi3HkOFSGjqfuG3WIIKlltVWYbH+ng6h5dufufskBW76b8RMH5VVzr3
        RtmERffkTYMP5qOsD5Dbosuuq0z8TsQ=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-gTSbRlN7MemsHThJsK7u-g-1; Tue, 17 Dec 2019 15:39:57 -0500
X-MC-Unique: gTSbRlN7MemsHThJsK7u-g-1
Received: by mail-yb1-f199.google.com with SMTP id 7so10270324ybc.5
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 12:39:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=3pm/HT4ZIaGozPB6mMkf61xkwKmu8TGFcOacsu4Vtco=;
        b=K/R89NeDrqXjb+w23vRZFufuNjaQDRPqp+zIw/Ja5uxgztlS1G/A3+GNfrXRNMDQcM
         T2OpvVqDpMXhs1hV8Ki8frqu1/IhovzbZYWFiSrUaUi6O8tds1OX4pEze7xC2DCKLK32
         UkJ4OJ1INToh30NyaHJR6pgbUoFq84OUFTerT8TMTtS5Jb5NYQ0/TMAHNWPaX6a0PTxR
         0e+akbcIIpciST6ss+Jd36PNN8GvQxwb2nHD+AqLfJp9YcgQ5VrERdcSC+7NkBVWLFxU
         yb1XeB0jxwT76q1GQnRO3gQI8TMc4bLXbzI0eLsGoc2F12TnH7Q366CgvMu90Y7v1maO
         qqVA==
X-Gm-Message-State: APjAAAXoBa7o8M42y7ikzK/jcb/dXwEKyvkIUPmKKK4UxDWCe6FksXHJ
        SfuiPh7ERQdyoBl7Gcj8Yk4sZ/FLcVl44powgu4m16c9wKsp+OC7IqqmiAdlPDJNsZD86B0Sbi/
        dCjbR9KPmgb/zd0aG
X-Received: by 2002:a81:230a:: with SMTP id j10mr461125ywj.485.1576615196725;
        Tue, 17 Dec 2019 12:39:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqxtU49wyAxi7xKA/49CEmgPcUA8/v4V+raPU1xTW68hh6vfM2yR6HVIizvmuD2T2ghrDKCWpQ==
X-Received: by 2002:a81:230a:: with SMTP id j10mr461105ywj.485.1576615196427;
        Tue, 17 Dec 2019 12:39:56 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id e186sm10201174ywb.73.2019.12.17.12.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 12:39:55 -0800 (PST)
Date:   Tue, 17 Dec 2019 13:39:54 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     iommu@lists.linux-foundation.org, Joerg Roedel <jroedel@suse.de>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org
Subject: Re: [RFC PATCH] iommu/vt-d: avoid panic in __dmar_remove_one_dev_info
Message-ID: <20191217203954.6xfaw5jto75q4nxm@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <jroedel@suse.de>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org
References: <20191217175542.22187-1-jsnitsel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20191217175542.22187-1-jsnitsel@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue Dec 17 19, Jerry Snitselaar wrote:
>In addition to checking for a null pointer, verify that
>info does not have the value DEFER_DEVICE_DOMAIN_INFO or
>DUMMY_DEVICE_DOMAIN_INFO. If info has one of those values
>__dmar_remove_one_dev_info will panic when trying to access
>a member of the device_domain_info struct.
>
>    [    1.464241] BUG: unable to handle kernel NULL pointer dereference at 000000000000004e
>    [    1.464241] PGD 0 P4D 0
>    [    1.464241] Oops: 0000 [#1] SMP PTI
>    [    1.464241] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W        --------- -  - 4.18.0-160.el8.x86_64 #1
>    [    1.464241] Hardware name: HP ProLiant DL360 Gen9/ProLiant DL360 Gen9, BIOS P89 07/21/2019
>    [    1.464241] RIP: 0010:__dmar_remove_one_dev_info+0x27/0x250
>    [    1.464241] Code: 00 00 00 0f 1f 44 00 00 8b 05 35 ec 75 01 41 56 41 55 41 54 55 53 85 c0 0f 84 99 01 00 00 48 85 ff 0f 84 92 01 00 00 48 89 fb <4c> 8b 67 50 48 8b 6f 58 $
>    [    1.464241] RSP: 0000:ffffc900000dfd10 EFLAGS: 00010082
>    [    1.464241] RAX: 0000000000000001 RBX: fffffffffffffffe RCX: 0000000000000000
>    [    1.464241] RDX: 0000000000000001 RSI: 0000000000000004 RDI: fffffffffffffffe
>    [    1.464241] RBP: ffff88ec7a72f368 R08: 0000000000000457 R09: 0000000000000039
>    [    1.464241] R10: 0000000000000000 R11: ffffc900000dfa58 R12: ffff88ec7a0eec20
>    [    1.464241] R13: ffff88ec6fd0eab0 R14: ffffffff81eae980 R15: 0000000000000000
>    [    1.464241] FS:  0000000000000000(0000) GS:ffff88ec7a600000(0000) knlGS:0000000000000000
>    [    1.464241] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    [    1.464241] CR2: 000000000000004e CR3: 0000006c7900a001 C 00000000001606b0
>    [    1.464241] Call Trace:
>    [    1.464241]  dmar_remove_one_dev_info.isra.68+0x27/0x40
>    [    1.464241]  intel_iommu_add_device+0x124/0x180
>    [    1.464241]  ? iommu_probe_device+0x40/0x40
>    [    1.464241]  add_iommu_group+0xa/0x20
>    [    1.464241]  bus_for_each_dev+0x77/0xc0
>    [    1.464241]  ? down_write+0xe/0x40
>    [    1.464241]  bus_set_iommu+0x85/0xc0
>    [    1.464241]  intel_iommu_init+0x4b4/0x777
>    [    1.464241]  ? e820__memblock_setup+0x63/0x63
>    [    1.464241]  ? do_early_param+0x91/0x91
>    [    1.464241]  pci_iommu_init+0x19/0x45
>    [    1.464241]  do_one_initcall+0x46/0x1c3
>    [    1.464241]  ? do_early_param+0x91/0x91
>    [    1.464241]  kernel_init_freeable+0x1af/0x258
>    [    1.464241]  ? rest_init+0xaa/0xaa
>    [    1.464241]  kernel_init+0xa/0x107
>    [    1.464241]  ret_from_fork+0x35/0x40
>    [    1.464241] Modules linked in:
>    [    1.464241] CR2: 000000000000004e
>    [    1.464241] ---[ end trace 0927d2ba8b8032b5 ]---
>
>Cc: Joerg Roedel <jroedel@suse.de>
>Cc: Lu Baolu <baolu.lu@linux.intel.com>
>Cc: David Woodhouse <dwmw2@infradead.org>
>Cc: stable@vger.kernel.org # v5.3+
>Cc: iommu@lists.linux-foundation.org
>Fixes: ae23bfb68f28 ("iommu/vt-d: Detach domain before using a private one")
>Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
>---
> drivers/iommu/intel-iommu.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>index 0c8d81f56a30..e42a09794fa2 100644
>--- a/drivers/iommu/intel-iommu.c
>+++ b/drivers/iommu/intel-iommu.c
>@@ -5163,7 +5163,8 @@ static void dmar_remove_one_dev_info(struct device *dev)
>
> 	spin_lock_irqsave(&device_domain_lock, flags);
> 	info = dev->archdata.iommu;
>-	if (info)
>+	if (info && info != DEFER_DEVICE_DOMAIN_INFO
>+	    && info != DUMMY_DEVICE_DOMAIN_INFO)
> 		__dmar_remove_one_dev_info(info);
> 	spin_unlock_irqrestore(&device_domain_lock, flags);
> }
>-- 
>2.24.0
>
>_______________________________________________
>iommu mailing list
>iommu@lists.linux-foundation.org
>https://lists.linuxfoundation.org/mailman/listinfo/iommu
>

Nack this.

Apparently the issue is just being seen with the kdump kernel.  I'm
wondering if it is already solved by 6c3a44ed3c55 ("iommu/vt-d: Turn
off translations at shutdown").  Testing a 5.5 build now.

