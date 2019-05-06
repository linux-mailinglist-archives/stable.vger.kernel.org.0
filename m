Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A20914F61
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfEFOeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:34:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbfEFOen (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D50921019;
        Mon,  6 May 2019 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153282;
        bh=DFszRYzucD78m3OF8MucKZz0JRnQTtcXGYMj7cOZpV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxvVkdM1Pct2Cutm7uwJneT3mD3Zoek5PMXtRArLLw48/RWDcdIVdpDZEYpAONBga
         t36BtBzC3uxslHJ6rBIZxX9nAP97BKzxNbLDqxYLwuUEtc9zknjPabKwKNQ+8XADzR
         flqcDZZSpy55+Pb1+m7Smt5feKq2loAwPtQEvyCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Tony Lindgren <tony@atomide.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 031/122] ARM: OMAP2+: add missing of_node_put after of_device_is_available
Date:   Mon,  6 May 2019 16:31:29 +0200
Message-Id: <20190506143057.589975291@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 30645307e5d2c8a4caf978558c66121ac91ad17e ]

Add an of_node_put when a tested device node is not available.

The semantic patch that fixes this problem is as follows
(http://coccinelle.lip6.fr):

// <smpl>
@@
identifier f;
local idexpression e;
expression x;
@@

e = f(...);
... when != of_node_put(e)
    when != x = e
    when != e = x
    when any
if (<+...of_device_is_available(e)...+>) {
  ... when != of_node_put(e)
(
  return e;
|
+ of_node_put(e);
  return ...;
)
}
// </smpl>

Fixes: e0c827aca0730 ("drm/omap: Populate DSS children in omapdss driver")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/arm/mach-omap2/display.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index 1444b4b4bd9f..439e143cad7b 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -250,8 +250,10 @@ static int __init omapdss_init_of(void)
 	if (!node)
 		return 0;
 
-	if (!of_device_is_available(node))
+	if (!of_device_is_available(node)) {
+		of_node_put(node);
 		return 0;
+	}
 
 	pdev = of_find_device_by_node(node);
 
-- 
2.20.1



