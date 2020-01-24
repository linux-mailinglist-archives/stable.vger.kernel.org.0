Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C09E147ADB
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgAXJiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731011AbgAXJis (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:38:48 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADDD22070A;
        Fri, 24 Jan 2020 09:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858727;
        bh=LOftzmFmMjrBTzG1Cj4Sc3+SmTlPAvpQNktW/WX9woE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/kLA/XP/wbfPNOeAhGjHhq1pM7vW3UDp/hUScgMNKcsIgLZSzdS68FjC9N9rxWkZ
         kaI27vQ8aGXI9oWUbA1rKSf/oGBYvN/x77jXaiXjkpZi/ziB1azC/5iq69vxnrI6qk
         JKLlBrLs0RRSwqjRAmM1el6zGqEekMDTRcYaoU78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.4 043/102] soc: renesas: Add missing check for non-zero product register address
Date:   Fri, 24 Jan 2020 10:30:44 +0100
Message-Id: <20200124092812.793092570@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 4194b583c104922c6141d6610bfbce26847959df upstream.

If the DTB for a device with an RZ/A2 SoC lacks a device node for the
BSID register, the ID validation code falls back to using a register at
address 0x0, which leads to undefined behavior (e.g. reading back a
random value).

This could be fixed by letting fam_rza2.reg point to the actual BSID
register.  However, the hardcoded fallbacks were meant for backwards
compatibility with old DTBs only, not for new SoCs.  Hence fix this by
validating renesas_family.reg before using it.

Fixes: 175f435f44b724e3 ("soc: renesas: identify RZ/A2")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20191016143306.28995-1-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/renesas/renesas-soc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/renesas/renesas-soc.c
+++ b/drivers/soc/renesas/renesas-soc.c
@@ -326,7 +326,7 @@ static int __init renesas_soc_init(void)
 	if (np) {
 		chipid = of_iomap(np, 0);
 		of_node_put(np);
-	} else if (soc->id) {
+	} else if (soc->id && family->reg) {
 		chipid = ioremap(family->reg, 4);
 	}
 	if (chipid) {


