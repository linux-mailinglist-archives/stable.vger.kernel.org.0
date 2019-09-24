Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA64BBCF1B
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411186AbfIXQvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411183AbfIXQvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:51:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668F621BE5;
        Tue, 24 Sep 2019 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343912;
        bh=AA3UGzytwFlaFFB0h7c09QGX5TW/ljwxPmgI+tY/N1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vbzxa/G31eEHHjkEUNbYpjDCqNeoZ6uLi4Y+q+Jpkvbb8IPC70vQEG58XceKFr6Ab
         kyRuPVGDmNeaLIgevWTv+1Fkb/0eHhVhOLCY/4wErIGN3CJ/6HQsRGlJH178RJTwUa
         3qmFHdgtsGICgfNH0HXps+nUO6CJ633AjJKxGFz0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 11/19] powerpc/pseries/mobility: use cond_resched when updating device tree
Date:   Tue, 24 Sep 2019 12:51:22 -0400
Message-Id: <20190924165130.28625-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924165130.28625-1-sashal@kernel.org>
References: <20190924165130.28625-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3784a7abfcc80..74791e8382d22 100644
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

