Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0617411B4EC
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732581AbfLKPXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731907AbfLKPXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42D7B2464B;
        Wed, 11 Dec 2019 15:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077815;
        bh=WVbx/xSLrJRM55gfBGknfSkubQWDH97aP25vQ5Xw9bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1z/21yfFwO4pxQvPqALE27H2tsfQYCjL8QpraSifHeZLRM/PxbBcl7fkQSn3irN3
         gyfQTIhWNVqzQkh29b355kdASSSAFo/XbJ1JbmMZGFxbEHGWezhFeRdJoAJ9RRjlKw
         LLEfhCwEMor9a0U5NYqfE+E+LfwN/ifgmd56bxt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 180/243] firmware: qcom: scm: fix compilation error when disabled
Date:   Wed, 11 Dec 2019 16:05:42 +0100
Message-Id: <20191211150351.322476729@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 16ad9501b1f2edebe24f8cf3c09da0695871986b ]

This fixes the case when CONFIG_QCOM_SCM is not enabled, and linux/errno.h
has not been included previously.

Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/qcom_scm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
index 5d65521260b3d..116b81ac442ad 100644
--- a/include/linux/qcom_scm.h
+++ b/include/linux/qcom_scm.h
@@ -65,6 +65,9 @@ extern int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare);
 extern int qcom_scm_io_readl(phys_addr_t addr, unsigned int *val);
 extern int qcom_scm_io_writel(phys_addr_t addr, unsigned int val);
 #else
+
+#include <linux/errno.h>
+
 static inline
 int qcom_scm_set_cold_boot_addr(void *entry, const cpumask_t *cpus)
 {
-- 
2.20.1



