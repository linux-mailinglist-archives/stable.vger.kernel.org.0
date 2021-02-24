Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EB13240B0
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 16:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbhBXPUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 10:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236729AbhBXNqZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:46:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FF3764FC0;
        Wed, 24 Feb 2021 12:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171372;
        bh=iFp58vQo6D05AilguJHqcVbj7g9C3NUuku8bwt18B0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfxHHDanJqZIAtv5r5c9dkG+ZjQ42xp6o0j3vI/zucXXAyjDcBK8GEXLF/Ye/znk8
         Kf26CIaKJ+jhnwxXFRTI0vDu6rDalrLhQvy9CAupgJlP/Grgv6jtaz6fGsByIGzouP
         TIP3kIKzFvhireFCrtt1biJU1J+pcQX+GIUm9c6It9SI2+sFn0KCYtKyKLn8/muZoq
         RGj/QwVev+t03nMjawWogfN6G9guI9O4O6MzszxD5YId9LvuR+upKA4Q0WwRopwC5G
         odibb/bVoQFNUaqoX9zNIsRgmMt0UrG3F4P4H/ONlvYE8ZeeJSkK/lBSgs4tAZ5LMd
         NdYBFF/+S/dDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Gromm <christian.gromm@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.4 09/11] staging: most: sound: add sanity check for function argument
Date:   Wed, 24 Feb 2021 07:55:57 -0500
Message-Id: <20210224125600.484437-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125600.484437-1-sashal@kernel.org>
References: <20210224125600.484437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Gromm <christian.gromm@microchip.com>

[ Upstream commit 45b754ae5b82949dca2b6e74fa680313cefdc813 ]

This patch checks the function parameter 'bytes' before doing the
subtraction to prevent memory corruption.

Signed-off-by: Christian Gromm <christian.gromm@microchip.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/1612282865-21846-1-git-send-email-christian.gromm@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/most/aim-sound/sound.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/most/aim-sound/sound.c b/drivers/staging/most/aim-sound/sound.c
index 9c645801cff4d..532ec0f7100eb 100644
--- a/drivers/staging/most/aim-sound/sound.c
+++ b/drivers/staging/most/aim-sound/sound.c
@@ -92,6 +92,8 @@ static void swap_copy24(u8 *dest, const u8 *source, unsigned int bytes)
 {
 	unsigned int i = 0;
 
+	if (bytes < 2)
+		return;
 	while (i < bytes - 2) {
 		dest[i] = source[i + 2];
 		dest[i + 1] = source[i + 1];
-- 
2.27.0

