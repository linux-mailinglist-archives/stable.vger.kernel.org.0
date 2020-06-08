Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7781F2E11
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbgFHXNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729271AbgFHXNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 187A720C09;
        Mon,  8 Jun 2020 23:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657998;
        bh=BNvDn/c37fRzH+yDqVcvmJifUx/6tklM+D/+BV8N+oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBGF+ET8TEmr78EQWOvzLpVDFATDWpxx5Pfu9lg/TsZCVckbH+eYEq39mL2Og/Zzp
         5OZnj7xI7kyL8LmU9K48KlRi+epLTw3AcxPIociRoYMP5Buzz63RX+82Jss+YA4VNd
         IYaayO5viUf+dFGQP3bnP4M+0pRS8TVOj62DBeZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 056/606] clk: Unlink clock if failed to prepare or enable
Date:   Mon,  8 Jun 2020 19:03:01 -0400
Message-Id: <20200608231211.3363633-56-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 018d4671b9bbd4a5c55cf6eab3e1dbc70a50b66e upstream.

On failing to prepare or enable a clock, remove the core structure
from the list it has been inserted as it is about to be freed.

This otherwise leads to random crashes when subsequent clocks get
registered, during which parsing of the clock tree becomes adventurous.

Observed with QEMU's RPi-3 emulation.

Fixes: 12ead77432f2 ("clk: Don't try to enable critical clocks if prepare failed")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Link: https://lkml.kernel.org/r/20200505140953.409430-1-maz@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 305544b68b8a..f22b7aed6e64 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3512,6 +3512,9 @@ static int __clk_core_init(struct clk_core *core)
 out:
 	clk_pm_runtime_put(core);
 unlock:
+	if (ret)
+		hlist_del_init(&core->child_node);
+
 	clk_prepare_unlock();
 
 	if (!ret)
-- 
2.25.1

