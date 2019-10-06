Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54697CD66F
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731593AbfJFRn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731598AbfJFRn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:43:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38E6620700;
        Sun,  6 Oct 2019 17:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383835;
        bh=QwTcFMBesfpfRCkx9Ek6f7fseKxUhCJ26xYBuzSQOoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePCpmzFvJB4h3dEELh4zowM7RrMQ5bUfZ/hTH6quiTVOMyTqRubkyfB0UnjPcYd/v
         HxW7ZeCK6Ekma3WljSNDRUEsgXNd/z7M4Jb40+NnOFPseP2871a4StxsyYmM3LEClc
         1WF5ckXeK3L61yptNcNVnEmxd36bYX9xiSlGnRYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 086/166] mfd: intel-lpss: Remove D3cold delay
Date:   Sun,  6 Oct 2019 19:20:52 +0200
Message-Id: <20191006171220.767004334@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ade6e1ce5a983..e3a04929aaa36 100644
--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -35,6 +35,8 @@ static int intel_lpss_pci_probe(struct pci_dev *pdev,
 	info->mem = &pdev->resource[0];
 	info->irq = pdev->irq;
 
+	pdev->d3cold_delay = 0;
+
 	/* Probably it is enough to set this for iDMA capable devices only */
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
-- 
2.20.1



