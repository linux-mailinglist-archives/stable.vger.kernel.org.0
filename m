Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8D9BA816
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395270AbfIVTBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395261AbfIVTBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:01:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC49B2070C;
        Sun, 22 Sep 2019 19:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178868;
        bh=74yDVWR/ILsO2aE70U+M2wJKsF551xYFuOmbv1Er/4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4OqDAeZgXjdpT9jkj3bgH888VEDmIfLUYGVzbxEiIIhsNbJZzRXUgut/blteUqB7
         AQCb5KgWdS2qwIsphULi73vqIhW/5qGrbu1LJdkLoO47AZ3H0qizNdGq15HoBMOfk4
         UT5uBtDOAYy+YhB5Np8XRYNUBnQoq3Uz0mHwTeUw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Stoughton <nstoughton@logitech.com>,
        Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/44] leds: leds-lp5562 allow firmware files up to the maximum length
Date:   Sun, 22 Sep 2019 15:00:22 -0400
Message-Id: <20190922190103.4906-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922190103.4906-1-sashal@kernel.org>
References: <20190922190103.4906-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Stoughton <nstoughton@logitech.com>

[ Upstream commit ed2abfebb041473092b41527903f93390d38afa7 ]

Firmware files are in ASCII, using 2 hex characters per byte. The
maximum length of a firmware string is therefore

16 (commands) * 2 (bytes per command) * 2 (characters per byte) = 64

Fixes: ff45262a85db ("leds: add new LP5562 LED driver")
Signed-off-by: Nick Stoughton <nstoughton@logitech.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lp5562.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp5562.c b/drivers/leds/leds-lp5562.c
index 0360c59dbdc91..fc8b2e7bcfef6 100644
--- a/drivers/leds/leds-lp5562.c
+++ b/drivers/leds/leds-lp5562.c
@@ -263,7 +263,11 @@ static void lp5562_firmware_loaded(struct lp55xx_chip *chip)
 {
 	const struct firmware *fw = chip->fw;
 
-	if (fw->size > LP5562_PROGRAM_LENGTH) {
+	/*
+	 * the firmware is encoded in ascii hex character, with 2 chars
+	 * per byte
+	 */
+	if (fw->size > (LP5562_PROGRAM_LENGTH * 2)) {
 		dev_err(&chip->cl->dev, "firmware data size overflow: %zu\n",
 			fw->size);
 		return;
-- 
2.20.1

