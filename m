Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6559929C65F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1826117AbgJ0SQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:16:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756206AbgJ0OMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:12:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE623218AC;
        Tue, 27 Oct 2020 14:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807915;
        bh=0mN8TmZOcC4Y0B6sUPhKksNVA2GHXtJ7Blbbkn+Cw+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdRg0ZV//jusfY/G9X6tqBLSfZ24wJeipWWxPqB/VpwilDrSUC5LH9+E7mL3SzTUg
         Yh/9+Yznzz4pov+3ZdnhbkNr+UWgpJN/AScIS1+WyeqKpzQOZHgBqpO6aE94CQTuhV
         AU7PRIyPPJmpkNbl5Q4AoLAilv+bhiHFqDk7KWtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 088/191] powerpc/icp-hv: Fix missing of_node_put() in success path
Date:   Tue, 27 Oct 2020 14:49:03 +0100
Message-Id: <20201027134913.923916173@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Mc Guire <hofrat@osadl.org>

[ Upstream commit d3e669f31ec35856f5e85df9224ede5bdbf1bc7b ]

Both of_find_compatible_node() and of_find_node_by_type() will return
a refcounted node on success - thus for the success path the node must
be explicitly released with a of_node_put().

Fixes: 0b05ac6e2480 ("powerpc/xics: Rewrite XICS driver")
Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1530691407-3991-1-git-send-email-hofrat@osadl.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xics/icp-hv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/xics/icp-hv.c b/arch/powerpc/sysdev/xics/icp-hv.c
index bbc839a98c414..003deaabb5680 100644
--- a/arch/powerpc/sysdev/xics/icp-hv.c
+++ b/arch/powerpc/sysdev/xics/icp-hv.c
@@ -179,6 +179,7 @@ int icp_hv_init(void)
 
 	icp_ops = &icp_hv_ops;
 
+	of_node_put(np);
 	return 0;
 }
 
-- 
2.25.1



