Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FEB291CC3
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbgJRTkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730758AbgJRTY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:24:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 071EB22314;
        Sun, 18 Oct 2020 19:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049065;
        bh=LuwWbDLMxKRxIwhhUWeSOgvAbyugfSWIf9/pibPAZqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCMNfX2TIogvdMU13LfmPfZ5FDgzOESsew1ItCU2XxAlDXn5aO9kOTJZx+KauUvK1
         r5MJW3n5um6yh/OOXyZW5+JhWKA+4RyQZxIHZW6L+P44ohlbPFtw5ceZ/Z+8LPp7Xg
         pCQns0UqvEn1kFR5qWDLhcdj5WiCDpkHvBi23oQg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/56] media: sti: Fix reference count leaks
Date:   Sun, 18 Oct 2020 15:23:27 -0400
Message-Id: <20201018192417.4055228-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192417.4055228-1-sashal@kernel.org>
References: <20201018192417.4055228-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 6f4432bae9f2d12fc1815b5e26cc07e69bcad0df ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code, causing incorrect ref count if
pm_runtime_put_noidle() is not called in error handling paths.
Thus call pm_runtime_put_noidle() if pm_runtime_get_sync() fails.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/hva/hva-hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
index 7917fd2c4bd4b..166ed30bbfce5 100644
--- a/drivers/media/platform/sti/hva/hva-hw.c
+++ b/drivers/media/platform/sti/hva/hva-hw.c
@@ -272,6 +272,7 @@ static unsigned long int hva_hw_get_ip_version(struct hva_dev *hva)
 
 	if (pm_runtime_get_sync(dev) < 0) {
 		dev_err(dev, "%s     failed to get pm_runtime\n", HVA_PREFIX);
+		pm_runtime_put_noidle(dev);
 		mutex_unlock(&hva->protect_mutex);
 		return -EFAULT;
 	}
@@ -557,6 +558,7 @@ void hva_hw_dump_regs(struct hva_dev *hva, struct seq_file *s)
 
 	if (pm_runtime_get_sync(dev) < 0) {
 		seq_puts(s, "Cannot wake up IP\n");
+		pm_runtime_put_noidle(dev);
 		mutex_unlock(&hva->protect_mutex);
 		return;
 	}
-- 
2.25.1

