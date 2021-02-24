Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91978323D1E
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbhBXNEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:04:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235532AbhBXM6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:58:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C036964F40;
        Wed, 24 Feb 2021 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171152;
        bh=1qi2WOnyjUkqhF6El67q7UMDFB1yuxLPg7/v12qY0BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnWF2g37CJgbZWYT4HD2jk3/7Kp5UnDRIVI2W9z4DeIcKrhLVe67RBIEL+7prFgFi
         o9SXK2r/ohnNmqY3IQs/S5PF5EE3JLgyDbh8w8rWcvuv/56O2l4B+W0zWis1zM42bJ
         pKERfUJmDy7v1XXe6pGvR9Ywj9raAmkc1F/3Bd6ftjetWtv79Z+YrWIXaCYtl4TaT4
         Y4xLoljwAQ/27MeAO6xl1+MO+NFa1wvUbGWzEh5WI1Y99sOQ4i2n2vXF3lukUC2Qah
         MqItF5eSzKgTW4ordXmP7Lr9AUhIJHNnnCO6RvkoYuQY7TgNipP9UxmC/YHqwVhw8S
         rn7/hYoQswX5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Gromm <christian.gromm@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.10 15/56] staging: most: sound: add sanity check for function argument
Date:   Wed, 24 Feb 2021 07:51:31 -0500
Message-Id: <20210224125212.482485-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
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
index 8a449ab9bdce4..b7666a7b1760a 100644
--- a/drivers/staging/most/sound/sound.c
+++ b/drivers/staging/most/sound/sound.c
@@ -96,6 +96,8 @@ static void swap_copy24(u8 *dest, const u8 *source, unsigned int bytes)
 {
 	unsigned int i = 0;
 
+	if (bytes < 2)
+		return;
 	while (i < bytes - 2) {
 		dest[i] = source[i + 2];
 		dest[i + 1] = source[i + 1];
-- 
2.27.0

