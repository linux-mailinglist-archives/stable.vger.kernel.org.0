Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AF738A3B2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhETJ4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234377AbhETJxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:53:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03E456024A;
        Thu, 20 May 2021 09:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503396;
        bh=sSNw2j+udEE3HtCzoKp4Dx5j2tRsVlCX0HNeL2Eb5ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmMahA7fBdz1acBO1Oo+tjiK2mt/XXIfxFUuy92p+AdeA7C1JEzGWQp2KNkjwMRSA
         sqHrKjTuoHjkYUBZmlqHBiUhRNP0tMiSd0JrZVoU7tKemaitoCSPiSfjogIq0+KgZg
         utbeNNYge13/V2pmibf0LRVlpfxJof6X3qx85lro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/425] soc: qcom: mdt_loader: Validate that p_filesz < p_memsz
Date:   Thu, 20 May 2021 11:19:31 +0200
Message-Id: <20210520092138.052707559@linuxfoundation.org>
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

[ Upstream commit 84168d1b54e76a1bcb5192991adde5176abe02e3 ]

The code validates that segments of p_memsz bytes of a segment will fit
in the provided memory region, but does not validate that p_filesz bytes
will, which means that an incorrectly crafted ELF header might write
beyond the provided memory region.

Fixes: 051fb70fd4ea ("remoteproc: qcom: Driver for the self-authenticating Hexagon v5")
Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20210107233119.717173-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/mdt_loader.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/soc/qcom/mdt_loader.c b/drivers/soc/qcom/mdt_loader.c
index 1c488024c698..7584b81d06a1 100644
--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -168,6 +168,14 @@ static int __qcom_mdt_load(struct device *dev, const struct firmware *fw,
 			break;
 		}
 
+		if (phdr->p_filesz > phdr->p_memsz) {
+			dev_err(dev,
+				"refusing to load segment %d with p_filesz > p_memsz\n",
+				i);
+			ret = -EINVAL;
+			break;
+		}
+
 		ptr = mem_region + offset;
 
 		if (phdr->p_filesz) {
-- 
2.30.2



