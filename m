Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076B520DC66
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgF2UOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:14:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732831AbgF2TaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C662E251EE;
        Mon, 29 Jun 2020 15:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444911;
        bh=N8Kw4vgdWvrmLWML7P5AQDoKHbBDhEK38kF08BLH4Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZLd6sgf7bEItZ76KoZsHn3uLTbfg56m9AbeyzhLvVrpdjqRnwoXb5Fcitz5am01Q
         pMdOKboKboBX5pYFeqYnohbTibUgmRHZWJXCUVxX6RqDmLo+1SRUXrXft11fQSNh00
         z/2OW0GhEOXZEzRfMcFu7utJjpMKyFJjfGdQdKrw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Kim Phillips <kim.phillips@amd.com>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/131] EDAC/amd64: Add Family 17h Model 30h PCI IDs
Date:   Mon, 29 Jun 2020 11:32:58 -0400
Message-Id: <20200629153502.2494656-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit 6e846239e5487cbb89ac8192d5f11437d010130e ]

Add the new Family 17h Model 30h PCI IDs to the AMD64 EDAC module.

This also fixes a probe failure that appeared when some other PCI IDs
for Family 17h Model 30h were added to the AMD NB code.

Fixes: be3518a16ef2 (x86/amd_nb: Add PCI device IDs for family 17h, model 30h)
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Cc: James Morse <james.morse@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>
Link: https://lkml.kernel.org/r/20190228153558.127292-1-Yazen.Ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 13 +++++++++++++
 drivers/edac/amd64_edac.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 05d6f9c86ac38..268ada29cd987 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2209,6 +2209,15 @@ static struct amd64_family_type family_types[] = {
 			.dbam_to_cs		= f17_base_addr_to_cs_size,
 		}
 	},
+	[F17_M30H_CPUS] = {
+		.ctl_name = "F17h_M30h",
+		.f0_id = PCI_DEVICE_ID_AMD_17H_M30H_DF_F0,
+		.f6_id = PCI_DEVICE_ID_AMD_17H_M30H_DF_F6,
+		.ops = {
+			.early_channel_count	= f17_early_channel_count,
+			.dbam_to_cs		= f17_base_addr_to_cs_size,
+		}
+	},
 };
 
 /*
@@ -3212,6 +3221,10 @@ static struct amd64_family_type *per_family_init(struct amd64_pvt *pvt)
 			fam_type = &family_types[F17_M10H_CPUS];
 			pvt->ops = &family_types[F17_M10H_CPUS].ops;
 			break;
+		} else if (pvt->model >= 0x30 && pvt->model <= 0x3f) {
+			fam_type = &family_types[F17_M30H_CPUS];
+			pvt->ops = &family_types[F17_M30H_CPUS].ops;
+			break;
 		}
 		fam_type	= &family_types[F17_CPUS];
 		pvt->ops	= &family_types[F17_CPUS].ops;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 4242f8e39c18f..de8dbb0b42b55 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -117,6 +117,8 @@
 #define PCI_DEVICE_ID_AMD_17H_DF_F6	0x1466
 #define PCI_DEVICE_ID_AMD_17H_M10H_DF_F0 0x15e8
 #define PCI_DEVICE_ID_AMD_17H_M10H_DF_F6 0x15ee
+#define PCI_DEVICE_ID_AMD_17H_M30H_DF_F0 0x1490
+#define PCI_DEVICE_ID_AMD_17H_M30H_DF_F6 0x1496
 
 /*
  * Function 1 - Address Map
@@ -284,6 +286,7 @@ enum amd_families {
 	F16_M30H_CPUS,
 	F17_CPUS,
 	F17_M10H_CPUS,
+	F17_M30H_CPUS,
 	NUM_FAMILIES,
 };
 
-- 
2.25.1

