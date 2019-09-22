Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94564BA65F
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390473AbfIVSuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391593AbfIVStp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:49:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E526A214AF;
        Sun, 22 Sep 2019 18:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178184;
        bh=dFcVQl6E0c+wU1d5wfNevRmUe9k+SvO0hOvFIQK6V7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJhWoBsZCLt3NpwtsC2cx40X12QIeNHmGVsEbsFIvSVtW6N349LzZualMql8NbXlt
         ErEq+vMaOVbVBub/9w2XIWmdu4XblSaZY+6mJjn8IyY/C6GzLGcTqCqjTbkjkrAulu
         Tx+jroVeDOZ/LbgQpP3w4yv4CHTEj8kdi3PTR2wc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Xiuli <xiuli.pan@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 014/185] ASoC: SOF: pci: mark last_busy value at runtime PM init
Date:   Sun, 22 Sep 2019 14:46:32 -0400
Message-Id: <20190922184924.32534-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Xiuli <xiuli.pan@linux.intel.com>

[ Upstream commit f1b1b9b136827915624136624ff54aba5890a15b ]

If last_busy value is not set at runtime PM enable, the device will be
suspend immediately after usage counter is 0. Set the last_busy value to
make sure delay is working at first boot up.

Signed-off-by: Pan Xiuli <xiuli.pan@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190722141402.7194-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-pci-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index b778dffb2d25c..49daf1390dac0 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -203,6 +203,9 @@ static void sof_pci_probe_complete(struct device *dev)
 	 */
 	pm_runtime_allow(dev);
 
+	/* mark last_busy for pm_runtime to make sure not suspend immediately */
+	pm_runtime_mark_last_busy(dev);
+
 	/* follow recommendation in pci-driver.c to decrement usage counter */
 	pm_runtime_put_noidle(dev);
 }
-- 
2.20.1

