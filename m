Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9D93BB2C4
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhGDXQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234144AbhGDXOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EC8E61965;
        Sun,  4 Jul 2021 23:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440286;
        bh=ZwCIXI+anUKvUjBFbZwfOKZagOMJbFXhrHhA7no+JHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Svs6O3mjp4hMbEvi3wlA13QW1Gi4amLQNEsqGGCRdHiBn2JBTGeg8JA8aGiZqV9RI
         BRxVplMPoUK9hIoMm4oMyLntND8aRFZnD6RsVJ3s9EyFg6MXRfPfeFAQY5vaX7PBRo
         41ylio+C19zp4o3p1c2EvpBrkLpWEZtPqMjdgM+jRBNakjKUQBaBhuh/tKz4QvuU+J
         Qh3RZBEdYz/ntgOYutnriYlKIyT+eNrAY61gl7F7wu95q08yEpyhyzUByhTMHNj4V/
         P6iLmiVQ5kbdBemgidMiqAX+XpzEQRb4arz8OvlBvU9/6pMdeMwbYF0I9QNWUHPshP
         Gbzh05nwEgTIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/25] media: sh_vou: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:11:00 -0400
Message-Id: <20210704231123.1491517-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231123.1491517-1-sashal@kernel.org>
References: <20210704231123.1491517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 6e8b1526db164c9d4b9dacfb9bc48e365d7c4860 ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.
Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

While here, check if the PM runtime error was caught at open time.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sh_vou.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 871da2a2a91c..06381c88229f 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1147,7 +1147,11 @@ static int sh_vou_open(struct file *file)
 	if (v4l2_fh_is_singular_file(file) &&
 	    vou_dev->status == SH_VOU_INITIALISING) {
 		/* First open */
-		pm_runtime_get_sync(vou_dev->v4l2_dev.dev);
+		err = pm_runtime_resume_and_get(vou_dev->v4l2_dev.dev);
+		if (err < 0) {
+			v4l2_fh_release(file);
+			goto done_open;
+		}
 		err = sh_vou_hw_init(vou_dev);
 		if (err < 0) {
 			pm_runtime_put(vou_dev->v4l2_dev.dev);
-- 
2.30.2

