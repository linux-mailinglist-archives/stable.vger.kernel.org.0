Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86CA011B5A0
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbfLKPPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:15:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:42196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731413AbfLKPPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 877F9208C3;
        Wed, 11 Dec 2019 15:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077341;
        bh=KOZ9Etup0eKMsSBgtIvUGGaM6PFOy51PmIQgKWiCYXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VElkuX+X1jhoAqhVUEeyVdiXI45FFHHVlLThEBuEd1f9JXIBzrQu9NsvxxwGhY9dy
         9maFNWOlc/MJbrIOnZAe8Cxp5EUMsUELfdNPPdmv5y8Hn+2u3t5iuEGuerl2wTKE8+
         JQ4TwUOSPxQvQH8SouLc9vwIhpee15B5PdQaFz6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sahaj Sarup <sahajsarup@gmail.com>,
        Mark Salter <msalter@redhat.com>,
        Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.3 089/105] crypto: ccp - fix uninitialized list head
Date:   Wed, 11 Dec 2019 16:06:18 +0100
Message-Id: <20191211150300.377604506@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

commit 691505a803a7f223b2af621848d581259c61f77d upstream.

A NULL-pointer dereference was reported in fedora bz#1762199 while
reshaping a raid6 array after adding a fifth drive to an existing
array.

[   47.343549] md/raid:md0: raid level 6 active with 3 out of 5 devices, algorithm 2
[   47.804017] md0: detected capacity change from 0 to 7885289422848
[   47.822083] Unable to handle kernel read from unreadable memory at virtual address 0000000000000000
...
[   47.940477] CPU: 1 PID: 14210 Comm: md0_raid6 Tainted: G        W         5.2.18-200.fc30.aarch64 #1
[   47.949594] Hardware name: AMD Overdrive/Supercharger/To be filled by O.E.M., BIOS ROD1002C 04/08/2016
[   47.958886] pstate: 00400085 (nzcv daIf +PAN -UAO)
[   47.963668] pc : __list_del_entry_valid+0x2c/0xa8
[   47.968366] lr : ccp_tx_submit+0x84/0x168 [ccp]
[   47.972882] sp : ffff00001369b970
[   47.976184] x29: ffff00001369b970 x28: ffff00001369bdb8
[   47.981483] x27: 00000000ffffffff x26: ffff8003b758af70
[   47.986782] x25: ffff8003b758b2d8 x24: ffff8003e6245818
[   47.992080] x23: 0000000000000000 x22: ffff8003e62450c0
[   47.997379] x21: ffff8003dfd6add8 x20: 0000000000000003
[   48.002678] x19: ffff8003e6245100 x18: 0000000000000000
[   48.007976] x17: 0000000000000000 x16: 0000000000000000
[   48.013274] x15: 0000000000000000 x14: 0000000000000000
[   48.018572] x13: ffff7e000ef83a00 x12: 0000000000000001
[   48.023870] x11: ffff000010eff998 x10: 00000000000019a0
[   48.029169] x9 : 0000000000000000 x8 : ffff8003e6245180
[   48.034467] x7 : 0000000000000000 x6 : 000000000000003f
[   48.039766] x5 : 0000000000000040 x4 : ffff8003e0145080
[   48.045064] x3 : dead000000000200 x2 : 0000000000000000
[   48.050362] x1 : 0000000000000000 x0 : ffff8003e62450c0
[   48.055660] Call trace:
[   48.058095]  __list_del_entry_valid+0x2c/0xa8
[   48.062442]  ccp_tx_submit+0x84/0x168 [ccp]
[   48.066615]  async_tx_submit+0x224/0x368 [async_tx]
[   48.071480]  async_trigger_callback+0x68/0xfc [async_tx]
[   48.076784]  ops_run_biofill+0x178/0x1e8 [raid456]
[   48.081566]  raid_run_ops+0x248/0x818 [raid456]
[   48.086086]  handle_stripe+0x864/0x1208 [raid456]
[   48.090781]  handle_active_stripes.isra.0+0xb0/0x278 [raid456]
[   48.096604]  raid5d+0x378/0x618 [raid456]
[   48.100602]  md_thread+0xa0/0x150
[   48.103905]  kthread+0x104/0x130
[   48.107122]  ret_from_fork+0x10/0x18
[   48.110686] Code: d2804003 f2fbd5a3 eb03003f 54000320 (f9400021)
[   48.116766] ---[ end trace 23f390a527f7ad77 ]---

ccp_tx_submit is passed a dma_async_tx_descriptor which is contained in
a ccp_dma_desc and adds it to a ccp channel's pending list:

	list_del(&desc->entry);
	list_add_tail(&desc->entry, &chan->pending);

The problem is that desc->entry may be uninitialized in the
async_trigger_callback path where the descriptor was gotten
from ccp_prep_dma_interrupt which got it from ccp_alloc_dma_desc
which doesn't initialize the desc->entry list head. So, just
initialize the list head to avoid the problem.

Cc: <stable@vger.kernel.org>
Reported-by: Sahaj Sarup <sahajsarup@gmail.com>
Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/ccp-dmaengine.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -337,6 +337,7 @@ static struct ccp_dma_desc *ccp_alloc_dm
 	desc->tx_desc.flags = flags;
 	desc->tx_desc.tx_submit = ccp_tx_submit;
 	desc->ccp = chan->ccp;
+	INIT_LIST_HEAD(&desc->entry);
 	INIT_LIST_HEAD(&desc->pending);
 	INIT_LIST_HEAD(&desc->active);
 	desc->status = DMA_IN_PROGRESS;


