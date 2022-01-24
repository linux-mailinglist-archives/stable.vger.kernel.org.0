Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D649A269
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365728AbiAXXvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382872AbiAXWlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:41:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6371C06B5A3;
        Mon, 24 Jan 2022 13:05:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93995B815A3;
        Mon, 24 Jan 2022 21:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57C1C340E5;
        Mon, 24 Jan 2022 21:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058318;
        bh=sgSscAIfs33is+A3+mF+JxJk+KOnqSxfxISmLEcfSqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvMmriGtzShToeVfXl8+lY+OsBBh06S8mXMLxqfprRBgpwm6R9lS2dwJTb6vp7Quj
         vTPywwIatTjkC3SL63VDySVPumA70mQc/h6Y809fEAACBqCyzhnugks5H2VU3mq11v
         aaMd5PAxVKRK0DNQ4+vD7bMgYAZDE0U3jKvKXlQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0250/1039] wireless: iwlwifi: Fix a double free in iwl_txq_dyn_alloc_dma
Date:   Mon, 24 Jan 2022 19:33:59 +0100
Message-Id: <20220124184133.736087294@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit f973795a8d19cbf3d03807704eb7c6ff65788d5a ]

In iwl_txq_dyn_alloc_dma, txq->tfds is freed at first time by:
iwl_txq_alloc()->goto err_free_tfds->dma_free_coherent(). But
it forgot to set txq->tfds to NULL.

Then the txq->tfds is freed again in iwl_txq_dyn_alloc_dma by:
goto error->iwl_txq_gen2_free_memory()->dma_free_coherent().

My patch sets txq->tfds to NULL after the first free to avoid the
double free.

Fixes: 0cd1ad2d7fd41 ("iwlwifi: move all bus-independent TX functions to common code")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Link: https://lore.kernel.org/r/20210403054755.4781-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/queue/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index 451b060693501..0f3526b0c5b00 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -1072,6 +1072,7 @@ int iwl_txq_alloc(struct iwl_trans *trans, struct iwl_txq *txq, int slots_num,
 	return 0;
 err_free_tfds:
 	dma_free_coherent(trans->dev, tfd_sz, txq->tfds, txq->dma_addr);
+	txq->tfds = NULL;
 error:
 	if (txq->entries && cmd_queue)
 		for (i = 0; i < slots_num; i++)
-- 
2.34.1



