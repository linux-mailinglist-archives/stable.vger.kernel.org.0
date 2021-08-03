Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDA13DEE1E
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 14:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbhHCMrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 08:47:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12441 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbhHCMrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 08:47:11 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GfF0Y4gFnzck3K;
        Tue,  3 Aug 2021 20:43:25 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 3 Aug 2021 20:46:58 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 3 Aug 2021
 20:46:58 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <daniel.m.jordan@oracle.com>,
        <herbert@gondor.apana.org.au>, <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
Subject: [PATCH 4.19 0/2] fix divide zero error in padata_do_parallel()
Date:   Tue, 3 Aug 2021 20:52:59 +0800
Message-ID: <20210803125301.77629-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It can reproduced by the following commands:

  # modprobe pcrypt
  # echo 2 > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
  # echo 0 > /sys/devices/system/cpu/cpu1/online
  # modprobe tcrypt alg="pcrypt(rfc4106(gcm(aes)))" type=3

[  229.549005] divide error: 0000 [#1] SMP PTI
[  229.549130] CPU: 32 PID: 9565 Comm: cryptomgr_test Kdump: loaded Not tainted 4.19.200 #3
[  229.549381] Hardware name: Huawei 2288H V5/BC11SPSCB0, BIOS 0.68 05/03/2018
[  229.549607] RIP: 0010:padata_do_parallel+0x96/0x150
[  229.549750] Code: 5e 10 89 56 18 f0 0f c1 6b 20 8b 35 78 b1 24 01 48 8b 7b 28 e8 eb d6 20 00 89 c1 8d 45 01 31 d2 8b 35 62 b1 24 01 48 8b 7b 28 <f7> f1 41 89 d7 e8 d0 45 21 00 45 85 ff 41 89 c4 7e 19 31 ed 48 8b
[  229.550335] RSP: 0018:ffffa48b8e1cbbc8 EFLAGS: 00010246
[  229.550498] RAX: 0000000000000000 RBX: ffff964940883bc0 RCX: 0000000000000000
[  229.550720] RDX: 0000000000000000 RSI: 0000000000000038 RDI: ffff9687b6e45650
[  229.550943] RBP: 00000000ffffffff R08: 0000000000000000 R09: ffff96c7af6f6200
[  229.551165] R10: ffff9687b6e45650 R11: ffff968839629000 R12: 0000000000000010
[  229.551388] R13: ffff9687b6997f50 R14: ffff96c7ad84d700 R15: ffffffff9287a220
[  229.551610] FS:  0000000000000000(0000) GS:ffff9687bfc80000(0000) knlGS:0000000000000000
[  229.551863] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  229.552044] CR2: 00007fad13d47564 CR3: 000000759480a004 CR4: 00000000007606e0
[  229.552265] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  229.552488] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  229.552710] PKRU: 55555554
[  229.552796] Call Trace:
[  229.552878]  pcrypt_aead_encrypt+0xbb/0xc7 [pcrypt]
[  229.553028]  __test_aead+0x654/0x15d0
[  229.553139]  ? _cond_resched+0x15/0x40
[  229.553257]  ? crypto_create_tfm+0x4e/0xe0
[  229.553385]  ? crypto_spawn_tfm2+0x2e/0x50
[  229.553513]  ? _cond_resched+0x15/0x40
[  229.553632]  ? crypto_acomp_scomp_free_ctx+0x30/0x30
[  229.553786]  test_aead+0x21/0xa0
[  229.553889]  alg_test_aead+0x3f/0xa0
[  229.554001]  alg_test.part.15+0x178/0x380
[  229.554127]  ? __switch_to+0x8c/0x400
[  229.554239]  ? __switch_to_asm+0x41/0x70
[  229.554362]  ? __switch_to_asm+0x35/0x70
[  229.554486]  ? __schedule+0x25d/0x850
[  229.554602]  ? __wake_up_common+0x76/0x170
[  229.554727]  ? crypto_acomp_scomp_free_ctx+0x30/0x30
[  229.554884]  cryptomgr_test+0x40/0x50
[  229.554999]  kthread+0x113/0x130
[  229.555099]  ? kthread_create_worker_on_cpu+0x70/0x70
[  229.555255]  ret_from_fork+0x35/0x40


Daniel Jordan (2):
  padata: validate cpumask without removed CPU during offline
  padata: add separate cpuhp node for CPUHP_PADATA_DEAD

 include/linux/cpuhotplug.h |  1 +
 include/linux/padata.h     |  6 ++++--
 kernel/padata.c            | 28 ++++++++++++++++++++--------
 3 files changed, 25 insertions(+), 10 deletions(-)

-- 
2.25.1

