Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E0413E15B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgAPQtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:49:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730106AbgAPQtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:49:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53248207FF;
        Thu, 16 Jan 2020 16:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193346;
        bh=QQYpEbf31hkSDbiEAbjq25eEmaC/NfNiXzP4hhLzfbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slirQ+xSx4WcXQ5fDsMGv4JOicFULjoxvqok/p2OTUwRD/D8w+CEtDtYhF38OAo6d
         KVlHOrA6odxibLlvQN6Nitvam2P4xXbaNRm4Wp44OsYQkMnAGezqYm4xlQ7IJWxzPY
         SKeqPRW2z6+LzSZ1BN1uNH9Sy5k2WjlX5TEAaReM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hewenliang <hewenliang4@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 079/205] tools: PCI: Fix fd leakage
Date:   Thu, 16 Jan 2020 11:40:54 -0500
Message-Id: <20200116164300.6705-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hewenliang <hewenliang4@huawei.com>

[ Upstream commit 3c379a59b4795d7279d38c623e74b9790345a32b ]

We should close fd before the return of run_test.

Fixes: 3f2ed8134834 ("tools: PCI: Add a userspace tool to test PCI endpoint")
Signed-off-by: Hewenliang <hewenliang4@huawei.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/pci/pcitest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/pci/pcitest.c b/tools/pci/pcitest.c
index cb1e51fcc84e..32b7c6f9043d 100644
--- a/tools/pci/pcitest.c
+++ b/tools/pci/pcitest.c
@@ -129,6 +129,7 @@ static int run_test(struct pci_test *test)
 	}
 
 	fflush(stdout);
+	close(fd);
 	return (ret < 0) ? ret : 1 - ret; /* return 0 if test succeeded */
 }
 
-- 
2.20.1

