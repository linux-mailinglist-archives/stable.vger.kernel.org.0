Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC7E27C8B4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgI2MEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728647AbgI2Lic (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BEED21D46;
        Tue, 29 Sep 2020 11:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379488;
        bh=9IqLsNCTVBVXseTgonF0WbfTdJQzI6mPYtBikZU3Pv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sxx8ybumMM/F3852Yt4pxFQk+RyYPr/8vNxs9cd05jD2LbYVxLQMSxKSTQh4gfNZq
         zJc1TF0tvZB1SikI5k1oiDE0jp9Q4Ux6l243EINkBdGunZwowrOafPkVZYPlg+Oumk
         /oxKrrJOYDkDKfEIWI3BAZsPph14DfHM/jAEgr9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Zeng Tao <prime.zeng@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 156/388] cpu-topology: Fix the potential data corruption
Date:   Tue, 29 Sep 2020 12:58:07 +0200
Message-Id: <20200929110018.026851970@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



