Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7876323E34
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhBXN0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236136AbhBXNN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:13:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00A9F64FA5;
        Wed, 24 Feb 2021 12:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171352;
        bh=CsiyArIVj6x1Znws/4b4i2+T1P7r/qrhvb38gvpN6cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhAFJr5pqLr1F1+0tfu1lpG6uj4nhGk8Kp5cd5SeVnA5p/YDbgwYU/Jla3BRiMsYH
         kjvqYTcXeivPQZiU7L3FUlvuWm4ZYNArpQMeU/w9+TQ0H8tKW4kpdVR91L7K4zSi+L
         nOrAh1OX08KiTotyV/VY1Q4UUxQ8ccGoAM0W88xxfvGFWCTA3xwCjUOpZGdU0GLUO5
         z9LVzIwXVi9dyVlKZ1F79K4WdBzxzqc0eml/+FNLAr9jxhW+P9tqZ4fVckuLO2fYum
         414R+MRO54YuOo77F3WrENODO9LWmcexDN3yyRy0FDmaEpRcG2Z7l0T3j2rI5gc3ZQ
         oN+vGBJvHsG8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Gromm <christian.gromm@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.9 09/12] staging: most: sound: add sanity check for function argument
Date:   Wed, 24 Feb 2021 07:55:37 -0500
Message-Id: <20210224125540.484221-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125540.484221-1-sashal@kernel.org>
References: <20210224125540.484221-1-sashal@kernel.org>
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
index e4198e5e064b5..288c7bf129457 100644
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

