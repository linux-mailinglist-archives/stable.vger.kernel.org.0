Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA28D172131
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgB0Nld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:41:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729606AbgB0Nlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:41:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43C6420726;
        Thu, 27 Feb 2020 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810891;
        bh=GOe/Q8d9pnM7OTay7ZXq8JIEleloYnDKCFv4IzHU8VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xuTwNMvE/XowoBPr7s2XQO/iiApR2CdCVHtad2ZgP6w7ukaZ9q5MXesIqC2Eg/aI6
         13fPKsavj4+wzY1bORmqYdriVIElQkin3/PkRQzpIH/dGMvuhIMOQH2pNAF9elVWtO
         OemflxMRFoOGfaWv1XrXWwg5NO9D7uPb7tEzd2tU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 037/113] NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().
Date:   Thu, 27 Feb 2020 14:35:53 +0100
Message-Id: <20200227132217.643078727@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
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
index 87d5099967040..3ffbed72adf75 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -545,7 +545,7 @@ static void port100_tx_update_payload_len(void *_frame, int len)
 {
 	struct port100_frame *frame = _frame;
 
-	frame->datalen = cpu_to_le16(le16_to_cpu(frame->datalen) + len);
+	le16_add_cpu(&frame->datalen, len);
 }
 
 static bool port100_rx_frame_is_valid(void *_frame)
-- 
2.20.1



