Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9159291E91
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgJRTxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728968AbgJRTUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:20:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD841222EB;
        Sun, 18 Oct 2020 19:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048839;
        bh=+n1S3A+tYy55zl/N+PuWYLmn/WLTr5AUGrt5WVfD6Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYuhRXqyYNrQ2fKylgbDv7UJ/xCYd4bTH6Hnn3vme6A39EDNAOJbofu+B7DFQ927M
         5SgNzZUiiluupebQFO81OrvWj3vb51qnpE4xFDgU7VSwEFUKyA2jLv/tgJpE4Qf3lP
         X0D3LBZEDwyq1iPJLk3edGLM3jA46+boKeeTKAFc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 010/101] media: sti: Fix reference count leaks
Date:   Sun, 18 Oct 2020 15:18:55 -0400
Message-Id: <20201018192026.4053674-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
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
index 401aaafa17109..bb13348be0832 100644
--- a/drivers/media/platform/sti/hva/hva-hw.c
+++ b/drivers/media/platform/sti/hva/hva-hw.c
@@ -272,6 +272,7 @@ static unsigned long int hva_hw_get_ip_version(struct hva_dev *hva)
 
 	if (pm_runtime_get_sync(dev) < 0) {
 		dev_err(dev, "%s     failed to get pm_runtime\n", HVA_PREFIX);
+		pm_runtime_put_noidle(dev);
 		mutex_unlock(&hva->protect_mutex);
 		return -EFAULT;
 	}
@@ -553,6 +554,7 @@ void hva_hw_dump_regs(struct hva_dev *hva, struct seq_file *s)
 
 	if (pm_runtime_get_sync(dev) < 0) {
 		seq_puts(s, "Cannot wake up IP\n");
+		pm_runtime_put_noidle(dev);
 		mutex_unlock(&hva->protect_mutex);
 		return;
 	}
-- 
2.25.1

