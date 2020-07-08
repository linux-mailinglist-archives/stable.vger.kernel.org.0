Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6831F218B96
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgGHPl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730418AbgGHPl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:41:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF2D52082E;
        Wed,  8 Jul 2020 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594222886;
        bh=FQg28pZt+7K/1SzykRlPYg/cmwSTa5s6SlM60cpHuSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2FbamX8xQT45e88Bp/5Ehg6gBwl3jm/dTrZseNGD3cEMffo4KzGbtAHNSNL+22ev
         lyCTR92N9H9o/w9/8yVILJ0Jac3ryTxFKf1Fif2oS41sx8aaVIYH2GazhsWzXoBI61
         s8a+OY1WAs9j9D7B51xm09rD29FIAYhA/vrs5c34=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Hyeongseok.Kim" <Hyeongseok@gmail.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 07/30] exfat: Set the unused characters of FileName field to the value 0000h
Date:   Wed,  8 Jul 2020 11:40:53 -0400
Message-Id: <20200708154116.3199728-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708154116.3199728-1-sashal@kernel.org>
References: <20200708154116.3199728-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Hyeongseok.Kim" <Hyeongseok@gmail.com>

[ Upstream commit 4ba6ccd695f5ed3ae851e59b443b757bbe4557fe ]

Some fsck tool complain that padding part of the FileName field
is not set to the value 0000h. So let's maintain filesystem cleaner,
as exfat's spec. recommendation.

Signed-off-by: Hyeongseok.Kim <Hyeongseok@gmail.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index 4b91afb0f0515..349ca0c282c2c 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -430,10 +430,12 @@ static void exfat_init_name_entry(struct exfat_dentry *ep,
 	ep->dentry.name.flags = 0x0;
 
 	for (i = 0; i < EXFAT_FILE_NAME_LEN; i++) {
-		ep->dentry.name.unicode_0_14[i] = cpu_to_le16(*uniname);
-		if (*uniname == 0x0)
-			break;
-		uniname++;
+		if (*uniname != 0x0) {
+			ep->dentry.name.unicode_0_14[i] = cpu_to_le16(*uniname);
+			uniname++;
+		} else {
+			ep->dentry.name.unicode_0_14[i] = 0x0;
+		}
 	}
 }
 
-- 
2.25.1

