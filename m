Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0062498C01
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347326AbiAXTS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:18:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45504 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343689AbiAXTQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:16:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF7A56131E;
        Mon, 24 Jan 2022 19:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE33C340E5;
        Mon, 24 Jan 2022 19:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051782;
        bh=FFc92ucDMk1pQ5zu/eaB0zb0C06jywc23rLv9Ce6chs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qAd2QmHKvqEZpJU+pt0u5MOMHeDsu4St9UlWL3O5/rgdU95VelllKkqsYTubYQcCC
         MgHJ3H1q+2PMQYUKzRqki1cM6SS4Pjrc0L08UJlvhQYOODE8p5SPNpN7IrIfHuufTz
         zYcd2wQlXZxsVd4Rc38QPDWobERZYWVyRLUR6Hn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/239] pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in nonstatic_find_mem_region()
Date:   Mon, 24 Jan 2022 19:42:04 +0100
Message-Id: <20220124183945.853766473@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit 977d2e7c63c3d04d07ba340b39987742e3241554 ]

In nonstatic_find_mem_region(), pcmcia_make_resource() is assigned to
res and used in pci_bus_alloc_resource(). There a dereference of res
in pci_bus_alloc_resource(), which could lead to a NULL pointer
dereference on failure of pcmcia_make_resource().

Fix this bug by adding a check of res.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_PCCARD_NONSTATIC=y show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: 49b1153adfe1 ("pcmcia: move all pcmcia_resource_ops providers into one module")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/rsrc_nonstatic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 5cb29d6951df2..123420cac6b54 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -815,6 +815,9 @@ static struct resource *nonstatic_find_mem_region(u_long base, u_long num,
 	unsigned long min, max;
 	int ret, i, j;
 
+	if (!res)
+		return NULL;
+
 	low = low || !(s->features & SS_CAP_PAGE_REGS);
 
 	data.mask = align - 1;
-- 
2.34.1



