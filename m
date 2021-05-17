Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17F8383598
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242036AbhEQPXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243874AbhEQPSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:18:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2BA461C70;
        Mon, 17 May 2021 14:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262022;
        bh=9guIHwAVuNg2BMdh300HOIGFHkUygPIR9wFQ99alIYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4DGImdQBGNv4eH99gZgAWq6OwBxGs5ODhlSJwD/JO0M7qkDxWZRigoIfFF3lasME
         13pUZLc2fwHRbnQhq2KFcs8i3drIiNlx0P0YwUahrzC2wMxfsKxHN8PiB3p6eteHFP
         6p+wfCWBAVU/GpsiRh2mPCvyag4QV4iSaKSO/cuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        kernel test robot <lkp@intel.com>,
        Sibi Sankar <sibis@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/289] remoteproc: qcom_q6v5_mss: Replace ioremap with memremap
Date:   Mon, 17 May 2021 16:00:25 +0200
Message-Id: <20210517140308.553673713@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit 04ff5d19cf6e2f9dbdf137c0c6eb44934d46a99c ]

Fix the sparse warnings reported by the kernel test bot by replacing
ioremap calls with memremap.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/1604473422-29639-1-git-send-email-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index ba6f7551242d..126a9706449a 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1182,7 +1182,7 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
 			goto release_firmware;
 		}
 
-		ptr = ioremap_wc(qproc->mpss_phys + offset, phdr->p_memsz);
+		ptr = memremap(qproc->mpss_phys + offset, phdr->p_memsz, MEMREMAP_WC);
 		if (!ptr) {
 			dev_err(qproc->dev,
 				"unable to map memory region: %pa+%zx-%x\n",
@@ -1197,7 +1197,7 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
 					"failed to load segment %d from truncated file %s\n",
 					i, fw_name);
 				ret = -EINVAL;
-				iounmap(ptr);
+				memunmap(ptr);
 				goto release_firmware;
 			}
 
@@ -1209,7 +1209,7 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
 							ptr, phdr->p_filesz);
 			if (ret) {
 				dev_err(qproc->dev, "failed to load %s\n", fw_name);
-				iounmap(ptr);
+				memunmap(ptr);
 				goto release_firmware;
 			}
 
@@ -1220,7 +1220,7 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
 			memset(ptr + phdr->p_filesz, 0,
 			       phdr->p_memsz - phdr->p_filesz);
 		}
-		iounmap(ptr);
+		memunmap(ptr);
 		size += phdr->p_memsz;
 
 		code_length = readl(qproc->rmb_base + RMB_PMI_CODE_LENGTH_REG);
@@ -1287,11 +1287,11 @@ static void qcom_q6v5_dump_segment(struct rproc *rproc,
 	}
 
 	if (!ret)
-		ptr = ioremap_wc(qproc->mpss_phys + offset + cp_offset, size);
+		ptr = memremap(qproc->mpss_phys + offset + cp_offset, size, MEMREMAP_WC);
 
 	if (ptr) {
 		memcpy(dest, ptr, size);
-		iounmap(ptr);
+		memunmap(ptr);
 	} else {
 		memset(dest, 0xff, size);
 	}
-- 
2.30.2



