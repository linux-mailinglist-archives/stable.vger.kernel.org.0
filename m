Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E095F49A02C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842370AbiAXXBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839864AbiAXWwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:52:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960B6C0EE124;
        Mon, 24 Jan 2022 13:08:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32D2361361;
        Mon, 24 Jan 2022 21:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB83C340E5;
        Mon, 24 Jan 2022 21:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058500;
        bh=wCfGmnqg8RDNFzmO5ZVCUAYTvgNwzU7QViE47riBEbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbxbL3BUVN3YoovtNYi9fdwC+ruPjqiNUMQDafzqHRMLHtY0uGEPnKU661V8pmaqR
         PhVt3yEOmF2GH38saCV5zpyq4Ayzambfz4VsYD62whKvAC0zY2DH7SsK1gNR2Cxgra
         C3QoQXCF1zH0j9OPMzCE6SdQ3DYW3uFgKRr8fiWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0310/1039] mt76: debugfs: fix queue reporting for mt76-usb
Date:   Mon, 24 Jan 2022 19:34:59 +0100
Message-Id: <20220124184135.729212233@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit eae7df016c30468e09481a75b1339f0ab5ece222 ]

Fix number of rx-queued frames reported by mt76_usb driver.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 2d8be76c1674 ("mt76: debugfs: improve queue node readability")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/debugfs.c b/drivers/net/wireless/mediatek/mt76/debugfs.c
index b8bcf22a07fd8..47e9911ee9fe6 100644
--- a/drivers/net/wireless/mediatek/mt76/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/debugfs.c
@@ -82,7 +82,7 @@ static int mt76_rx_queues_read(struct seq_file *s, void *data)
 
 		queued = mt76_is_usb(dev) ? q->ndesc - q->queued : q->queued;
 		seq_printf(s, " %9d | %9d | %9d | %9d |\n",
-			   i, q->queued, q->head, q->tail);
+			   i, queued, q->head, q->tail);
 	}
 
 	return 0;
-- 
2.34.1



