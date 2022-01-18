Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E56491A92
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352721AbiARDA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54926 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349583AbiARCtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:49:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F060B81235;
        Tue, 18 Jan 2022 02:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFF0C36AF2;
        Tue, 18 Jan 2022 02:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474187;
        bh=RKOUeEIT2OTdH0HT/qTJnMAncQPd625vzYG4H7TFQig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZ0RUYuOwsl61YFhY1GsPrvUlcB/0LE67VO7lhDVvXmQRMsb9zERF7LfhuLtarCuu
         owTIAY6HvfxOijXW8b5WOE2QDG+Im2DQTdl6ZaDRuajIQ2ZGXlEBhXVqQddTacjDi5
         kLJDKKwFiABsSyV8uJhD1aF7N2JQm6H3Q26DoBQw6rLKFnih8aFYl+5SBVke6l+xh6
         12bwwx5e9S8MgUW7ALPidsZiT3sfsF3y3NiDZ2EmAk11nhJ/eQ2oqdlGO4Dcy/pHWY
         ot/EyN836TVVGoRTR4Y5MVHmGckheCm/z+GMgAPZI55fPLy+N9ydJDGWm1mEvojlL8
         uPQdAdHk2EOKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/56] HID: apple: Do not reset quirks when the Fn key is not found
Date:   Mon, 17 Jan 2022 21:48:25 -0500
Message-Id: <20220118024908.1953673-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit a5fe7864d8ada170f19cc47d176bf8260ffb4263 ]

When a keyboard without a function key is detected, instead of removing
all quirks, remove only the APPLE_HAS_FN quirk.

Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 4e3dd3f55a963..80ecbf14d3c82 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -392,7 +392,7 @@ static int apple_input_configured(struct hid_device *hdev,
 
 	if ((asc->quirks & APPLE_HAS_FN) && !asc->fn_found) {
 		hid_info(hdev, "Fn key not found (Apple Wireless Keyboard clone?), disabling Fn key handling\n");
-		asc->quirks = 0;
+		asc->quirks &= ~APPLE_HAS_FN;
 	}
 
 	return 0;
-- 
2.34.1

