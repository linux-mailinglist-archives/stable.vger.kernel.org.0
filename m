Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCB62F612
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbfE3Eww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728206AbfE3DKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:45 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 295CF244A6;
        Thu, 30 May 2019 03:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185844;
        bh=LCZkWgDuFmWLSsdjeSQDEqtDxwJ0omcPCF8Y+U4/vnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdHwJ/h9NYmRkolHlFtLYJGU2ogu9wkW5s9UoOfLrLrPEqgEI3l5HCb38uqk9jODa
         I8tlG3c7VKt0DRvUKubbbdMunaIEb1LGpr3ijBQ1zjfFbBRbg3QlEeFMEEbF801Con
         Zk/vxx0/QZZD5BroHjRmoEdb6M/kxLixFevzLzAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 163/405] powerpc/numa: improve control of topology updates
Date:   Wed, 29 May 2019 20:02:41 -0700
Message-Id: <20190530030549.381804175@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index f976676004ad0..48c9a97eb2c33 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1498,6 +1498,9 @@ int start_topology_update(void)
 {
 	int rc = 0;
 
+	if (!topology_updates_enabled)
+		return 0;
+
 	if (firmware_has_feature(FW_FEATURE_PRRN)) {
 		if (!prrn_enabled) {
 			prrn_enabled = 1;
@@ -1531,6 +1534,9 @@ int stop_topology_update(void)
 {
 	int rc = 0;
 
+	if (!topology_updates_enabled)
+		return 0;
+
 	if (prrn_enabled) {
 		prrn_enabled = 0;
 #ifdef CONFIG_SMP
@@ -1588,11 +1594,13 @@ static ssize_t topology_write(struct file *file, const char __user *buf,
 
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
@@ -1607,9 +1615,7 @@ static const struct file_operations topology_ops = {
 
 static int topology_update_init(void)
 {
-	/* Do not poll for changes if disabled at boot */
-	if (topology_updates_enabled)
-		start_topology_update();
+	start_topology_update();
 
 	if (vphn_enabled)
 		topology_schedule_update();
-- 
2.20.1



