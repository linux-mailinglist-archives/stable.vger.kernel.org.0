Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8595539E1CB
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhFGQOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231282AbhFGQOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E00E6135D;
        Mon,  7 Jun 2021 16:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082338;
        bh=ewBxHwmu+PcHoCfNmRdf7wetx4+AcOOFNVgj1mOHnnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuBrubhFrF1Mm1tHxbjkqxayTFusoXv1z3gIXd64ijYEL3QOhORl41kJFldmDgJGG
         xsCjF1XiRVHLA8AEBkPl/d/5Uzl85jvkTgKdCWWP2U6LjUmhF+e3aHX8NxeKXV5+yi
         C7VokQJrpdexlqHVoUOm6/V9gQ4QDEp/9485hCns8VqmkybKKlZRE1/d2U1349JCnO
         jRLxFI8T1x+JPIPXbdsy1S3UAKfAWPcTQfAlXToBvMmUL841GmbaFUvUAokzVK5EA6
         Z7F9KNH6UFz08miF7aJvM98bZgow0hkhFVPG7FX7qBxpQett2kWMTDoxnvKHER6sCl
         NibkEeOuUjHPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luke D Jones <luke@ljones.dev>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 02/49] HID: asus: Filter keyboard EC for old ROG keyboard
Date:   Mon,  7 Jun 2021 12:11:28 -0400
Message-Id: <20210607161215.3583176-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke D Jones <luke@ljones.dev>

[ Upstream commit 4bfb2c72b2bfca8684c2f5c25a3119bad016a9d3 ]

Older ROG keyboards emit a similar stream of bytes to the new
N-Key keyboards and require filtering to prevent a lot of
unmapped key warnings showing. As all the ROG keyboards use
QUIRK_USE_KBD_BACKLIGHT this is now used to branch to filtering
in asus_raw_event.

Signed-off-by: Luke D Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 2ab22b925941..1ed1c05c3d54 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -335,7 +335,7 @@ static int asus_raw_event(struct hid_device *hdev,
 	if (drvdata->quirks & QUIRK_MEDION_E1239T)
 		return asus_e1239t_event(drvdata, data, size);
 
-	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
+	if (drvdata->quirks & QUIRK_USE_KBD_BACKLIGHT) {
 		/*
 		 * Skip these report ID, the device emits a continuous stream associated
 		 * with the AURA mode it is in which looks like an 'echo'.
-- 
2.30.2

