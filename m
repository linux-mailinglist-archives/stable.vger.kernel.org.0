Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824022EF5E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731850AbfE3DTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731842AbfE3DTP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:15 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5812485B;
        Thu, 30 May 2019 03:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186354;
        bh=NMR8XkAYPWsJ/K5GhX9u+yDhCHUQdXQsKDfAjWrPucM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4P64UudyFe8+svA7zhl4nqGKfRcusnXEqxmcmbrCtLioq9UsO+5Bi8GOebajRKTG
         91R2FZCkEq1OU81kKQdlVZ7wKTbwjcyHpmbySM4x2dZ1dbTLnNOGoPYWfMsGY2aZqD
         9Ocz4voPbCcS6iYi0U4K8A8Lmxn8j6MclcxHSoDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 096/193] powerpc/numa: improve control of topology updates
Date:   Wed, 29 May 2019 20:05:50 -0700
Message-Id: <20190530030502.378465760@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2d4d9b308f8f8dec68f6dbbff18c68ec7c6bd26f ]

When booted with "topology_updates=no", or when "off" is written to
/proc/powerpc/topology_updates, NUMA reassignments are inhibited for
PRRN and VPHN events. However, migration and suspend unconditionally
re-enable reassignments via start_topology_update(). This is
incoherent.

Check the topology_updates_enabled flag in
start/stop_topology_update() so that callers of those APIs need not be
aware of whether reassignments are enabled. This allows the
administrative decision on reassignments to remain in force across
migrations and suspensions.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/numa.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 0a02c73a27b3c..417ea6db7b1d2 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1561,6 +1561,9 @@ int start_topology_update(void)
 {
 	int rc = 0;
 
+	if (!topology_updates_enabled)
+		return 0;
+
 	if (firmware_has_feature(FW_FEATURE_PRRN)) {
 		if (!prrn_enabled) {
 			prrn_enabled = 1;
@@ -1590,6 +1593,9 @@ int stop_topology_update(void)
 {
 	int rc = 0;
 
+	if (!topology_updates_enabled)
+		return 0;
+
 	if (prrn_enabled) {
 		prrn_enabled = 0;
 #ifdef CONFIG_SMP
@@ -1635,11 +1641,13 @@ static ssize_t topology_write(struct file *file, const char __user *buf,
 
 	kbuf[read_len] = '\0';
 
-	if (!strncmp(kbuf, "on", 2))
+	if (!strncmp(kbuf, "on", 2)) {
+		topology_updates_enabled = true;
 		start_topology_update();
-	else if (!strncmp(kbuf, "off", 3))
+	} else if (!strncmp(kbuf, "off", 3)) {
 		stop_topology_update();
-	else
+		topology_updates_enabled = false;
+	} else
 		return -EINVAL;
 
 	return count;
@@ -1654,9 +1662,7 @@ static const struct file_operations topology_ops = {
 
 static int topology_update_init(void)
 {
-	/* Do not poll for changes if disabled at boot */
-	if (topology_updates_enabled)
-		start_topology_update();
+	start_topology_update();
 
 	if (!proc_create("powerpc/topology_updates", 0644, NULL, &topology_ops))
 		return -ENOMEM;
-- 
2.20.1



