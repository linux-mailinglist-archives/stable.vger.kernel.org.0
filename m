Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542F8406340
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhIJArN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234421AbhIJAXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AABD660FC0;
        Fri, 10 Sep 2021 00:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233330;
        bh=oKM4h4sSszh3tyXPxlVi2ZB8z/da0OOGWRHqYDw1HZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgo8OwsKEUFQ6y4V2VYf9UwvSm5vhD8PXK+x1ZFLKFKOWDveqwxmCq3K7ByUYLVJ7
         BHP7K5foxL/wRxZYdOvV7v/PLT07MOi5jJAlZcBNPrGQxRzEhsEGPgWRBOQJRDgIht
         U8pURKLBWtlyxGWDljmQ3wBv2xS/r5n4tfuco57t3x3/cPibnx+MtEdO843ZQyvyF1
         oUwuZgo4PRFWJIc8QLXGOBNoSE7vh7PiFFfqMzRJhW+q71e8g4z90BCQ1LMtU3U/oQ
         yMFbmY95X2nenoLEtXQGQDOf26ZaJqbJPK5QIpZoCrb7OBhWE1bWKNJv10rpkbkYkC
         kUDz9lm+82TOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ulrich=20Sp=C3=B6rlein?= <uqs@FreeBSD.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/37] HID: sony: Fix more ShanWan clone gamepads to not rumble when plugged in.
Date:   Thu,  9 Sep 2021 20:21:25 -0400
Message-Id: <20210910002143.175731-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulrich Spörlein <uqs@FreeBSD.org>

[ Upstream commit bab94e97323baefe0afccad66e776f9c78b4f521 ]

The device string on these can differ, apparently, including typos. I've
bought 2 of these in 2012 and googling shows many folks out there with
that broken spelling in their dmesg.

Signed-off-by: Ulrich Spörlein <uqs@FreeBSD.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sony.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 2f073f536070..cdff43defe88 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -2847,7 +2847,8 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (!strcmp(hdev->name, "FutureMax Dance Mat"))
 		quirks |= FUTUREMAX_DANCE_MAT;
 
-	if (!strcmp(hdev->name, "SHANWAN PS3 GamePad"))
+	if (!strcmp(hdev->name, "SHANWAN PS3 GamePad") ||
+	    !strcmp(hdev->name, "ShanWan PS(R) Ga`epad"))
 		quirks |= SHANWAN_GAMEPAD;
 
 	sc = devm_kzalloc(&hdev->dev, sizeof(*sc), GFP_KERNEL);
-- 
2.30.2

