Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCEEE1672C5
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731943AbgBUIGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:06:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731641AbgBUIGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:06:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADCBC20722;
        Fri, 21 Feb 2020 08:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272384;
        bh=zLAaDFzj2bwYv+0kiJhndvoOAmSRnnLJlpove3CrpdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13Or5oz/raI2ySkwfWBhmO4JM3XJw0WAQVyIdMWVHDmyvCAdEySBevL0TifKREubE
         VD6WMDbVe77wAm5IVORoc9NQM/4boErIAeYTd/WZ+0RNCtYN4gC7WSThvPg88ZPYXu
         0SzvNXpuqkCZvt8w3tPv+O52GhBLTRQ0WZ5RyC3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/344] NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().
Date:   Fri, 21 Feb 2020 08:38:24 +0100
Message-Id: <20200221072358.459842917@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>

[ Upstream commit 718eae277e62a26e5862eb72a830b5e0fe37b04a ]

Convert cpu_to_le16(le16_to_cpu(frame->datalen) + len) to
use le16_add_cpu(), which is more concise and does the same thing.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/port100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 604dba4f18afd..8e4d355dc3aec 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -565,7 +565,7 @@ static void port100_tx_update_payload_len(void *_frame, int len)
 {
 	struct port100_frame *frame = _frame;
 
-	frame->datalen = cpu_to_le16(le16_to_cpu(frame->datalen) + len);
+	le16_add_cpu(&frame->datalen, len);
 }
 
 static bool port100_rx_frame_is_valid(void *_frame)
-- 
2.20.1



