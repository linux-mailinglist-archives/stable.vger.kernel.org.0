Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970202C9BA7
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389768AbgLAJKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389734AbgLAJKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:10:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8261222245;
        Tue,  1 Dec 2020 09:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813797;
        bh=h60ek0hTv04VHgQSiFeWek+FE4Lk+MHPlUOUUhBX+ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNvLPCVm5756JzsycwUgj4R004HfVjw/Mj04VStIxuzOKnxfpMJwlrPUPBqWY+CA+
         lffyp4DRAgrXX5EPDNjG1O42l3gVC5Si+PuGI9UCItbIOkAmWuDo1D0MD7qpySVr9B
         3NVbeWcMm0vN4FmVXue8PwBGCl0O7oFeifeGVn7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 045/152] staging: ralink-gdma: fix kconfig dependency bug for DMA_RALINK
Date:   Tue,  1 Dec 2020 09:52:40 +0100
Message-Id: <20201201084717.777362894@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit 06ea594051707c6b8834ef5b24e9b0730edd391b ]

When DMA_RALINK is enabled and DMADEVICES is disabled, it results in the
following Kbuild warnings:

WARNING: unmet direct dependencies detected for DMA_ENGINE
  Depends on [n]: DMADEVICES [=n]
  Selected by [y]:
  - DMA_RALINK [=y] && STAGING [=y] && RALINK [=y] && !SOC_RT288X [=n]

WARNING: unmet direct dependencies detected for DMA_VIRTUAL_CHANNELS
  Depends on [n]: DMADEVICES [=n]
  Selected by [y]:
  - DMA_RALINK [=y] && STAGING [=y] && RALINK [=y] && !SOC_RT288X [=n]

The reason is that DMA_RALINK selects DMA_ENGINE and DMA_VIRTUAL_CHANNELS
without depending on or selecting DMADEVICES while DMA_ENGINE and
DMA_VIRTUAL_CHANNELS are subordinate to DMADEVICES. This can also fail
building the kernel as demonstrated in a bug report.

Honor the kconfig dependency to remove unmet direct dependency warnings
and avoid any potential build failures.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=210055
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Link: https://lore.kernel.org/r/20201104181522.43567-1-fazilyildiran@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/ralink-gdma/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ralink-gdma/Kconfig b/drivers/staging/ralink-gdma/Kconfig
index 54e8029e6b1af..0017376234e28 100644
--- a/drivers/staging/ralink-gdma/Kconfig
+++ b/drivers/staging/ralink-gdma/Kconfig
@@ -2,6 +2,7 @@
 config DMA_RALINK
 	tristate "RALINK DMA support"
 	depends on RALINK && !SOC_RT288X
+	depends on DMADEVICES
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 
-- 
2.27.0



