Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26B9323CBD
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbhBXMyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:54:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235213AbhBXMwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:52:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 405F264F0C;
        Wed, 24 Feb 2021 12:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171053;
        bh=V0Jtes5QH5wPVDch45R62HOal7hC4mFXOyhXQd8ngyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVuIzGijycOvLI1T4hlFDPO0pTFqpCOEC7NaQ6wmtcH/he+vMBdj5Y5WyJ2/HbR+W
         pJTcAkI3SKi0klGIN8g9BU7/FCtGPdQmWE+lqtFjRjQHuQjV7MfnP5LU6h8vzrmkNp
         xH4CTVT8X1wd1VIq2aqRwlKko2Evi+mmaUJjgmWz28lEw1VtCk1FSiu7FSe0BuSI4n
         rgMXGAN5XE/5bbTdOzqDIWdBXA6Y69sTmO1/YXup+q20m2rEPMKCnNszY6W4v1w0Fp
         nl2QzsgSMcIsR9UzhDOytwkBQxfp3N3Zwc0o5Asnb0qQuQ5ub1oN6Y3a9myWMmZVZo
         tzbY2oxjlWS0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Gromm <christian.gromm@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.11 19/67] staging: most: sound: add sanity check for function argument
Date:   Wed, 24 Feb 2021 07:49:37 -0500
Message-Id: <20210224125026.481804-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
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
index 3a1a590580427..45befb8c11268 100644
--- a/drivers/staging/most/sound/sound.c
+++ b/drivers/staging/most/sound/sound.c
@@ -86,6 +86,8 @@ static void swap_copy24(u8 *dest, const u8 *source, unsigned int bytes)
 {
 	unsigned int i = 0;
 
+	if (bytes < 2)
+		return;
 	while (i < bytes - 2) {
 		dest[i] = source[i + 2];
 		dest[i + 1] = source[i + 1];
-- 
2.27.0

