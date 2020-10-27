Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8C129C5B5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756254AbgJ0OMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754696AbgJ0OGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:06:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22D1122284;
        Tue, 27 Oct 2020 14:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807593;
        bh=ixusXLZ0622zxJIC0QBU4XnVhfywpHExuB4ujs6RIvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7/n+zpUdID1vgz7IpDiQwTxh7ljRhfAH3nkVYI4LSUAz+syLFJDOS8VrkDJ17sLA
         w9S/lhlFPT3Fhx18L7aaLiEzZUKusbJgsSdRcIY8feQ7Oy4yvNUGclGlBIgvN+X8OJ
         UVITQ9jDHWBZYXM5FMN51oaZxa9qkVOVe+hhugYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 110/139] PM: hibernate: remove the bogus call to get_gendisk() in software_resume()
Date:   Tue, 27 Oct 2020 14:50:04 +0100
Message-Id: <20201027134907.364052407@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3c775d6b7317f..7b393faf930f8 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -834,17 +834,6 @@ static int software_resume(void)
 
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



