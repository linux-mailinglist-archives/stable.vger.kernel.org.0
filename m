Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6324029B20E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898976AbgJ0Oha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761000AbgJ0OhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:37:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4C7B222E9;
        Tue, 27 Oct 2020 14:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809445;
        bh=2lf4uteV6LmPGW8kJ4FDcqRiQ4UcrmxFVigvV/E+Bqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkqPBzFGSx8O+hYEWv3+oqJ8o+ItZp5cE0vnWoGLKz7SGuutWY6a7EmvtfnijRkQV
         rtnPC+sTMLeYDCL7ZcNh7vy06RDIZmtFq27gszMpqryTYrfqFJZrlUO+d4t3abzNfL
         H34e5bPI8TgZUSueq/TOoJ3ywCEYzsE0Xrohp7dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 199/408] powerpc/pseries: Fix missing of_node_put() in rng_init()
Date:   Tue, 27 Oct 2020 14:52:17 +0100
Message-Id: <20201027135504.331770922@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Mc Guire <hofrat@osadl.org>

[ Upstream commit 67c3e59443f5fc77be39e2ce0db75fbfa78c7965 ]

The call to of_find_compatible_node() returns a node pointer with
refcount incremented thus it must be explicitly decremented here
before returning.

Fixes: a489043f4626 ("powerpc/pseries: Implement arch_get_random_long() based on H_RANDOM")
Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1530522496-14816-1-git-send-email-hofrat@osadl.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/pseries/rng.c b/arch/powerpc/platforms/pseries/rng.c
index bbb97169bf63e..6268545947b83 100644
--- a/arch/powerpc/platforms/pseries/rng.c
+++ b/arch/powerpc/platforms/pseries/rng.c
@@ -36,6 +36,7 @@ static __init int rng_init(void)
 
 	ppc_md.get_random_seed = pseries_get_random_long;
 
+	of_node_put(dn);
 	return 0;
 }
 machine_subsys_initcall(pseries, rng_init);
-- 
2.25.1



