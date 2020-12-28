Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE6F2E3E0A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439195AbgL1OW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502762AbgL1OWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED4CC2245C;
        Mon, 28 Dec 2020 14:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165358;
        bh=5d7w9lovCIOz+fYs0nVFZDisyzEndXwaN1+vXq6RX2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrtjyk6tj7UiLNCkWIm9tWcQuFxLQ8wG5tdA+UsVuzsW+QZIPfz3/+nPaWBIwAUx2
         2XNzFywZ80bv13yYb0blUC7ysrAsCrt7UXA3gQXjp5k4wfCmQrI9z5CiubK2+MEcyR
         Z5ilQN0AGnvIpBt5SkqjV1vWN7P78nrZHOKn2QGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 502/717] powerpc/smp: Add __init to init_big_cores()
Date:   Mon, 28 Dec 2020 13:48:20 +0100
Message-Id: <20201228125045.008191962@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

[ Upstream commit 9014eab6a38c60fd185bc92ed60f46cf99a462ab ]

It fixes this link warning:

WARNING: modpost: vmlinux.o(.text.unlikely+0x2d98): Section mismatch in reference from the function init_big_cores.isra.0() to the function .init.text:init_thread_group_cache_map()
The function init_big_cores.isra.0() references
the function __init init_thread_group_cache_map().
This is often because init_big_cores.isra.0 lacks a __init
annotation or the annotation of init_thread_group_cache_map is wrong.

Fixes: 425752c63b6f ("powerpc: Detect the presence of big-cores via "ibm, thread-groups"")
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201221074154.403779-1-clg@kaod.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 8c2857cbd9609..7d6cf75a7fd80 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -919,7 +919,7 @@ static struct sched_domain_topology_level powerpc_topology[] = {
 	{ NULL, },
 };
 
-static int init_big_cores(void)
+static int __init init_big_cores(void)
 {
 	int cpu;
 
-- 
2.27.0



