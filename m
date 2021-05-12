Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56CC37C90F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbhELQOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239193AbhELQHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B7B66198C;
        Wed, 12 May 2021 15:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833812;
        bh=Vzc7tGSAr1z6+iSgLvZ/TNMDpea323OpeKIft7ZbDag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLCzUHhNYaq6HEuqXiyMqBNZ0N5lbFJ9rhOzqV97K6hG5d0m1eZVXzy2uzZjBRTf9
         Qmt9e6yiM0u6CYA7+rmExPQTPY11O7yC6NH3aAxOBzo6AkBys3cR7tyq2U5/6ZGiq6
         beOLQ9KQjhMRF+NPatBV1gDCYZDyVaSsXpOnzG6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 253/601] soc: qcom: mdt_loader: Detect truncated read of segments
Date:   Wed, 12 May 2021 16:45:30 +0200
Message-Id: <20210512144836.156157602@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index 2ddaee5ef9cc..eba7f76f9d61 100644
--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -261,6 +261,15 @@ static int __qcom_mdt_load(struct device *dev, const struct firmware *fw,
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



