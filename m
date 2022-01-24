Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6789A498ADC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344286AbiAXTHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346179AbiAXTFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:05:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F48DC0401FA;
        Mon, 24 Jan 2022 10:59:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 495F6B81236;
        Mon, 24 Jan 2022 18:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7511CC340EA;
        Mon, 24 Jan 2022 18:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050772;
        bh=nRljK2iWbb10p4w6RFd1lQ40Hofhpav2Nn+BCIRYQ08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrdujnL5g8LcruFa6Euut5oINMfQgOoiCk2e+zLYAL0y7ArGK6iWDqwn6NLOggbYP
         CJD3cU6q1PUsk5rvRamJJPOSwDTkKI/tm9wqNVHUmf+8XIo6c0ILudAjx9Yn+jEp4g
         neRizVS0+ySoI0zH/i2rG2aXzggoxOhIaePw5BtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 106/157] powerpc/powernv: add missing of_node_put
Date:   Mon, 24 Jan 2022 19:43:16 +0100
Message-Id: <20220124183936.133978740@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e4169d68cb328..d28c4a9269c38 100644
--- a/arch/powerpc/platforms/powernv/opal-lpc.c
+++ b/arch/powerpc/platforms/powernv/opal-lpc.c
@@ -401,6 +401,7 @@ void opal_lpc_init(void)
 		if (!of_get_property(np, "primary", NULL))
 			continue;
 		opal_lpc_chip_id = of_get_ibm_chip_id(np);
+		of_node_put(np);
 		break;
 	}
 	if (opal_lpc_chip_id < 0)
-- 
2.34.1



