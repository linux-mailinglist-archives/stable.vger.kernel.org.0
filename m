Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34E112F13C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgABW66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727980AbgABWO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1C11227BF;
        Thu,  2 Jan 2020 22:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003299;
        bh=lIgnPbZoi6opNBmtNTCpIV0Nr11jwcGg5uA+Bg96oEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpR9S7hMa5lacvlprLCcNElzhFCzXVrq/hGN2QnYLIMc5u28BgcJRt2Xb7RlpmwJQ
         M8KV/V6Q3fTYqXO7zz23RYk0HPORtZiKTLA9JlWVOMlP65ggCaOKJkHQ2aMF+vLQ4P
         b4X4HWHa8+mP9qzeDHORK+E9+kxY8ClolZJluSHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/191] Drivers: hv: vmbus: Fix crash handler reset of Hyper-V synic
Date:   Thu,  2 Jan 2020 23:06:25 +0100
Message-Id: <20200102215840.970579601@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 53a60c81e220..05ead1735c6e 100644
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



