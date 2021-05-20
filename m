Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF1638A3B3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbhETJ4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234648AbhETJxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:53:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38A7A60FF3;
        Thu, 20 May 2021 09:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503398;
        bh=DfdOwyS7EFK7TW++18nDfcmXVvmmrXzU1SsNLwFnNhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRY6hxwoywVaD5+oSmIU8a0K0+NLlaDirhFgCQLe/oA8sw49ICffy4csfaBhhtF+c
         KQzZv7p0cbF3Bpnzam52E6ElABoQxncAYcP0BwBTVfw2behC0As70bKnljqo07YnLo
         nT40sceMMgSnGrr9spThxN+rgWLZTrDB7qIZ0Lbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 203/425] soc: qcom: mdt_loader: Detect truncated read of segments
Date:   Thu, 20 May 2021 11:19:32 +0200
Message-Id: <20210520092138.085430213@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 7584b81d06a1..47dffe7736ff 100644
--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -187,6 +187,15 @@ static int __qcom_mdt_load(struct device *dev, const struct firmware *fw,
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



