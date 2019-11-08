Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C8BF55C5
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391016AbfKHTEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:04:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732170AbfKHTEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:04:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1BA22087E;
        Fri,  8 Nov 2019 19:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239874;
        bh=1Y+xRVtxzd2fp4h43+XE1wF9wYKRdu6H+a18mpLMYN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ip17j1OlXTI7rZznUUqozf9Okp0wT72TtDVr1jn3dzB4gCNxQA69IlTKQfoLJazNy
         MWA6mdoPdmo5aml+Ki8OPJu7wGf0jM7CPDa0e2F2JIlvS+jgXV+Ksy8PRD+bmjUSQY
         nqWJ+0QVK0N02LTq1xbTN+O2IqyO+bMDoeLf2cFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 012/140] ASoC: SOF: loader: fix kernel oops on firmware boot failure
Date:   Fri,  8 Nov 2019 19:49:00 +0100
Message-Id: <20191108174902.262089688@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 798614885a0e1b867ceb0197c30c2d82575c73b0 ]

When we fail to boot the firmware, we encounter a kernel oops in
hda_dsp_get_registers(), which is called conditionally in
hda_dsp_dump() when the sdev_>boot_complete flag is set.

Setting this flag _after_ dumping the data fixes the issue and does
not change the programming flow.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190927200538.660-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/loader.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/loader.c b/sound/soc/sof/loader.c
index 952a19091c582..01775231f2b8d 100644
--- a/sound/soc/sof/loader.c
+++ b/sound/soc/sof/loader.c
@@ -370,10 +370,10 @@ int snd_sof_run_firmware(struct snd_sof_dev *sdev)
 				 msecs_to_jiffies(sdev->boot_timeout));
 	if (ret == 0) {
 		dev_err(sdev->dev, "error: firmware boot failure\n");
-		/* after this point FW_READY msg should be ignored */
-		sdev->boot_complete = true;
 		snd_sof_dsp_dbg_dump(sdev, SOF_DBG_REGS | SOF_DBG_MBOX |
 			SOF_DBG_TEXT | SOF_DBG_PCI);
+		/* after this point FW_READY msg should be ignored */
+		sdev->boot_complete = true;
 		return -EIO;
 	}
 
-- 
2.20.1



