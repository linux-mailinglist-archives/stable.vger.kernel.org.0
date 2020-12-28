Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EF02E41BE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438304AbgL1OHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438069AbgL1OG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8149207B2;
        Mon, 28 Dec 2020 14:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164372;
        bh=yO7XlJK6PxR3jEhS1nQaNQfybxn9MgVaZEpaERMEYQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBLJ0cdIbZxrqYBZD7NGwJwY1KUGk4J78FOCncKMu0aObjQTfY2Fo5DK7bLyG1zqs
         5dPw2cdMHa/eQECGIhUdUTRTTOZD3ragxDP67q2kSoOy0t+C812r90qa2WQvfmmOA6
         Q7I4qAfbLIXuD+28uJZTbQvCJ9Q21W/BJc2j4LPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/717] Revert "powerpc/pseries/hotplug-cpu: Remove double free in error path"
Date:   Mon, 28 Dec 2020 13:42:36 +0100
Message-Id: <20201228125028.526401174@linuxfoundation.org>
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

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit a40fdaf1420d6e6bda0dd2df1e6806013e58dbe1 ]

This reverts commit a0ff72f9f5a780341e7ff5e9ba50a0dad5fa1980.

Since the commit b015f6bc9547 ("powerpc/pseries: Add cpu DLPAR
support for drc-info property"), the 'cpu_drcs' wouldn't be double
freed when the 'cpus' node not found.

So we needn't apply this patch, otherwise, the memory will be leaked.

Fixes: a0ff72f9f5a7 ("powerpc/pseries/hotplug-cpu: Remove double free in error path")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
[mpe: Caused by me applying a patch to a function that had changed in the interim]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201111020752.1686139-1-zhangxiaoxu5@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/hotplug-cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index a02012f1b04af..12cbffd3c2e32 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -746,6 +746,7 @@ static int dlpar_cpu_add_by_count(u32 cpus_to_add)
 	parent = of_find_node_by_path("/cpus");
 	if (!parent) {
 		pr_warn("Could not find CPU root node in device tree\n");
+		kfree(cpu_drcs);
 		return -1;
 	}
 
-- 
2.27.0



