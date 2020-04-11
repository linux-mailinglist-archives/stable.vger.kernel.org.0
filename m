Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9041A5A17
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbgDKXkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgDKXHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:07:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2883F20787;
        Sat, 11 Apr 2020 23:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646439;
        bh=bzCuW902nz0mB4MhiJs3S5FEoSQDKiLAcYzvLglFqcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvudUei5jgZC7Bbypwy3kOtgNUL7RI2eg6FFGSFntBguWcdD9gfGHmg7aDwM7rh/H
         4jKIw98dP2DkTTOzisb9x3WP4A+TCvK2XrHhQ8OLbye/PNVdlbbyy6NLRZXwv5y+fU
         s5TllrMmHuGDLgaea0s5pobwe/ywiYsnlotJnKl4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 011/121] tools/power/x86/intel-speed-select: Fix mailbox usage for CLOS_PM_QOS_CONFIG
Date:   Sat, 11 Apr 2020 19:05:16 -0400
Message-Id: <20200411230706.23855-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 8ddbda76245f5d10e00020db34455404019efc91 ]

Even for the products using MMIO, this message needs to be sent via
mail box. The previous fix done for this didn't properly address this.
That fix simply removed sending command via MMIO, but still didn't
trigger sending via mailbox.

Add additional condition to check for CLOS_PM_QOS_CONFIG, when MMIO
is supported on a platform.

Fixes: cd0e63706549 (tools/power/x86/intel-speed-select: Use mailbox for CLOS_PM_QOS_CONFIG)
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-config.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index 944183f9ed5a3..f7ad1c65c86e0 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -571,7 +571,8 @@ int isst_send_mbox_command(unsigned int cpu, unsigned char command,
 		"mbox_send: cpu:%d command:%x sub_command:%x parameter:%x req_data:%x\n",
 		cpu, command, sub_command, parameter, req_data);
 
-	if (isst_platform_info.mmio_supported && command == CONFIG_CLOS) {
+	if (isst_platform_info.mmio_supported && command == CONFIG_CLOS &&
+	    sub_command != CLOS_PM_QOS_CONFIG) {
 		unsigned int value;
 		int write = 0;
 		int clos_id, core_id, ret = 0;
-- 
2.20.1

