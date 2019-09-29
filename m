Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D100C17F3
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbfI2Rks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730397AbfI2Reg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:34:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5372921D56;
        Sun, 29 Sep 2019 17:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778476;
        bh=S20uy8P4PRf/bzXgHQAXj8lKXo82Ek27pjMYweAOWz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWovZuRqW4pld4dH3zTrG3vwQLJHUyxQtD3S4SbYyHBVDis8qwoz2VmZ5WlARwJMl
         5BTCZtzWXyO+5By0Q7FaDfG7S3vhhU3Rt0TfIPYJTVAfRYZK7csO0K7JZ/IW8sc4ed
         7qdsuBEZdU5vzgLdzCVqnuEwf8B1v16TMyuGsnv4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 05/33] mfd: intel-lpss: Remove D3cold delay
Date:   Sun, 29 Sep 2019 13:33:53 -0400
Message-Id: <20190929173424.9361-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173424.9361-1-sashal@kernel.org>
References: <20190929173424.9361-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 76380a607ba0b28627c9b4b55cd47a079a59624b ]

Goodix touchpad may drop its first couple input events when
i2c-designware-platdrv and intel-lpss it connects to took too long to
runtime resume from runtime suspended state.

This issue happens becuase the touchpad has a rather small buffer to
store up to 13 input events, so if the host doesn't read those events in
time (i.e. runtime resume takes too long), events are dropped from the
touchpad's buffer.

The bottleneck is D3cold delay it waits when transitioning from D3cold
to D0, hence remove the delay to make the resume faster. I've tested
some systems with intel-lpss and haven't seen any regression.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202683
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel-lpss-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
index 0e5282fc14675..c37c8bb860685 100644
--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -39,6 +39,8 @@ static int intel_lpss_pci_probe(struct pci_dev *pdev,
 	info->mem = &pdev->resource[0];
 	info->irq = pdev->irq;
 
+	pdev->d3cold_delay = 0;
+
 	/* Probably it is enough to set this for iDMA capable devices only */
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
-- 
2.20.1

