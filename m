Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783E026B73E
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgIPATW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726699AbgIOOV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:21:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F05722269;
        Tue, 15 Sep 2020 14:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179448;
        bh=yIAvXqRVCq8N4lZORLQkIWGnBNfFq5xU/oishvzzp8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkxvgI7u6h807GW2HQc4BdWu2+lAO/u48T6B2nZO1JrrrOddoY7iDqB5IGaD2UGBY
         h+LUYgAbvZBPj8Lo/9ZbqrDOSkUQr/aEUNENkPhINCMilfA2T+vMxJ+ykqgf6lRDpk
         S7EzBoeD84HPJhNxYjKLDRkurR1qwFZnUvvdp9FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/78] cpufreq: intel_pstate: Refuse to turn off with HWP enabled
Date:   Tue, 15 Sep 2020 16:12:59 +0200
Message-Id: <20200915140635.281487012@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 43298db3009f06fe5c69e1ca8b6cfc2565772fa1 ]

After commit f6ebbcf08f37 ("cpufreq: intel_pstate: Implement passive
mode with HWP enabled") it is possible to change the driver status
to "off" via sysfs with HWP enabled, which effectively causes the
driver to unregister itself, but HWP remains active and it forces the
minimum performance, so even if another cpufreq driver is loaded,
it will not be able to control the CPU frequency.

For this reason, make the driver refuse to change the status to
"off" with HWP enabled.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 99166000ffb77..8fa22aa2ac65b 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2325,9 +2325,15 @@ static int intel_pstate_update_status(const char *buf, size_t size)
 {
 	int ret;
 
-	if (size == 3 && !strncmp(buf, "off", size))
-		return intel_pstate_driver ?
-			intel_pstate_unregister_driver() : -EINVAL;
+	if (size == 3 && !strncmp(buf, "off", size)) {
+		if (!intel_pstate_driver)
+			return -EINVAL;
+
+		if (hwp_active)
+			return -EBUSY;
+
+		return intel_pstate_unregister_driver();
+	}
 
 	if (size == 6 && !strncmp(buf, "active", size)) {
 		if (intel_pstate_driver) {
-- 
2.25.1



