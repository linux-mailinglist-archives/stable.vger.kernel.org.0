Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470E613F852
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389192AbgAPTRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:17:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732674AbgAPQzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B53A2467A;
        Thu, 16 Jan 2020 16:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193714;
        bh=klIKoTMA6lF5peF5ulNsoGKugOg5LPRiZi3nziNWFJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QX7HSAm21TH7/fKsGEiXztMOGuVMkSlZL4knblr1NL+TptW4vQWoEDRBWHNBRG5v9
         A3LfW1RFuGslOafPPsA933Wctk6MtHHWq3S7OzXGRKJFAkj2PdJYCENb6aQO4mD8Vz
         UshUBePUqlBJIOfDUh5hvToTkcIZMefPh8zb9rKg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Rowand <frank.rowand@sony.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 010/671] ARM: qcom_defconfig: Enable MAILBOX
Date:   Thu, 16 Jan 2020 11:44:01 -0500
Message-Id: <20200116165502.8838-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Rowand <frank.rowand@sony.com>

[ Upstream commit 54c2678cd198f61555796bbda5e1727e6e1858f1 ]

Problem:
ab460a2e72da ("rpmsg: qcom_smd: Access APCS through mailbox framework"
added a "depends on MAILBOX") to RPMSG_QCOM_SMD, thus RPMSG_QCOM_SMD
becomes unset since MAILBOX was not enabled in qcom_defconfig and is
not otherwise selected for the dragonboard.  When the resulting
kernel is booted the mmc device which contains the root file system
is not available.

Fix:
add CONFIG_MAILBOX to qcom_defconfig

Fixes: ab460a2e72da ("rpmsg: qcom_smd: Access APCS through mailbox framework"
added a "depends on MAILBOX")

Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/qcom_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/qcom_defconfig b/arch/arm/configs/qcom_defconfig
index 6aa7046fb91f..bd6440f23493 100644
--- a/arch/arm/configs/qcom_defconfig
+++ b/arch/arm/configs/qcom_defconfig
@@ -207,6 +207,7 @@ CONFIG_MSM_MMCC_8974=y
 CONFIG_MSM_IOMMU=y
 CONFIG_HWSPINLOCK=y
 CONFIG_HWSPINLOCK_QCOM=y
+CONFIG_MAILBOX=y
 CONFIG_REMOTEPROC=y
 CONFIG_QCOM_ADSP_PIL=y
 CONFIG_QCOM_Q6V5_PIL=y
-- 
2.20.1

