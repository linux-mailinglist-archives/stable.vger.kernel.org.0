Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB8E14B9F1
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbgA1OXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731395AbgA1OXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:23:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72FF921739;
        Tue, 28 Jan 2020 14:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221390;
        bh=lBK6d0D+N3IVETzNEOxlFQv92qi85SKaeOxJzbSKrl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYIkEIQeIP+EvqCcpCl5ZfJQbTk38HlMzGZZfMQDmqwNCR7r7COkDaQMj6SQRykIG
         yNSkKmU3UngBqvGW3MJl14pGz0d7Td2f82/uyLur38Avd03JluYGMoCpNsX38qsBST
         NT/8s53ajinR8xg5xWQz4yekPTjw0rB2M29db1xU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuansheng Liu <chuansheng.liu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 188/271] ahci: Do not export local variable ahci_em_messages
Date:   Tue, 28 Jan 2020 15:05:37 +0100
Message-Id: <20200128135906.565874802@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
index f233ce60a6781..1610fff19bb39 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -190,7 +190,6 @@ struct ata_port_operations ahci_pmp_retry_srst_ops = {
 EXPORT_SYMBOL_GPL(ahci_pmp_retry_srst_ops);
 
 static bool ahci_em_messages __read_mostly = true;
-EXPORT_SYMBOL_GPL(ahci_em_messages);
 module_param(ahci_em_messages, bool, 0444);
 /* add other LED protocol types when they become supported */
 MODULE_PARM_DESC(ahci_em_messages,
-- 
2.20.1



