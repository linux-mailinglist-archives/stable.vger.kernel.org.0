Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697243E236C
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 08:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhHFGnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 02:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232382AbhHFGnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 02:43:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20C3A611C5;
        Fri,  6 Aug 2021 06:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628232215;
        bh=h+Rb1Q5xB7nCmla3XprXg4fmKFXpU+drkAfgr8FZnA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kJtowNA2ISDGfYL3W/9jlXnGY2/R4G/e7NXjSsndonZyMdvXp70hEtBnpF4DNcZkD
         LBIQGbHGvoX5hq1AwyUpMMc5yIelB+iGMzYnAw0mQVvp6rK9jpll0FCert3Q4pG3xP
         dSMiVBdd4tOtweEmHQ17Cg4o7b9IzJg0FBYi1930=
Date:   Fri, 6 Aug 2021 08:43:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org, steffen.klassert@secunet.com,
        daniel.m.jordan@oracle.com, herbert@gondor.apana.org.au,
        sashal@kernel.org
Subject: Re: [PATCH 4.19 0/2] fix divide zero error in padata_do_parallel()
Message-ID: <YQzaFHAAwr/8SEgD@kroah.com>
References: <20210803125301.77629-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803125301.77629-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 03, 2021 at 08:52:59PM +0800, Yang Yingliang wrote:
> It can reproduced by the following commands:
> 
>   # modprobe pcrypt
>   # echo 2 > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
>   # echo 0 > /sys/devices/system/cpu/cpu1/online
>   # modprobe tcrypt alg="pcrypt(rfc4106(gcm(aes)))" type=3
> 
> [  229.549005] divide error: 0000 [#1] SMP PTI
> [  229.549130] CPU: 32 PID: 9565 Comm: cryptomgr_test Kdump: loaded Not tainted 4.19.200 #3
> [  229.549381] Hardware name: Huawei 2288H V5/BC11SPSCB0, BIOS 0.68 05/03/2018
> [  229.549607] RIP: 0010:padata_do_parallel+0x96/0x150
> [  229.549750] Code: 5e 10 89 56 18 f0 0f c1 6b 20 8b 35 78 b1 24 01 48 8b 7b 28 e8 eb d6 20 00 89 c1 8d 45 01 31 d2 8b 35 62 b1 24 01 48 8b 7b 28 <f7> f1 41 89 d7 e8 d0 45 21 00 45 85 ff 41 89 c4 7e 19 31 ed 48 8b
> [  229.550335] RSP: 0018:ffffa48b8e1cbbc8 EFLAGS: 00010246
> [  229.550498] RAX: 0000000000000000 RBX: ffff964940883bc0 RCX: 0000000000000000
> [  229.550720] RDX: 0000000000000000 RSI: 0000000000000038 RDI: ffff9687b6e45650
> [  229.550943] RBP: 00000000ffffffff R08: 0000000000000000 R09: ffff96c7af6f6200
> [  229.551165] R10: ffff9687b6e45650 R11: ffff968839629000 R12: 0000000000000010
> [  229.551388] R13: ffff9687b6997f50 R14: ffff96c7ad84d700 R15: ffffffff9287a220
> [  229.551610] FS:  0000000000000000(0000) GS:ffff9687bfc80000(0000) knlGS:0000000000000000
> [  229.551863] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  229.552044] CR2: 00007fad13d47564 CR3: 000000759480a004 CR4: 00000000007606e0
> [  229.552265] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  229.552488] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  229.552710] PKRU: 55555554
> [  229.552796] Call Trace:
> [  229.552878]  pcrypt_aead_encrypt+0xbb/0xc7 [pcrypt]
> [  229.553028]  __test_aead+0x654/0x15d0
> [  229.553139]  ? _cond_resched+0x15/0x40
> [  229.553257]  ? crypto_create_tfm+0x4e/0xe0
> [  229.553385]  ? crypto_spawn_tfm2+0x2e/0x50
> [  229.553513]  ? _cond_resched+0x15/0x40
> [  229.553632]  ? crypto_acomp_scomp_free_ctx+0x30/0x30
> [  229.553786]  test_aead+0x21/0xa0
> [  229.553889]  alg_test_aead+0x3f/0xa0
> [  229.554001]  alg_test.part.15+0x178/0x380
> [  229.554127]  ? __switch_to+0x8c/0x400
> [  229.554239]  ? __switch_to_asm+0x41/0x70
> [  229.554362]  ? __switch_to_asm+0x35/0x70
> [  229.554486]  ? __schedule+0x25d/0x850
> [  229.554602]  ? __wake_up_common+0x76/0x170
> [  229.554727]  ? crypto_acomp_scomp_free_ctx+0x30/0x30
> [  229.554884]  cryptomgr_test+0x40/0x50
> [  229.554999]  kthread+0x113/0x130
> [  229.555099]  ? kthread_create_worker_on_cpu+0x70/0x70
> [  229.555255]  ret_from_fork+0x35/0x40
> 
> 
> Daniel Jordan (2):
>   padata: validate cpumask without removed CPU during offline
>   padata: add separate cpuhp node for CPUHP_PADATA_DEAD
> 
>  include/linux/cpuhotplug.h |  1 +
>  include/linux/padata.h     |  6 ++++--
>  kernel/padata.c            | 28 ++++++++++++++++++++--------
>  3 files changed, 25 insertions(+), 10 deletions(-)

All now queued up, thanks!

greg k-h
