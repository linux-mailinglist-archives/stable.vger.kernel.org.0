Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 959ED13E3FE
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbgAPRFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:05:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388650AbgAPRFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57FD520730;
        Thu, 16 Jan 2020 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194322;
        bh=nehLpuv8ecbZ2QZTvLTSRS74dVLre05bitNHwwtOKKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8AMhHeGETH2vAcM6qFmi5yYE6CXnkvYIN+OApnaKhG2Xe2B+rBVIKftzMWvo45YG
         +Ax4JTRQyeDmbYx9GDEa8+6CnXgt1rqkhN4XQVB+o34BLpdp9dyWhGKPjaKQxCtQTv
         eFumPW+g5aoCrHWa3frlff+fWXW6GsUpHJUMVywA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 271/671] bus: ti-sysc: Fix sysc_unprepare() when no clocks have been allocated
Date:   Thu, 16 Jan 2020 11:58:29 -0500
Message-Id: <20200116170509.12787-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit aaa29bb01cc4bf5a87dbdb219efba3b09f259d8e ]

If we return early before ddata->clocks have been allocated we will get a
NULL pointer dereference in sysc_unprepare(). Let's fix this by returning
early when no clocks are allocated.

Fixes: 0eecc636e5a2 ("bus: ti-sysc: Add minimal TI sysc interconnect target driver")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 2813f9ed57c0..54c8c8644df2 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1400,6 +1400,9 @@ static void sysc_unprepare(struct sysc *ddata)
 {
 	int i;
 
+	if (!ddata->clocks)
+		return;
+
 	for (i = 0; i < SYSC_MAX_CLOCKS; i++) {
 		if (!IS_ERR_OR_NULL(ddata->clocks[i]))
 			clk_unprepare(ddata->clocks[i]);
-- 
2.20.1

