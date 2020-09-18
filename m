Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED3C26F336
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgIRCEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbgIRCEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8C4823119;
        Fri, 18 Sep 2020 02:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394669;
        bh=9IqLsNCTVBVXseTgonF0WbfTdJQzI6mPYtBikZU3Pv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwdSL9CgP4iiTt6dtSkQ3I+EVhoDMWoRbGGFtYzNvn2k3uRxLs/ORhKJlMyOC6mFL
         EeXt/q0ir2/6XDiSAZyoPu5+fzrFnTaDsCFvdYFGST0xTymTtzekiM4/C4M07pfSz7
         zjBYD5vyETznGEXkuKnXO/nmn3iCEjHDqMhRNMp4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zeng Tao <prime.zeng@hisilicon.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 162/330] cpu-topology: Fix the potential data corruption
Date:   Thu, 17 Sep 2020 21:58:22 -0400
Message-Id: <20200918020110.2063155-162-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zeng Tao <prime.zeng@hisilicon.com>

[ Upstream commit 4a33691c4cea9eb0a7c66e87248be4637e14b180 ]

Currently there are only 10 bytes to store the cpu-topology 'name'
information. Only 10 bytes copied into cluster/thread/core names.

If the cluster ID exceeds 2-digit number, it will result in the data
corruption, and ending up in a dead loop in the parsing routines. The
same applies to the thread names with more that 3-digit number.

This issue was found using the boundary tests under virtualised
environment like QEMU.

Let us increase the buffer to fix such potential issues.

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>

Link: https://lore.kernel.org/r/1583294092-5929-1-git-send-email-prime.zeng@hisilicon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/arch_topology.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
index 1eb81f113786f..83e26fd188cc9 100644
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -270,7 +270,7 @@ static int __init get_cpu_for_node(struct device_node *node)
 static int __init parse_core(struct device_node *core, int package_id,
 			     int core_id)
 {
-	char name[10];
+	char name[20];
 	bool leaf = true;
 	int i = 0;
 	int cpu;
@@ -317,7 +317,7 @@ static int __init parse_core(struct device_node *core, int package_id,
 
 static int __init parse_cluster(struct device_node *cluster, int depth)
 {
-	char name[10];
+	char name[20];
 	bool leaf = true;
 	bool has_cores = false;
 	struct device_node *c;
-- 
2.25.1

