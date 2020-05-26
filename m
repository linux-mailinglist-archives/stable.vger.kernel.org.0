Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFA21E2E28
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391293AbgEZTD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390518AbgEZTD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:03:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C4CF20873;
        Tue, 26 May 2020 19:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519837;
        bh=UepWdnsWpDppgVk5vfkJFKBUbmMK8J+U8pMrQTMIVVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9mT6jN3zILXnD4vvt8XhHswIcGy9McAP7Jez2ru8JX/7ZIcJ2/BxHk7IqCqP3Hac
         ULG2Uwwpnb6DeZPKH8P4HIPTAqNkHfxLKRUF1allKANbTO6ZskqQy07fQDWW43l5mF
         nDnl4uZo78149NLWFUhMs4SLKqzF52oO+eJohnkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/81] padata: initialize pd->cpu with effective cpumask
Date:   Tue, 26 May 2020 20:53:11 +0200
Message-Id: <20200526183931.357121297@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit ec9c7d19336ee98ecba8de80128aa405c45feebb ]

Exercising CPU hotplug on a 5.2 kernel with recent padata fixes from
cryptodev-2.6.git in an 8-CPU kvm guest...

    # modprobe tcrypt alg="pcrypt(rfc4106(gcm(aes)))" type=3
    # echo 0 > /sys/devices/system/cpu/cpu1/online
    # echo c > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
    # modprobe tcrypt mode=215

...caused the following crash:

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 0 P4D 0
    Oops: 0000 [#1] SMP PTI
    CPU: 2 PID: 134 Comm: kworker/2:2 Not tainted 5.2.0-padata-base+ #7
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-<snip>
    Workqueue: pencrypt padata_parallel_worker
    RIP: 0010:padata_reorder+0xcb/0x180
    ...
    Call Trace:
     padata_do_serial+0x57/0x60
     pcrypt_aead_enc+0x3a/0x50 [pcrypt]
     padata_parallel_worker+0x9b/0xe0
     process_one_work+0x1b5/0x3f0
     worker_thread+0x4a/0x3c0
     ...

In padata_alloc_pd, pd->cpu is set using the user-supplied cpumask
instead of the effective cpumask, and in this case cpumask_first picked
an offline CPU.

The offline CPU's reorder->list.next is NULL in padata_reorder because
the list wasn't initialized in padata_init_pqueues, which only operates
on CPUs in the effective mask.

Fix by using the effective mask in padata_alloc_pd.

Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 47dc31ce15ac..e9b8d517fd4b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -451,7 +451,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	atomic_set(&pd->refcnt, 1);
 	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
-	pd->cpu = cpumask_first(pcpumask);
+	pd->cpu = cpumask_first(pd->cpumask.pcpu);
 	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
 
 	return pd;
-- 
2.25.1



