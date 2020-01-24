Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 088F31482B7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404185AbgAXLaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:30:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404162AbgAXLaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:30:10 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6E95206D4;
        Fri, 24 Jan 2020 11:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865409;
        bh=0sWVLojeXDKp609NbBVtEg9rtYTBS9YwV5znCwMXvhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1ouItwzzeOd2LH+sInimXhTjCM0etY9kV5TUZ+FAoz60ne+S8dqkQQxsHaRtKT4A
         LQ23UnsTzhpIc52YXrpSBw4M2kbROVXBdvIQ6F8Rnaim40TjdAHs8ZiteZhIzBM1qa
         EXFpoCSX7V6Y55YBrvxG+HeiVLieP4whzoD4c90Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuansheng Liu <chuansheng.liu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 525/639] ahci: Do not export local variable ahci_em_messages
Date:   Fri, 24 Jan 2020 10:31:35 +0100
Message-Id: <20200124093154.566272768@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 60fc35f327e0a9e60b955c0f3c3ed623608d1baa ]

The commit ed08d40cdec4
  ("ahci: Changing two module params with static and __read_mostly")
moved ahci_em_messages to be static while missing the fact of exporting it.

WARNING: "ahci_em_messages" [vmlinux] is a static EXPORT_SYMBOL_GPL

Drop export for the local variable ahci_em_messages.

Fixes: ed08d40cdec4 ("ahci: Changing two module params with static and __read_mostly")
Cc: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index b5f57c69c4878..2bdb250a2142c 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -191,7 +191,6 @@ struct ata_port_operations ahci_pmp_retry_srst_ops = {
 EXPORT_SYMBOL_GPL(ahci_pmp_retry_srst_ops);
 
 static bool ahci_em_messages __read_mostly = true;
-EXPORT_SYMBOL_GPL(ahci_em_messages);
 module_param(ahci_em_messages, bool, 0444);
 /* add other LED protocol types when they become supported */
 MODULE_PARM_DESC(ahci_em_messages,
-- 
2.20.1



