Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2183611B363
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388438AbfLKPmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733158AbfLKP1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:27:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F1022B48;
        Wed, 11 Dec 2019 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078067;
        bh=q4EDO/rb9A/b9s2CJUZksjMebgKe2dnUr4tV83NWOro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M19Dfo2FIW5qQrynyKVsW0cZLdIBkC1mGMXtdf1G/G64CrHD5JRhUqxggyMx4FHI1
         1eHWUAFgHMAACAU7NqSbhyg6XznIozIRZl1Wz94uSiqulgxvfiXZJgj/sjJ+Uq1n5/
         sHBbWzZIdqkNEaDV4ClBFobIY29YvVeREVnlgRZI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 59/79] scsi: scsi_debug: num_tgts must be >= 0
Date:   Wed, 11 Dec 2019 10:26:23 -0500
Message-Id: <20191211152643.23056-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit aa5334c4f3014940f11bf876e919c956abef4089 ]

Passing the parameter "num_tgts=-1" will start an infinite loop that
exhausts the system memory

Link: https://lore.kernel.org/r/20191115163727.24626-1-mlombard@redhat.com
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 65305b3848bc5..a1dbae806fdea 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5351,6 +5351,11 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
+	if (sdebug_num_tgts < 0) {
+		pr_err("num_tgts must be >= 0\n");
+		return -EINVAL;
+	}
+
 	if (sdebug_guard > 1) {
 		pr_err("guard must be 0 or 1\n");
 		return -EINVAL;
-- 
2.20.1

