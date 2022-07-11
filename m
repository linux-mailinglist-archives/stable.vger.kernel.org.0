Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D1F56FA15
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiGKJMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiGKJMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:12:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8B922B05;
        Mon, 11 Jul 2022 02:09:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BF55B80E5E;
        Mon, 11 Jul 2022 09:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D162AC34115;
        Mon, 11 Jul 2022 09:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530558;
        bh=mp9c0u3Olp1mR637kiOEdlcgDsTF7diXWpPkTx7Q9yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UM5IqHJv53olfOk0OiZpAAUvnsDuC8RVbVbfOk32nyndapzeZL8Ol54MS1vgg3I+m
         1l+AWHOePe84kcmQF+c9i+ff1RVJDStQiy4syNzi9m8KGbbgoU6jbcAVk++vKzvBDE
         d1ynVe+5zAgUqd51bXyE5tTnFqSI5oH9yuuDPyHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 28/31] dmaengine: pl330: Fix lockdep warning about non-static key
Date:   Mon, 11 Jul 2022 11:07:07 +0200
Message-Id: <20220711090538.677136893@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090537.841305347@linuxfoundation.org>
References: <20220711090537.841305347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit b64b3b2f1d81f83519582e1feee87d77f51f5f17 upstream.

The DEFINE_SPINLOCK() macro shouldn't be used for dynamically allocated
spinlocks. The lockdep warns about this and disables locking validator.
Fix the warning by making lock static.

 INFO: trying to register non-static key.
 The code is fine but needs lockdep annotation, or maybe
 you didn't initialize this object before use?
 turning off the locking correctness validator.
 Hardware name: Radxa ROCK Pi 4C (DT)
 Call trace:
  dump_backtrace.part.0+0xcc/0xe0
  show_stack+0x18/0x6c
  dump_stack_lvl+0x8c/0xb8
  dump_stack+0x18/0x34
  register_lock_class+0x4a8/0x4cc
  __lock_acquire+0x78/0x20cc
  lock_acquire.part.0+0xe0/0x230
  lock_acquire+0x68/0x84
  _raw_spin_lock_irqsave+0x84/0xc4
  add_desc+0x44/0xc0
  pl330_get_desc+0x15c/0x1d0
  pl330_prep_dma_cyclic+0x100/0x270
  snd_dmaengine_pcm_trigger+0xec/0x1c0
  dmaengine_pcm_trigger+0x18/0x24
  ...

Fixes: e588710311ee ("dmaengine: pl330: fix descriptor allocation fail")
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://lore.kernel.org/r/20220520181432.149904-1-dmitry.osipenko@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/pl330.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2568,7 +2568,7 @@ static struct dma_pl330_desc *pl330_get_
 
 	/* If the DMAC pool is empty, alloc new */
 	if (!desc) {
-		DEFINE_SPINLOCK(lock);
+		static DEFINE_SPINLOCK(lock);
 		LIST_HEAD(pool);
 
 		if (!add_desc(&pool, &lock, GFP_ATOMIC, 1))


