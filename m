Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C9A291E40
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388212AbgJRTve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729308AbgJRTVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BB7422314;
        Sun, 18 Oct 2020 19:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048876;
        bh=EsmeZiwtz1CEd+9P9WiTqdjUZJhkzUS4Hese3uC56H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7VmQUoNpy1D21DsuUY7GLSV0gkgKNWW73asztbjVbuwFmxGsJ0u9on4Nhna6ozou
         PkzATyWX6YPGpyEQ6kKPo2fhjbKYzVVdiOewp7qTpe7LwBGjn+CBfilLNb7QIZeAO9
         wSzYPmuNwN2vFL7Qn/pjwed64RXpiW/iVTy+GcTI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 040/101] PM: hibernate: remove the bogus call to get_gendisk() in software_resume()
Date:   Sun, 18 Oct 2020 15:19:25 -0400
Message-Id: <20201018192026.4053674-40-sashal@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 428805c0c5e76ef643b1fbc893edfb636b3d8aef ]

get_gendisk grabs a reference on the disk and file operation, so this
code will leak both of them while having absolutely no use for the
gendisk itself.

This effectively reverts commit 2df83fa4bce421f ("PM / Hibernate: Use
get_gendisk to verify partition if resume_file is integer format")

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/hibernate.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 02ec716a49271..0e60e10ed66a3 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -851,17 +851,6 @@ static int software_resume(void)
 
 	/* Check if the device is there */
 	swsusp_resume_device = name_to_dev_t(resume_file);
-
-	/*
-	 * name_to_dev_t is ineffective to verify parition if resume_file is in
-	 * integer format. (e.g. major:minor)
-	 */
-	if (isdigit(resume_file[0]) && resume_wait) {
-		int partno;
-		while (!get_gendisk(swsusp_resume_device, &partno))
-			msleep(10);
-	}
-
 	if (!swsusp_resume_device) {
 		/*
 		 * Some device discovery might still be in progress; we need
-- 
2.25.1

