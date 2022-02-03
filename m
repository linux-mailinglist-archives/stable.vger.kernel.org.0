Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA46C4A8D96
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354240AbiBCUbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:31:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36648 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354399AbiBCUbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC1A561A5C;
        Thu,  3 Feb 2022 20:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48240C340F0;
        Thu,  3 Feb 2022 20:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920277;
        bh=JVnRg65Qwa1/CD39njIMCAjJPJZ+EuC+Z6Vt+4qdiKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkK9ed94kKDbdXahWNegg56NkWzGaBg5YrmzCvMr8Mq8d6uu33heyZAwlU/VQLbeZ
         mKmBhiI4yck3y+2pyb54RsWPzpA/e3rsVJoMtOuezAQljhK+DaETygNG0NOXkRm+YW
         jsHOsgcnY9mtOsD8QFDu0sRfi1zrABqWGi0zWAfTMX9ps9fuk4OE3k9Xn/RBGonIN/
         3rwSIbz3MI04+n9GZFkLiSdcx93JqH1HHITxej5Qtq3v5AYwbtHJGUW7jLAXpkmp76
         /u4bEdS9lJPOM261fXE5BtrQ/su91mNoQtVf53Xzaoc9+6nyLnQeUXGW8mbebDexrO
         oA+idKiRlJNcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, hare@kernel.org,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 34/52] scsi: myrs: Fix crash in error case
Date:   Thu,  3 Feb 2022 15:29:28 -0500
Message-Id: <20220203202947.2304-34-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
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
index 6ea323e9a2e34..f6dbc8f2f60a3 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2269,7 +2269,8 @@ static void myrs_cleanup(struct myrs_hba *cs)
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

