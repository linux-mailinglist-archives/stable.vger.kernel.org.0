Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99774A8EEE
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355556AbiBCUkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355498AbiBCUh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:37:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0601DC061759;
        Thu,  3 Feb 2022 12:35:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99EBE61B16;
        Thu,  3 Feb 2022 20:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1656AC340FF;
        Thu,  3 Feb 2022 20:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920535;
        bh=P3qbYayGFjFb/gkQnpdVwoJRURSj299ER3xrYVzQ6Bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0ByiA5fN7R0qB0eo9AGhZYLFRBV5fe6KXgEu4NtLYYIxzreVL8vMt1TyJlM+YFI8
         2/4LsdqUB010xzEc8w0w7HGJ0tWk9Osk834e0q1ea3LXdIaoxAIjpceDtpF9n4nZ0a
         xfo9OeB8rhzQKlH11xuiroIKiRsLiYkIfZ0ciC8+BN4op37iHlpm5F4CsEAVLZ0jMj
         dlhB2A40ccgstR48cWzI+ZCsd4KrfGX26yxg6NxDNfl85GKERxbTRZqXQJnMxX9nTo
         XwevvLol3jS4m7++LbyIhGsoU6u90aNLCLC9zkP9c/T+4YAj8m74aBPc+SUAZEqYgo
         zfjrZ6ax5jThA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, hare@kernel.org,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/25] scsi: myrs: Fix crash in error case
Date:   Thu,  3 Feb 2022 15:34:40 -0500
Message-Id: <20220203203447.3570-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203447.3570-1-sashal@kernel.org>
References: <20220203203447.3570-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 4db09593af0b0b4d7d4805ebb3273df51d7cc30d ]

In myrs_detect(), cs->disable_intr is NULL when privdata->hw_init() fails
with non-zero. In this case, myrs_cleanup(cs) will call a NULL ptr and
crash the kernel.

[    1.105606] myrs 0000:00:03.0: Unknown Initialization Error 5A
[    1.105872] myrs 0000:00:03.0: Failed to initialize Controller
[    1.106082] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    1.110774] Call Trace:
[    1.110950]  myrs_cleanup+0xe4/0x150 [myrs]
[    1.111135]  myrs_probe.cold+0x91/0x56a [myrs]
[    1.111302]  ? DAC960_GEM_intr_handler+0x1f0/0x1f0 [myrs]
[    1.111500]  local_pci_probe+0x48/0x90

Link: https://lore.kernel.org/r/20220123225717.1069538-1-ztong0001@gmail.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/myrs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 78c41bbf67562..e6a6678967e52 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2272,7 +2272,8 @@ static void myrs_cleanup(struct myrs_hba *cs)
 	myrs_unmap(cs);
 
 	if (cs->mmio_base) {
-		cs->disable_intr(cs);
+		if (cs->disable_intr)
+			cs->disable_intr(cs);
 		iounmap(cs->mmio_base);
 		cs->mmio_base = NULL;
 	}
-- 
2.34.1

