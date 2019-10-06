Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C82FCD3FD
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfJFRVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfJFRVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:21:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17AC72077B;
        Sun,  6 Oct 2019 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382468;
        bh=LuGaAk8dxLEJhNh5nwVA5StYwKCJHKTuddQbelm7ZxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKg6nEodhEW0iL9NEd78Wu7lbMHkteL4jyp2Nrexybaxut6ixBeaAwxMdard7tcph
         OrqKtFCcSfK6yY7e3SnjUdYD5Xzrc4w2P6Xnz0eovvB2xLavLiInHdCNOBKx3i7Azo
         DMi4RbRSlC87NEckt6xvKwALfCZCfv2UwBIsblwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 08/36] powerpc/pseries/mobility: use cond_resched when updating device tree
Date:   Sun,  6 Oct 2019 19:18:50 +0200
Message-Id: <20191006171045.639649064@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171038.266461022@linuxfoundation.org>
References: <20191006171038.266461022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit ccfb5bd71d3d1228090a8633800ae7cdf42a94ac ]

After a partition migration, pseries_devicetree_update() processes
changes to the device tree communicated from the platform to
Linux. This is a relatively heavyweight operation, with multiple
device tree searches, memory allocations, and conversations with
partition firmware.

There's a few levels of nested loops which are bounded only by
decisions made by the platform, outside of Linux's control, and indeed
we have seen RCU stalls on large systems while executing this call
graph. Use cond_resched() in these loops so that the cpu is yielded
when needed.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190802192926.19277-4-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/mobility.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index c773396d0969b..8d30a425a88ab 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -11,6 +11,7 @@
 
 #include <linux/kernel.h>
 #include <linux/kobject.h>
+#include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/stat.h>
 #include <linux/completion.h>
@@ -206,7 +207,11 @@ static int update_dt_node(__be32 phandle, s32 scope)
 
 				prop_data += vd;
 			}
+
+			cond_resched();
 		}
+
+		cond_resched();
 	} while (rtas_rc == 1);
 
 	of_node_put(dn);
@@ -282,8 +287,12 @@ int pseries_devicetree_update(s32 scope)
 					add_dt_node(phandle, drc_index);
 					break;
 				}
+
+				cond_resched();
 			}
 		}
+
+		cond_resched();
 	} while (rc == 1);
 
 	kfree(rtas_buf);
-- 
2.20.1



