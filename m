Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454971196D7
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbfLJVKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbfLJVKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAB46246AF;
        Tue, 10 Dec 2019 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012205;
        bh=2tdQh7owUxDkjvY4hUjByt01ydM67WLZgxcr2v+lDv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBaV3pOuqihgkQoVr8vAYosgj7S0R6L/SarkJnjcmldRLkfBmUupzjDK+tQUDsIyw
         a76z0EQTq7VVE93dpm/1vLbrMSKnGZRs9UFhq73kTi39Dd+10B0TwDIDim8YPGSVRO
         0FfkMb0K3l9VtI/Uk/Ky1QGe+48Klsqxhk2gRYUw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Robert Richter <rrichter@marvell.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 158/350] EDAC/amd64: Set grain per DIMM
Date:   Tue, 10 Dec 2019 16:04:23 -0500
Message-Id: <20191210210735.9077-119-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit 466503d6b1b33be46ab87c6090f0ade6c6011cbc ]

The following commit introduced a warning on error reports without a
non-zero grain value.

  3724ace582d9 ("EDAC/mc: Fix grain_bits calculation")

The amd64_edac_mod module does not provide a value, so the warning will
be given on the first reported memory error.

Set the grain per DIMM to cacheline size (64 bytes). This is the current
recommendation.

Fixes: 3724ace582d9 ("EDAC/mc: Fix grain_bits calculation")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Robert Richter <rrichter@marvell.com>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20191022203448.13962-7-Yazen.Ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c1d4536ae466e..cc5e56d752c8d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2936,6 +2936,7 @@ static int init_csrows_df(struct mem_ctl_info *mci)
 			dimm->mtype = pvt->dram_type;
 			dimm->edac_mode = edac_mode;
 			dimm->dtype = dev_type;
+			dimm->grain = 64;
 		}
 	}
 
@@ -3012,6 +3013,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 			dimm = csrow->channels[j]->dimm;
 			dimm->mtype = pvt->dram_type;
 			dimm->edac_mode = edac_mode;
+			dimm->grain = 64;
 		}
 	}
 
-- 
2.20.1

