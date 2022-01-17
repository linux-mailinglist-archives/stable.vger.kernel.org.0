Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0285E490E35
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbiAQRIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:08:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50320 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241816AbiAQRGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:06:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E53AB8113E;
        Mon, 17 Jan 2022 17:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E0FC36AE7;
        Mon, 17 Jan 2022 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439159;
        bh=GLtLK6jPA6nPtqriz3ZVOeIfZ5OpRTdv6BTEh612+3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYKxXsbWFC5b0f/ekusOQv0hFnqgazfb9VHSNY0a3mhTQliyZkfPSuPqAv1n0MS3q
         OoP+mq4LOfTvTizu1La5o/89hxbHq2kMEwsB/XtnaK3CntPPJ0bvxJGLz5r6mLn0bG
         TCuZuo/dFD/A9k9ncuf98b4E9Mc/SKA+tcx9ZdcgFXJQXYn7nhMB21YRdZ+xxd5vcm
         5L0vOpR9CM6HVTk8utJ2YLIBa2pt1RLny0NSCndhXyvuZaywDxsE0q1lvkwdF6HXov
         HS7XmztAfyFP40FyQrZMiayl9krGvX9IR2N2ujVlcxq2qw8WS5Rfag/CHqWIoxHEBN
         6cP9Mplywkz/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, aneesh.kumar@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 03/17] powerpc/powernv: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:05:37 -0500
Message-Id: <20220117170551.1472640-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170551.1472640-1-sashal@kernel.org>
References: <20220117170551.1472640-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

[ Upstream commit 7d405a939ca960162eb30c1475759cb2fdf38f8c ]

for_each_compatible_node performs an of_node_get on each iteration, so
a break out of the loop requires an of_node_put.

A simplified version of the semantic patch that fixes this problem is as
follows (http://coccinelle.lip6.fr):

// <smpl>
@@
local idexpression n;
expression e;
@@

 for_each_compatible_node(n,...) {
   ...
(
   of_node_put(n);
|
   e = n
|
+  of_node_put(n);
?  break;
)
   ...
 }
... when != n
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1448051604-25256-4-git-send-email-Julia.Lawall@lip6.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-lpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/powernv/opal-lpc.c b/arch/powerpc/platforms/powernv/opal-lpc.c
index 6c7ad1d8b32ed..21f0edcfb84ad 100644
--- a/arch/powerpc/platforms/powernv/opal-lpc.c
+++ b/arch/powerpc/platforms/powernv/opal-lpc.c
@@ -400,6 +400,7 @@ void __init opal_lpc_init(void)
 		if (!of_get_property(np, "primary", NULL))
 			continue;
 		opal_lpc_chip_id = of_get_ibm_chip_id(np);
+		of_node_put(np);
 		break;
 	}
 	if (opal_lpc_chip_id < 0)
-- 
2.34.1

