Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C02D205E73
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390200AbgFWUWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390196AbgFWUWj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:22:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A2FD2073E;
        Tue, 23 Jun 2020 20:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943759;
        bh=w6ZOsNqSph3+zxkDGVwNoJmA44m+dH/qiJLveJ0AUaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcG83IibNnNkM9YTOOem0KFENxf0s0Y04ZgzLiCZ8i+GwmI7/g5bxU3l4uCOREJ7x
         syMZxGhrszLwfDzcxzvMJnqssdux5XBCYTgn5BBqx0mv9ALQqHEWEAhcki4VNBYihJ
         mtj/eYrwFwBpLJIJVumIYKx3VGEhU/+aG6QO/NRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Baluta <daniel.baluta@nxp.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/314] ASoC: SOF: Do nothing when DSP PM callbacks are not set
Date:   Tue, 23 Jun 2020 21:53:55 +0200
Message-Id: <20200623195340.722635988@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Baluta <daniel.baluta@nxp.com>

[ Upstream commit c26fde3b15ed41f5f452f1da727795f787833287 ]

This provides a better separation between runtime and PM sleep
callbacks.

Only do nothing if given runtime flag is set and calback is not set.

With the current implementation, if PM sleep callback is set but runtime
callback is not set then at runtime resume we reload the firmware even
if we do not support runtime resume callback.

Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20200515135958.17511-2-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/pm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index 195af259e78e3..128680b09c20b 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -266,7 +266,10 @@ static int sof_resume(struct device *dev, bool runtime_resume)
 	int ret;
 
 	/* do nothing if dsp resume callbacks are not set */
-	if (!sof_ops(sdev)->resume || !sof_ops(sdev)->runtime_resume)
+	if (!runtime_resume && !sof_ops(sdev)->resume)
+		return 0;
+
+	if (runtime_resume && !sof_ops(sdev)->runtime_resume)
 		return 0;
 
 	/* DSP was never successfully started, nothing to resume */
@@ -346,7 +349,10 @@ static int sof_suspend(struct device *dev, bool runtime_suspend)
 	int ret;
 
 	/* do nothing if dsp suspend callback is not set */
-	if (!sof_ops(sdev)->suspend)
+	if (!runtime_suspend && !sof_ops(sdev)->suspend)
+		return 0;
+
+	if (runtime_suspend && !sof_ops(sdev)->runtime_suspend)
 		return 0;
 
 	if (sdev->fw_state != SOF_FW_BOOT_COMPLETE)
-- 
2.25.1



