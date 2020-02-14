Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E7715E787
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404855AbgBNQSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:18:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404847AbgBNQSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:18:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E85F24706;
        Fri, 14 Feb 2020 16:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697127;
        bh=Ul5D6/mqKZIgJ1DfYAEbn7m5d2kt5rrccOxP0rGDR54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTHHQPASxjEQg8iedo8hGFFXASWZUelCtd5ERC23gdD9GLQgQtcJCk2o8Hu23b2aV
         X9JDWeKYibkdcFzVHMz7EUTT3n3PMfu0372Ppuaa5JIvgAJ6DHQV3hOZxStHmU1jbi
         8GPwk6YR371RGbGgQgpO1Es1/dgEfQynwBo3IvUY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 071/186] tty: serial: amba-pl011: remove set but unused variable
Date:   Fri, 14 Feb 2020 11:15:20 -0500
Message-Id: <20200214161715.18113-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 94345aee285334e9e12fc70572e3d9380791a64e ]

Fix the following warning:
drivers/tty/serial/amba-pl011.c: In function check_apply_cts_event_workaround:
drivers/tty/serial/amba-pl011.c:1461:15: warning: variable dummy_read set but not used [-Wunused-but-set-variable]

The data read is useless and can be dropped.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/1575619526-34482-1-git-send-email-wangxiongfeng2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 637f72fb6427f..00a29052c226d 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1474,8 +1474,6 @@ static void pl011_modem_status(struct uart_amba_port *uap)
 
 static void check_apply_cts_event_workaround(struct uart_amba_port *uap)
 {
-	unsigned int dummy_read;
-
 	if (!uap->vendor->cts_event_workaround)
 		return;
 
@@ -1487,8 +1485,8 @@ static void check_apply_cts_event_workaround(struct uart_amba_port *uap)
 	 * single apb access will incur 2 pclk(133.12Mhz) delay,
 	 * so add 2 dummy reads
 	 */
-	dummy_read = pl011_read(uap, REG_ICR);
-	dummy_read = pl011_read(uap, REG_ICR);
+	pl011_read(uap, REG_ICR);
+	pl011_read(uap, REG_ICR);
 }
 
 static irqreturn_t pl011_int(int irq, void *dev_id)
-- 
2.20.1

