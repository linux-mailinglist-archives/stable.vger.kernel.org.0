Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DF91C450F
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731454AbgEDSDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731450AbgEDSDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:03:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4B09206B8;
        Mon,  4 May 2020 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615386;
        bh=ytZwgFE7cLPXO0eUnNw0mcP7f4wwPBF7aiAhnHM+Z90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/CI2agnHHFi9sOZ9T0MOlbLia24Yd6igtcMsPgjjD6qTADf0PzBzACsK9+RNO21n
         3bovQk09+pl4RioBiCDlnydXR0IOe3Y/w32FMeeAYiPIGK2ke1iX03aWFttyLOSuUH
         9MGtKrbQLAivHOIRJKLc2jBNEbV4x6taxrO4KZN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Iuliana Prodan <iuliana.prodan@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 18/57] crypto: caam - fix the address of the last entry of S/G
Date:   Mon,  4 May 2020 19:57:22 +0200
Message-Id: <20200504165457.965888549@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

commit 55b3209acbb01cb02b1ee6b1afe80d83b1aab36d upstream.

For skcipher algorithms, the input, output HW S/G tables
look like this: [IV, src][dst, IV]
Now, we can have 2 conditions here:
- there is no IV;
- src and dst are equal (in-place encryption) and scattered
and the error is an "off-by-one" in the HW S/G table.

This issue was seen with KASAN:
BUG: KASAN: slab-out-of-bounds in skcipher_edesc_alloc+0x95c/0x1018

Read of size 4 at addr ffff000022a02958 by task cryptomgr_test/321

CPU: 2 PID: 321 Comm: cryptomgr_test Not tainted
5.6.0-rc1-00165-ge4ef8383-dirty #4
Hardware name: LS1046A RDB Board (DT)
Call trace:
 dump_backtrace+0x0/0x260
 show_stack+0x14/0x20
 dump_stack+0xe8/0x144
 print_address_description.isra.11+0x64/0x348
 __kasan_report+0x11c/0x230
 kasan_report+0xc/0x18
 __asan_load4+0x90/0xb0
 skcipher_edesc_alloc+0x95c/0x1018
 skcipher_encrypt+0x84/0x150
 crypto_skcipher_encrypt+0x50/0x68
 test_skcipher_vec_cfg+0x4d4/0xc10
 test_skcipher_vec+0x178/0x1d8
 alg_test_skcipher+0xec/0x230
 alg_test.part.44+0x114/0x4a0
 alg_test+0x1c/0x60
 cryptomgr_test+0x34/0x58
 kthread+0x1b8/0x1c0
 ret_from_fork+0x10/0x18

Allocated by task 321:
 save_stack+0x24/0xb0
 __kasan_kmalloc.isra.10+0xc4/0xe0
 kasan_kmalloc+0xc/0x18
 __kmalloc+0x178/0x2b8
 skcipher_edesc_alloc+0x21c/0x1018
 skcipher_encrypt+0x84/0x150
 crypto_skcipher_encrypt+0x50/0x68
 test_skcipher_vec_cfg+0x4d4/0xc10
 test_skcipher_vec+0x178/0x1d8
 alg_test_skcipher+0xec/0x230
 alg_test.part.44+0x114/0x4a0
 alg_test+0x1c/0x60
 cryptomgr_test+0x34/0x58
 kthread+0x1b8/0x1c0
 ret_from_fork+0x10/0x18

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff000022a02800
 which belongs to the cache dma-kmalloc-512 of size 512
The buggy address is located 344 bytes inside of
 512-byte region [ffff000022a02800, ffff000022a02a00)
The buggy address belongs to the page:
page:fffffe00006a8000 refcount:1 mapcount:0 mapping:ffff00093200c400
index:0x0 compound_mapcount: 0
flags: 0xffff00000010200(slab|head)
raw: 0ffff00000010200 dead000000000100 dead000000000122 ffff00093200c400
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff000022a02800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff000022a02880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff000022a02900: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
                                                    ^
 ffff000022a02980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff000022a02a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

Fixes: 334d37c9e263 ("crypto: caam - update IV using HW support")
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1810,7 +1810,7 @@ static struct skcipher_edesc *skcipher_e
 
 	if (ivsize || mapped_dst_nents > 1)
 		sg_to_sec4_set_last(edesc->sec4_sg + dst_sg_idx +
-				    mapped_dst_nents);
+				    mapped_dst_nents - 1 + !!ivsize);
 
 	if (sec4_sg_bytes) {
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,


