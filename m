Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DE9247572
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731938AbgHQTXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730449AbgHQPfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:35:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCBB023128;
        Mon, 17 Aug 2020 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678503;
        bh=QNi9gv+rf5slUxfdHR740fYbHA5xhV8irPouXkkHkWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwKLRa4a+D1udlgs+Rkfb4YxvLSbaYDVt6ciNb5VjYUmTlAnSMb7jwL04IQ5ZUqIh
         0yjosWsySJZX9GNhdbG8qevHZDek4uzTSMr1fO+ioFUA+84YM5B6TfojKjq1KqOgWu
         m9iXjGu5BPzk6KR3rDSDAk7LfNb32U3+ZPcWLuAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 325/464] powerpc/pseries/hotplug-cpu: Remove double free in error path
Date:   Mon, 17 Aug 2020 17:14:38 +0200
Message-Id: <20200817143849.360812255@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit a0ff72f9f5a780341e7ff5e9ba50a0dad5fa1980 ]

In the unlikely event that the device tree lacks a /cpus node,
find_dlpar_cpus_to_add() oddly frees the cpu_drcs buffer it has been
passed before returning an error. Its only caller also frees the
buffer on error.

Remove the less conventional kfree() of a caller-supplied buffer from
find_dlpar_cpus_to_add().

Fixes: 90edf184b9b7 ("powerpc/pseries: Add CPU dlpar add functionality")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190919231633.1344-1-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/hotplug-cpu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index d4b346355bb9e..6d4ee03d476a9 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -739,7 +739,6 @@ static int dlpar_cpu_add_by_count(u32 cpus_to_add)
 	parent = of_find_node_by_path("/cpus");
 	if (!parent) {
 		pr_warn("Could not find CPU root node in device tree\n");
-		kfree(cpu_drcs);
 		return -1;
 	}
 
-- 
2.25.1



