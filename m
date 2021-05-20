Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B6A38A6EB
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhETKbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236002AbhETK3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:29:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13DC7611C2;
        Thu, 20 May 2021 09:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504303;
        bh=X77CZ2mhBpvbf24kDthnI68hyzl0G4DvTeW/MrSqEqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQdvjTbBH2+tRQ+7LvOrUO46D6YapsJYUPMRreyxmDvyj8O95ANHf5cl55k1p/bcA
         ODUTOp4JjWe/kf04PYS5sKFvoPPFFA+6dFoXw/2401bWcN+cFSf1Ok8M61XLB2ndKv
         muHaMg/7KovMuzLQ1qvsNJgWhD3toKd6YyrDPXsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 167/323] soc: qcom: mdt_loader: Detect truncated read of segments
Date:   Thu, 20 May 2021 11:20:59 +0200
Message-Id: <20210520092125.830445780@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 0648c55e3a21ccd816e99b6600d6199fbf39d23a ]

Given that no validation of how much data the firmware loader read in
for a given segment truncated segment files would best case result in a
hash verification failure, without any indication of what went wrong.

Improve this by validating that the firmware loader did return the
amount of data requested.

Fixes: 445c2410a449 ("soc: qcom: mdt_loader: Use request_firmware_into_buf()")
Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20210107232526.716989-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/mdt_loader.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/soc/qcom/mdt_loader.c b/drivers/soc/qcom/mdt_loader.c
index 17cba12cdf61..9155b1c75cfb 100644
--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -193,6 +193,15 @@ int qcom_mdt_load(struct device *dev, const struct firmware *fw,
 				break;
 			}
 
+			if (seg_fw->size != phdr->p_filesz) {
+				dev_err(dev,
+					"failed to load segment %d from truncated file %s\n",
+					i, fw_name);
+				release_firmware(seg_fw);
+				ret = -EINVAL;
+				break;
+			}
+
 			release_firmware(seg_fw);
 		}
 
-- 
2.30.2



