Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6FF6432BD
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiLET3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbiLET2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:28:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0C329CA8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:25:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B7F461311
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0AEC433D6;
        Mon,  5 Dec 2022 19:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268315;
        bh=xS6rCsevKMFtKWavKlC0g5Qa/TkfSEgsZvtvjRvm8vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQy4ZS2xMzZhs5DO2jwRDRpAp0MADD8ZlQu2ArRs1zFv2+OvaliYj5i7Ctt0ms9VE
         D2zonmb+MpWq78QVeJ040fpvKFzBW3oXZz3GiU+hVKktL6dF+KH/nFGEcCnsY4vTwI
         F4+70OQaBbVe7Swd42IgA1hUdprvRmx8FtWDsM0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bonaccorso Salvatore <carnil@debian.org>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 056/124] net: wwan: iosm: fix dma_alloc_coherent incompatible pointer type
Date:   Mon,  5 Dec 2022 20:09:22 +0100
Message-Id: <20221205190810.018735553@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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



