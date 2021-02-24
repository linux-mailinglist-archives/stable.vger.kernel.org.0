Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49368323DE3
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbhBXNUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:20:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234796AbhBXNLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:11:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D66D664F9C;
        Wed, 24 Feb 2021 12:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171326;
        bh=3bDrxiJIxCJ6ws1uYlYE4vk36EcokGT9rHS0DnfDQ08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jORAUISRZTsLf6X8907z3S2NmrkkRod6hsePmMZuYdn1/g+nze/7B7y/aReOxs+kd
         TBqZDoB5eI40H+DtajcesbVlX07aN1AURIitpsCMNssbY+eAqZ1VMdt1+MhCKqugw+
         YYz7AIHPy44aSOu2p7a8TETa9RvZoTZWf8v5UI2JLZtNtfMPRxsVx0rNrrAV6qa1/z
         IxQIXrwy1EqKbJ1y/bLM0H71k4sUlMRAtk+tGcyjWv8HoNIiSGdJgDPp9/yO8ir3IP
         DFbmHc2evHkY7M6QBm3B4tthEpaNY43p/8qorka0nGyjOn9/LyiB9dIAjdv8nMvhhA
         fOR/a4nR+Gb5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Gromm <christian.gromm@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.14 09/16] staging: most: sound: add sanity check for function argument
Date:   Wed, 24 Feb 2021 07:55:06 -0500
Message-Id: <20210224125514.483935-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125514.483935-1-sashal@kernel.org>
References: <20210224125514.483935-1-sashal@kernel.org>
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
index ea1366a440083..e259bf4956ab6 100644
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

