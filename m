Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA4E8121901
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfLPSrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbfLPRyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:54:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDE86206B7;
        Mon, 16 Dec 2019 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518891;
        bh=xoLbdjnG4Q9AJYtioJdQMA9gFOkUVdYX+29fOJTfD64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mO2Z2PjbA3dZ4JA7L3JFI2rJmfa0/1bm7UyHAaai6wYrQMynlNEU42xhW7RkHaFIK
         V42W5BTidhIG70/MoF9wUfErbufHc60PYnQWeCCpSnPbbMhG7V251pgdZRqXeZRwvk
         XZXfS0VwGR6JFoy5FB0lOhcMernEBPZWompXsqSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 110/267] firmware: qcom: scm: fix compilation error when disabled
Date:   Mon, 16 Dec 2019 18:47:16 +0100
Message-Id: <20191216174902.740963172@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index e5380471c2cd2..428278a44c7db 100644
--- a/include/linux/qcom_scm.h
+++ b/include/linux/qcom_scm.h
@@ -44,6 +44,9 @@ extern int qcom_scm_restore_sec_cfg(u32 device_id, u32 spare);
 extern int qcom_scm_iommu_secure_ptbl_size(u32 spare, size_t *size);
 extern int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare);
 #else
+
+#include <linux/errno.h>
+
 static inline
 int qcom_scm_set_cold_boot_addr(void *entry, const cpumask_t *cpus)
 {
-- 
2.20.1



