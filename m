Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8186433A8
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbiLETi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiLETiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:38:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ABEDD1
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:35:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7D0D61321
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC633C433D6;
        Mon,  5 Dec 2022 19:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268903;
        bh=xS6rCsevKMFtKWavKlC0g5Qa/TkfSEgsZvtvjRvm8vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q1ItmfGuivLj3L5Y1P2YxBCYu928+0L1emRxp82DxWDIbb/s9mCCT8Li1FGJ9ZR/l
         Hf73BSIbI1e4p01uEWE/A+3XLZ8Bhfmc0OWfn4pmK6LR+zRLXhOnvfgyxihNVoyMV2
         BmEE2NZ828+pg5vjYD6dwEvERGzUl6/OArOZjHJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bonaccorso Salvatore <carnil@debian.org>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/120] net: wwan: iosm: fix dma_alloc_coherent incompatible pointer type
Date:   Mon,  5 Dec 2022 20:09:54 +0100
Message-Id: <20221205190808.241618764@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit 4a99e3c8ed888577b947cbed97d88c9706896105 ]

Fix build error reported on armhf while preparing 6.1-rc5
for Debian.

iosm_ipc_protocol.c:244:36: error: passing argument 3 of
'dma_alloc_coherent' from incompatible pointer type.

Change phy_ap_shm type from phys_addr_t to dma_addr_t.

Fixes: faed4c6f6f48 ("net: iosm: shared memory protocol")
Reported-by: Bonaccorso Salvatore <carnil@debian.org>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_protocol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol.h b/drivers/net/wwan/iosm/iosm_ipc_protocol.h
index 9b3a6d86ece7..289397c4ea6c 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol.h
@@ -122,7 +122,7 @@ struct iosm_protocol {
 	struct iosm_imem *imem;
 	struct ipc_rsp *rsp_ring[IPC_MEM_MSG_ENTRIES];
 	struct device *dev;
-	phys_addr_t phy_ap_shm;
+	dma_addr_t phy_ap_shm;
 	u32 old_msg_tail;
 };
 
-- 
2.35.1



