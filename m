Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931A6323D7C
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhBXNMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:12:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235676AbhBXNEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:04:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3796E64F6E;
        Wed, 24 Feb 2021 12:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171234;
        bh=iFGODoxstryWh9z46Hsroy1kCvg8rG/P4tVB0R/u83A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5qqzU/hgS26D6KpX8yxXfCRF584gSYfU+5u779/8wS4rmi5x289VmgPqW7m/YcVt
         0Sb/tGseSLZN+ogNlHP/izE2Bq3U6yco+b6Til85rGyP2Al2LOxHe34Q/WQUdkGTB7
         0/sUspYlB7eoM3zG8oVLRS2t9/3Zaq+rJhWy9kiLCIvoJH+29YocuT/KPyX7O2YHvo
         N7TJGpVh0CSjKI4riW4ydINyu3q/CvnMKl8atsB+8kzT5JgIYjlhpxfUJbYZLGThgT
         tOX2zal631DCfFz0a3pF068+5d5PTKCNjZzVq0pXgt0Tyo8GfUKllUrza74bmcvFfM
         t3UDiBePpaXow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Gromm <christian.gromm@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.4 10/40] staging: most: sound: add sanity check for function argument
Date:   Wed, 24 Feb 2021 07:53:10 -0500
Message-Id: <20210224125340.483162-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
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
 drivers/staging/most/sound/sound.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/most/sound/sound.c b/drivers/staging/most/sound/sound.c
index 79817061fcfa4..4225ee9fcf7bf 100644
--- a/drivers/staging/most/sound/sound.c
+++ b/drivers/staging/most/sound/sound.c
@@ -98,6 +98,8 @@ static void swap_copy24(u8 *dest, const u8 *source, unsigned int bytes)
 {
 	unsigned int i = 0;
 
+	if (bytes < 2)
+		return;
 	while (i < bytes - 2) {
 		dest[i] = source[i + 2];
 		dest[i + 1] = source[i + 1];
-- 
2.27.0

