Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A03E323DF2
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbhBXNUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236023AbhBXNI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:08:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B042564F95;
        Wed, 24 Feb 2021 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171288;
        bh=lUJimLn+T5S/ny3LbdJ97oMNo6gihYSp2aP0IgO8R/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kou9wJry9tQok+zfnxgP0QrLh05fuPVrTF5uTbw01pQNqNKyDaqpEsUgAH+9PJslg
         wHEJiCqbjmXmCL9aldSJvkFNvZMPnin7n2ZznkxLBxYiDjbcvUB3Ctz4K4wKaaNLnX
         70/bJQWoX3et1kzwmhKYu5OR1faeNGwSCIQ0kZscnvb8KA3quXEEhRCLF3aj4o4Do3
         ShNHdx8X8/6eJ91ayStZtGKwc/js/co2nwk42I9WK+hyR4c2/SeRSj1j1nHlQHgm4e
         210dsDEqQJBigV0ObQTz76k5uqt9KhHW0mlXWPpoeEIKBhcQQhyH13L7SpesRjK8wn
         kn2qNdgdK6cgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Gromm <christian.gromm@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.19 10/26] staging: most: sound: add sanity check for function argument
Date:   Wed, 24 Feb 2021 07:54:18 -0500
Message-Id: <20210224125435.483539-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125435.483539-1-sashal@kernel.org>
References: <20210224125435.483539-1-sashal@kernel.org>
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
index 89b02fc305b8b..fd9245d7eeb9a 100644
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

