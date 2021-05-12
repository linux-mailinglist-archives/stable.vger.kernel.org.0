Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EE837C8A2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhELQLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238697AbhELQGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:06:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADD5261990;
        Wed, 12 May 2021 15:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833699;
        bh=xfco83/Vv5h5DsQ/gshP76G6OEa8DgT+NMphR6cfa9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y12oAs8zV/Egc3cyfd5nMuAWUu8YteUbcKkqkhJb7PDHkgUNK5K8P/C8WJHLkh48f
         hs9VtP4CQoUsJlM8Uc0j6JjHyw3lLr+QLIGl0JN0YdXerX6IJOVghplWG/l2fDwrcm
         GanFiEAD8FoDAIiIQ6enDT5DTuLI0RSD5vStypc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 252/601] soc: qcom: mdt_loader: Validate that p_filesz < p_memsz
Date:   Wed, 12 May 2021 16:45:29 +0200
Message-Id: <20210512144836.124867269@linuxfoundation.org>
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
index 24cd193dec55..2ddaee5ef9cc 100644
--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -230,6 +230,14 @@ static int __qcom_mdt_load(struct device *dev, const struct firmware *fw,
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
 
 		if (phdr->p_filesz && phdr->p_offset < fw->size) {
-- 
2.30.2



