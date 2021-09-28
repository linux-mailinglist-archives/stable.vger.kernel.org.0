Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA5341A798
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbhI1F6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238972AbhI1F5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76C956113E;
        Tue, 28 Sep 2021 05:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808570;
        bh=W978VNnoBPO6sW63/1v4s7wCVz59IicxzMl2SC1THb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhLwT2dPyP66zLSDCfIYwMbaIsuVJEbkODvzgvMV7CS3KArunAoe2LLpIqu3if80h
         oTOeJgSA4qB+q4LNEbpFA5vFiyTfpd/3Sil0LX8bW3FVRDdtteFsnrIRUaucJeBaKI
         HEdwb651lrDN2mLh5RCCFBsxImJ7S/tNEOQl/eprG3OARutAo7ydxzYS+TzDg3oED5
         63jMhjcum11RySo/qphZz08PYt/bonDWIdmCTYkVJXIy7jIkxI9XR4bDLd8NwUVe9z
         gNNzUxMR5I2eOlX+1CeKUU1UMi/05oXd5cObjdtcCZJXHB/IV1JYvrAXyc5nL5Olsr
         NDFKhbvzEVAbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Arnd@vger.kernel.org,
        gregkh@linuxfoundation.org, ttayar@habana.ai, fkassabri@habana.ai,
        osharabi@habana.ai
Subject: [PATCH AUTOSEL 5.14 21/40] habanalabs: fail collective wait when not supported
Date:   Tue, 28 Sep 2021 01:55:05 -0400
Message-Id: <20210928055524.172051-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit d09ff62c820b5950ab9958e77620a8498efe9386 ]

As collective wait operation is required only when NIC ports are
available, we disable the option to submit a CS in case all the ports
are disabled, which is the current situation in the upstream driver.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/command_submission.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/misc/habanalabs/common/command_submission.c b/drivers/misc/habanalabs/common/command_submission.c
index 80c60fb41bbc..d249101106de 100644
--- a/drivers/misc/habanalabs/common/command_submission.c
+++ b/drivers/misc/habanalabs/common/command_submission.c
@@ -1727,6 +1727,15 @@ static int cs_ioctl_signal_wait(struct hl_fpriv *hpriv, enum hl_cs_type cs_type,
 			goto free_cs_chunk_array;
 		}
 
+		if (!hdev->nic_ports_mask) {
+			atomic64_inc(&ctx->cs_counters.validation_drop_cnt);
+			atomic64_inc(&cntr->validation_drop_cnt);
+			dev_err(hdev->dev,
+				"Collective operations not supported when NIC ports are disabled");
+			rc = -EINVAL;
+			goto free_cs_chunk_array;
+		}
+
 		collective_engine_id = chunk->collective_engine_id;
 	}
 
-- 
2.33.0

