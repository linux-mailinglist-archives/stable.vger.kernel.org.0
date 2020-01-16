Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC9913EC5D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405988AbgAPR40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394036AbgAPRn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:43:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE50124741;
        Thu, 16 Jan 2020 17:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196636;
        bh=3FrFC1OLRTzIJtgYEMGP4U0VmRLAUSOFAgj941QtiJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iN9BW0eJ6Squj3N5Nsbhmkvgj1ZsVXG1zzrg9MtsEM2NX1LYQSj+E7C1E5HG6Cgw0
         nq+i5awJM0pesdaxNTYheGq5Ytdys0iXCiIWpCxP5WidBXM4zL4kiU1YIUIbQktyWx
         YWvqHTDGSdwqGZQ3S91vmvtRQ7IoS2BnGRi1sdd0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 049/174] drm/nouveau/pmu: don't print reply values if exec is false
Date:   Thu, 16 Jan 2020 12:40:46 -0500
Message-Id: <20200116174251.24326-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit b1d03fc36ec9834465a08c275c8d563e07f6f6bf ]

Currently the uninitialized values in the array reply are printed out
when exec is false and nvkm_pmu_send has not updated the array. Avoid
confusion by only dumping out these values if they have been actually
updated.

Detected by CoverityScan, CID#1271291 ("Uninitialized scaler variable")
Fixes: ebb58dc2ef8c ("drm/nouveau/pmu: rename from pwr (no binary change)")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c
index e6f74168238c..2ef9e942f43a 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c
@@ -87,10 +87,10 @@ nvkm_memx_fini(struct nvkm_memx **pmemx, bool exec)
 	if (exec) {
 		nvkm_pmu_send(pmu, reply, PROC_MEMX, MEMX_MSG_EXEC,
 			      memx->base, finish);
+		nvkm_debug(subdev, "Exec took %uns, PMU_IN %08x\n",
+			   reply[0], reply[1]);
 	}
 
-	nvkm_debug(subdev, "Exec took %uns, PMU_IN %08x\n",
-		   reply[0], reply[1]);
 	kfree(memx);
 	return 0;
 }
-- 
2.20.1

