Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900AC29BE9D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1804840AbgJ0QxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794728AbgJ0PNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:13:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864DE20657;
        Tue, 27 Oct 2020 15:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811594;
        bh=fw2+3HObc/6dhZY7E+lLxPRYmfiS4/B+F6GDPGTuqpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cafMEkyUQ6TG5GEGinfE6xXaCHFfeJHyMSc35zmoba/EW175fPfYaKgs2rQ8aF68S
         JMlHphyt5kcvgNXKwurx+4hm4dcwPUmoU+WCKbedIzWGbhpEjjJdSMliJDtYsdbS05
         vMHYsaDUyzhHilFxgVoUiXuP2O1Q0C0Xv4Z97BFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 517/633] lightnvm: fix out-of-bounds write to array devices->info[]
Date:   Tue, 27 Oct 2020 14:54:20 +0100
Message-Id: <20201027135547.013386193@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit a48faebe65b0db55a73b9220c3d919eee849bb79 ]

There is an off-by-one array check that can lead to a out-of-bounds
write to devices->info[i].  Fix this by checking by using >= rather
than > for the size check. Also replace hard-coded array size limit
with ARRAY_SIZE on the array.

Addresses-Coverity: ("Out-of-bounds write")
Fixes: cd9e9808d18f ("lightnvm: Support for Open-Channel SSDs")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
index db38a68abb6c0..a6f4ca438bca1 100644
--- a/drivers/lightnvm/core.c
+++ b/drivers/lightnvm/core.c
@@ -1315,8 +1315,9 @@ static long nvm_ioctl_get_devices(struct file *file, void __user *arg)
 		strlcpy(info->bmname, "gennvm", sizeof(info->bmname));
 		i++;
 
-		if (i > 31) {
-			pr_err("max 31 devices can be reported.\n");
+		if (i >= ARRAY_SIZE(devices->info)) {
+			pr_err("max %zd devices can be reported.\n",
+			       ARRAY_SIZE(devices->info));
 			break;
 		}
 	}
-- 
2.25.1



