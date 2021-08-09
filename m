Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283B23E4FFF
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 01:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhHIXbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 19:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhHIXbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 19:31:20 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6B5C0613D3;
        Mon,  9 Aug 2021 16:30:59 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso1253608pjb.1;
        Mon, 09 Aug 2021 16:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dd77W/KdeOM9nG8N1j3qwDuFZ1a4i1+lpHneiX4PFBQ=;
        b=ZjzFDsu1U54J10WducqkKlbv0YSaNe9G7InZWfzrFx2SDdCbSUxRWh+UwOuuc/mlNd
         A4IEOXnA5+MA0H0HDvrg1DEvKa1WvsjYE1S9I4s1qKCQOAqvq8v8xaFlHfbbAvu8r6cb
         03sNp9yDJDdz70JArCBPd7HxuvmF52ZA5QVKBjN2W26RopXJkOB5aPf+JcBLDdAwRSpN
         n/dSIoiCh/boJRdge3wyoMGdgJG8MzJpYVU9guN/5WpuzkMZIxWiGBb0RV9IWUr/V1pz
         2OmrGUZGFl7g1cUO3PMv8ZkGG7rV5wl4Zlb60YrBPIWmoDORbPFTdhN/RkKZzVoX5oU9
         vpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dd77W/KdeOM9nG8N1j3qwDuFZ1a4i1+lpHneiX4PFBQ=;
        b=qNRT83zfX5mdorLD1H4/bhDP75sbFfcCbgt4/R6Y40161xijGwiZcEhxaW0YtO/Flz
         2ApGFDosx0pDBlEfJxbzXbFduqxZkiKHSQI5PIwEojAOgW2HkDxpyvk+fcCBccCmbOQL
         XKB8BLSmoeicW6Cu2/GPkXvp+1elsgCVem+X9HiaerVZCteKaHnAagAS0xn3FGYXL4LT
         36qj+GLyNibvuMuV16ePUVbWJzt/l9M3lbcG65qcfkARdi6bOB6KHoQy7WeSbqc/cewc
         ofd1o0CKbVdF32NnODwnmGQPdHpCqVr/3W3NXj31Wc0W7OAYpMggqtT44QCSbn8upXAS
         Lccg==
X-Gm-Message-State: AOAM531m6ztq9dLNZ/bQQEbXud9WK9T3/9VFBoxI9dSHxyM9Myt/fYa2
        qw6NrcVUgqbNlaGux1xaFH0=
X-Google-Smtp-Source: ABdhPJw5xbAE7wEbcyMapsNiIsZXhrs3pdJY/wi8Ue4J/gYrZz/U0HT2rOfKimjwPnOHnjO+5GFFlA==
X-Received: by 2002:a62:7716:0:b029:3c6:aa94:5a8d with SMTP id s22-20020a6277160000b02903c6aa945a8dmr20528455pfc.38.1628551858998;
        Mon, 09 Aug 2021 16:30:58 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z18sm17074733pfn.88.2021.08.09.16.30.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 16:30:58 -0700 (PDT)
Subject: Re: [PATCH] lpfc: move initialization of phba->poll_list earlier to
 avoid crash
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc:     stable@vger.kernel.org, james.smart@broadcom.com,
        dick.kennedy@broadcom.com
References: <20210809150947.18104-1-emilne@redhat.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <621ef873-2924-1227-2aa0-815b2b82dc92@gmail.com>
Date:   Mon, 9 Aug 2021 16:30:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809150947.18104-1-emilne@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/2021 8:09 AM, Ewan D. Milne wrote:
> The phba->poll_list is traversed in case of an error in lpfc_sli4_hba_setup(),
> so it must be initialized earlier in case the error path is taken.
> 
> [  490.030738] lpfc 0000:65:00.0: 0:1413 Failed to init iocb list.
> [  490.036661] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> [  490.044485] PGD 0 P4D 0
> [  490.047027] Oops: 0000 [#1] SMP PTI
> [  490.050518] CPU: 0 PID: 7 Comm: kworker/0:1 Kdump: loaded Tainted: G          I      --------- -  - 4.18.
> [  490.060511] Hardware name: Dell Inc. PowerEdge R440/0WKGTH, BIOS 1.4.8 05/22/2018
> [  490.067994] Workqueue: events work_for_cpu_fn
> [  490.072371] RIP: 0010:lpfc_sli4_cleanup_poll_list+0x20/0xb0 [lpfc]
> [  490.078546] Code: cf e9 04 f7 fe ff 0f 1f 40 00 0f 1f 44 00 00 41 57 49 89 ff 41 56 41 55 41 54 4d 8d a79
> [  490.097291] RSP: 0018:ffffbd1a463dbcc8 EFLAGS: 00010246
> [  490.102518] RAX: 0000000000008200 RBX: ffff945cdb8c0000 RCX: 0000000000000000
> [  490.109649] RDX: 0000000000018200 RSI: ffff9468d0e16818 RDI: 0000000000000000
> [  490.116783] RBP: ffff945cdb8c1740 R08: 00000000000015c5 R09: 0000000000000042
> [  490.123915] R10: 0000000000000000 R11: ffffbd1a463dbab0 R12: ffff945cdb8c25c0
> [  490.131049] R13: 00000000fffffff4 R14: 0000000000001800 R15: ffff945cdb8c0000
> [  490.138182] FS:  0000000000000000(0000) GS:ffff9468d0e00000(0000) knlGS:0000000000000000
> [  490.146267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  490.152013] CR2: 0000000000000000 CR3: 000000042ca10002 CR4: 00000000007706f0
> [  490.159146] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  490.166277] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  490.173409] PKRU: 55555554
> [  490.176123] Call Trace:
> [  490.178598]  lpfc_sli4_queue_destroy+0x7f/0x3c0 [lpfc]
> [  490.183745]  lpfc_sli4_hba_setup+0x1bc7/0x23e0 [lpfc]
> [  490.188797]  ? kernfs_activate+0x63/0x80
> [  490.192721]  ? kernfs_add_one+0xe7/0x130
> [  490.196647]  ? __kernfs_create_file+0x80/0xb0
> [  490.201020]  ? lpfc_pci_probe_one_s4.isra.48+0x46f/0x9e0 [lpfc]
> [  490.206944]  lpfc_pci_probe_one_s4.isra.48+0x46f/0x9e0 [lpfc]
> [  490.212697]  lpfc_pci_probe_one+0x179/0xb70 [lpfc]
> [  490.217492]  local_pci_probe+0x41/0x90
> [  490.221246]  work_for_cpu_fn+0x16/0x20
> [  490.224994]  process_one_work+0x1a7/0x360
> [  490.229009]  ? create_worker+0x1a0/0x1a0
> [  490.232933]  worker_thread+0x1cf/0x390
> [  490.236687]  ? create_worker+0x1a0/0x1a0
> [  490.240612]  kthread+0x116/0x130
> [  490.243846]  ? kthread_flush_work_fn+0x10/0x10
> [  490.248293]  ret_from_fork+0x35/0x40
> [  490.251869] Modules linked in: lpfc(+) xt_CHECKSUM ipt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4i
> [  490.332609] CR2: 0000000000000000
> 
> Fixes: 93a4d6f40198 ("scsi: lpfc: Add registration for CPU Offline/Online events")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/lpfc/lpfc_init.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 5983e05b648f..e29523a1b530 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -13193,6 +13193,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
>   	if (!phba)
>   		return -ENOMEM;
>   
> +	INIT_LIST_HEAD(&phba->poll_list);
> +
>   	/* Perform generic PCI device enabling operation */
>   	error = lpfc_enable_pci_dev(phba);
>   	if (error)
> @@ -13327,7 +13329,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
>   	/* Enable RAS FW log support */
>   	lpfc_sli4_ras_setup(phba);
>   
> -	INIT_LIST_HEAD(&phba->poll_list);
>   	timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
>   	cpuhp_state_add_instance_nocalls(lpfc_cpuhp_state, &phba->cpuhp);
>   
> 

Looks good. Thanks Ewan.

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james
