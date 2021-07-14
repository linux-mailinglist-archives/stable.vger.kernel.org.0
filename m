Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CCF3C9089
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhGNTzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241189AbhGNTu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF54E613EC;
        Wed, 14 Jul 2021 19:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292035;
        bh=WbcAoORSEo3xrjNUt8TS+8PA0uazBmuXqcBbv3NVmi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1De6OUQilspmAbLau4y8GG48K0Y4kw0fmpBrB83YvEWmkjQ8k1O69M5wsSdkWKe8
         wFb4m3veWig2v/nYqxzVBWWoLCtkm85fXsZ0Mc0+P+H5iNWjTuYEnxok6dcEih3Ofd
         Am1DaxCiFV0zhiALLwMAETsIBDWQYrwhBAE6G3tHKw9uiNbYB5sZK6yV2q1xFaelOn
         CocNHxG/2Rm6Z+gyvnQKtCdMzTBhogU7KRhyvZo2RgopTDUpVKCf5omv7mmbLajqjK
         YiIYZ6vdoKjSDtQrWkd3qiGfyjbyLJHXjnCAT0uP9BnhILSbJ/O/WIr6KSKCeo+vqE
         ZrujY1P7GYH1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 35/39] scsi: aic7xxx: Fix unintentional sign extension issue on left shift of u8
Date:   Wed, 14 Jul 2021 15:46:20 -0400
Message-Id: <20210714194625.55303-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 332a9dd1d86f1e7203fc7f0fd7e82f0b304200fe ]

The shifting of the u8 integer returned fom ahc_inb(ahc, port+3) by 24 bits
to the left will be promoted to a 32 bit signed int and then sign-extended
to a u64. In the event that the top bit of the u8 is set then all then all
the upper 32 bits of the u64 end up as also being set because of the
sign-extension. Fix this by casting the u8 values to a u64 before the 24
bit left shift.

[ This dates back to 2002, I found the offending commit from the git
history git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git,
commit f58eb66c0b0a ("Update aic7xxx driver to 6.2.10...") ]

Link: https://lore.kernel.org/r/20210621151727.20667-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Addresses-Coverity: ("Unintended sign extension")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 49e02e874553..fe15746af520 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -500,7 +500,7 @@ ahc_inq(struct ahc_softc *ahc, u_int port)
 	return ((ahc_inb(ahc, port))
 	      | (ahc_inb(ahc, port+1) << 8)
 	      | (ahc_inb(ahc, port+2) << 16)
-	      | (ahc_inb(ahc, port+3) << 24)
+	      | (((uint64_t)ahc_inb(ahc, port+3)) << 24)
 	      | (((uint64_t)ahc_inb(ahc, port+4)) << 32)
 	      | (((uint64_t)ahc_inb(ahc, port+5)) << 40)
 	      | (((uint64_t)ahc_inb(ahc, port+6)) << 48)
-- 
2.30.2

