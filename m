Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8885E26B462
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgIOXXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgIOOiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51BEA22461;
        Tue, 15 Sep 2020 14:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180071;
        bh=Ksq4dw/hBZ7qlimcLtq60uVBWjdmHx2hSo0wkPFMcb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKvJyqU4mHP6rR2uZxbwQmQxEk6fC/WowNkunEqrN4ZFv9QmNZdcbiOGBkiSUOV6R
         h6zDfn98xScSVJrbQmWzQ0jsyvfz564TNfzVYBmg6QKnuLV4+Huf+UWSoXDq1tHmQj
         v7VU60lBbh3fIBtc3liRLHHw+fDp6jzJOu6+pTRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 098/177] cpufreq: intel_pstate: Refuse to turn off with HWP enabled
Date:   Tue, 15 Sep 2020 16:12:49 +0200
Message-Id: <20200915140658.339427633@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
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
index 8c730a47e0537..97ed4fd0f1342 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2534,9 +2534,15 @@ static int intel_pstate_update_status(const char *buf, size_t size)
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



