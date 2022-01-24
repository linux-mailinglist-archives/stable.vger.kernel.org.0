Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE18498D89
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347471AbiAXTdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:33:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57822 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352737AbiAXTa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:30:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B29E61451;
        Mon, 24 Jan 2022 19:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AECC340E5;
        Mon, 24 Jan 2022 19:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052658;
        bh=VH00fZM9pyIofkfidA394IRA/tvTVzVfdo6kQGUBlR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qh9JH5MIwkZymtv/x2RWoVzxzntiO9J590bQ8OwuN/NQE8nNgTt/IAM6IkoXJuAqr
         Ov34oI3i9ahbNKuf36XrC5bZTLR4KmaCL6jiR6OAbOsi7HEa0DRagvAK5ejM7PALwN
         NS5puPIAGq1SWeO9ki/LDmQkoS4Rmc1npFCbi7eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/320] pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in __nonstatic_find_io_region()
Date:   Mon, 24 Jan 2022 19:41:23 +0100
Message-Id: <20220124183957.089588188@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit ca0fe0d7c35c97528bdf621fdca75f13157c27af ]

In __nonstatic_find_io_region(), pcmcia_make_resource() is assigned to
res and used in pci_bus_alloc_resource(). There is a dereference of res
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
[linux@dominikbrodowski.net: Fix typo in commit message]
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/rsrc_nonstatic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 9e6922c08ef62..03ae998675e87 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -690,6 +690,9 @@ static struct resource *__nonstatic_find_io_region(struct pcmcia_socket *s,
 	unsigned long min = base;
 	int ret;
 
+	if (!res)
+		return NULL;
+
 	data.mask = align - 1;
 	data.offset = base & data.mask;
 	data.map = &s_data->io_db;
-- 
2.34.1



