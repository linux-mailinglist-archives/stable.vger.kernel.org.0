Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558A1101821
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfKSFfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:35:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbfKSFfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD77B20862;
        Tue, 19 Nov 2019 05:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141745;
        bh=COVWsDCNKbR38Yw+05vHLBxceN6cUCoS+2GIdiYO/IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCiTWyp0g4/jRW1HfbRpPopYZVaePxioQFuQlh00dkaOmad/K0S9J15hF9UG0D2yC
         FWJ93OGksyYATiookJyEtHOWbXnA6vMwlKfUJpKB7dl2lplvoQdjDArkkV413VHyD2
         vp/IQ9oaFo5YheqqKO33sLZmM1l4y1NHPw5SQEK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Tyrel Datwyler <tyreld@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 264/422] powerpc/pseries: Disable CPU hotplug across migrations
Date:   Tue, 19 Nov 2019 06:17:41 +0100
Message-Id: <20191119051416.098423218@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9e41a9de43235..95d1264ba7952 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -985,6 +985,7 @@ int rtas_ibm_suspend_me(u64 handle)
 		goto out;
 	}
 
+	cpu_hotplug_disable();
 	stop_topology_update();
 
 	/* Call function on all CPUs.  One of us will make the
@@ -999,6 +1000,7 @@ int rtas_ibm_suspend_me(u64 handle)
 		printk(KERN_ERR "Error doing global join\n");
 
 	start_topology_update();
+	cpu_hotplug_enable();
 
 	/* Take down CPUs not online prior to suspend */
 	cpuret = rtas_offline_cpus_mask(offline_mask);
-- 
2.20.1



