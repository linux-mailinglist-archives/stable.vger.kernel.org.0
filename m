Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741B16AF4B7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjCGTTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbjCGTSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:18:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455C89CBC1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:02:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2039B819F4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A691C433D2;
        Tue,  7 Mar 2023 19:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215750;
        bh=LiOjqX0MybB2ESZFPos4b2ZK9+r5OgWsHAmijsmgXt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJqEhHAFkN7N+uY66coDcz6kzyUkBiUdvQZswQ2vrSjUeWMKdpmobVYNQLaoFmiaG
         L0DN5Td4UPziCBA9blt6t5N9LFBqDZ3cDd/vjpWoQWU5te5t9YBqx1PofxhCvAWUXG
         u3rQd2evs42dmircYM2f0bY5Xv6M0cs0ZeddZSwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 331/567] dmaengine: dw-edma: Fix readq_ch() return value truncation
Date:   Tue,  7 Mar 2023 18:01:07 +0100
Message-Id: <20230307165920.244893866@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 5fdca4a995bcd4cf61bda40af154a730589dc524 ]

Previously, readq_ch() did a 64-bit readq(), but truncated the result by
storing it in the u32 "value".  Change "value" to u64 to avoid the
truncation.

Note: the method is currently unused, so the bug hasn't caused any problem
so far.

Fixes: 04e0a39fc10f ("dmaengine: dw-edma: Add writeq() and readq() for 64 bits architectures")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-v0-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-edma/dw-edma-v0-core.c b/drivers/dma/dw-edma/dw-edma-v0-core.c
index b5b8f8181e776..043a4f3115fa3 100644
--- a/drivers/dma/dw-edma/dw-edma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
@@ -192,7 +192,7 @@ static inline void writeq_ch(struct dw_edma *dw, enum dw_edma_dir dir, u16 ch,
 static inline u64 readq_ch(struct dw_edma *dw, enum dw_edma_dir dir, u16 ch,
 			   const void __iomem *addr)
 {
-	u32 value;
+	u64 value;
 
 	if (dw->mf == EDMA_MF_EDMA_LEGACY) {
 		u32 viewport_sel;
-- 
2.39.2



