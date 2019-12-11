Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFCD11B654
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbfLKQAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:00:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731505AbfLKPNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9D8A2467E;
        Wed, 11 Dec 2019 15:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077228;
        bh=hQ/UauJDG+Ahl5wENQlLIFAczqZfBM8cOYQwA1HoduA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k29wZFwGDGW8K1TlWHtMKxWONp+4s21HT970SfPr7zpfAhLzXBO5dR2dmCXhPum9s
         LwqwqmX5vjghnNLDanGMrAu6HjTWSxpVsSZwp5/oQTmJ6y57Umwx1MTtwuZ+tCofb4
         TCiEwTqt8UnOF6EMZFjoHM97ybAZfxfGCsUKlSJ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, devel@linuxdriverproject.org
Subject: [PATCH AUTOSEL 5.4 107/134] Drivers: hv: vmbus: Fix crash handler reset of Hyper-V synic
Date:   Wed, 11 Dec 2019 10:11:23 -0500
Message-Id: <20191211151150.19073-107-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit 7a1323b5dfe44a9013a2cc56ef2973034a00bf88 ]

The crash handler calls hv_synic_cleanup() to shutdown the
Hyper-V synthetic interrupt controller.  But if the CPU
that calls hv_synic_cleanup() has a VMbus channel interrupt
assigned to it (which is likely the case in smaller VM sizes),
hv_synic_cleanup() returns an error and the synthetic
interrupt controller isn't shutdown.  While the lack of
being shutdown hasn't caused a known problem, it still
should be fixed for highest reliability.

So directly call hv_synic_disable_regs() instead of
hv_synic_cleanup(), which ensures that the synic is always
shutdown.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 53a60c81e220d..05ead1735c6e3 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2308,7 +2308,7 @@ static void hv_crash_handler(struct pt_regs *regs)
 	vmbus_connection.conn_state = DISCONNECTED;
 	cpu = smp_processor_id();
 	hv_stimer_cleanup(cpu);
-	hv_synic_cleanup(cpu);
+	hv_synic_disable_regs(cpu);
 	hyperv_cleanup();
 };
 
-- 
2.20.1

