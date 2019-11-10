Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8286FF633E
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbfKJCun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:50:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbfKJCun (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:50:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B109B22790;
        Sun, 10 Nov 2019 02:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354242;
        bh=f2b0CWoNoQ9ioQs7219fTotOnawLUs/soilupI9ggGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsHFi5ynj2FGKdcWDGKksww5h35OFaEltf+TobHtScsMJAHXxkIdYRYGGq2wb9fOv
         /eAZeth1eIEsM0kP2qhpJBijAQFLU7O69nFnE04W18QxF65M0/7p6TkM+0dVClfFJE
         bddc621N0sQotfA9zX2rOUYd8vA+eCxpfMlFBCe0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Tyrel Datwyler <tyreld@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 06/40] powerpc/pseries: Disable CPU hotplug across migrations
Date:   Sat,  9 Nov 2019 21:49:58 -0500
Message-Id: <20191110025032.827-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110025032.827-1-sashal@kernel.org>
References: <20191110025032.827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Fontenot <nfont@linux.vnet.ibm.com>

[ Upstream commit 85a88cabad57d26d826dd94ea34d3a785824d802 ]

When performing partition migrations all present CPUs must be online
as all present CPUs must make the H_JOIN call as part of the migration
process. Once all present CPUs make the H_JOIN call, one CPU is returned
to make the rtas call to perform the migration to the destination system.

During testing of migration and changing the SMT state we have found
instances where CPUs are offlined, as part of the SMT state change,
before they make the H_JOIN call. This results in a hung system where
every CPU is either in H_JOIN or offline.

To prevent this this patch disables CPU hotplug during the migration
process.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 0c42e872d548b..4fcaa7d3d544f 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -967,6 +967,7 @@ int rtas_ibm_suspend_me(u64 handle)
 		goto out;
 	}
 
+	cpu_hotplug_disable();
 	stop_topology_update();
 
 	/* Call function on all CPUs.  One of us will make the
@@ -981,6 +982,7 @@ int rtas_ibm_suspend_me(u64 handle)
 		printk(KERN_ERR "Error doing global join\n");
 
 	start_topology_update();
+	cpu_hotplug_enable();
 
 	/* Take down CPUs not online prior to suspend */
 	cpuret = rtas_offline_cpus_mask(offline_mask);
-- 
2.20.1

