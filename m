Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BEE3A9FE8
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhFPPm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235275AbhFPPj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D834661351;
        Wed, 16 Jun 2021 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857822;
        bh=ewBxHwmu+PcHoCfNmRdf7wetx4+AcOOFNVgj1mOHnnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ob8Fo5TPXQQD4vgWqhhCU8xVunl7BvyzSFBejbnyXuJAffsut/Z4xaPnxrLrCeubg
         7PRBKu9Ul8NMTl/gXS+IcJ7QlE8nHNljuEpMDLYExcs4TnV5FStb7qGNTl3by5JZVt
         f31dKghVKvOZFWAFRrtaSX0j4ah11JoPu8LVdevE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luke D Jones <luke@ljones.dev>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 02/48] HID: asus: Filter keyboard EC for old ROG keyboard
Date:   Wed, 16 Jun 2021 17:33:12 +0200
Message-Id: <20210616152836.731441538@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



