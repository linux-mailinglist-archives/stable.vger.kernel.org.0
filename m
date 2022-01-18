Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E8C491B18
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349109AbiARDDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347681AbiARC5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:57:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF91C0613BA;
        Mon, 17 Jan 2022 18:44:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DF3FB8125D;
        Tue, 18 Jan 2022 02:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308C9C36AE3;
        Tue, 18 Jan 2022 02:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473895;
        bh=1AC9kSNkKHKjHLUFTivSrUAlNSvN3ie5d3LvlLeVE9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnfxzOd5KkwGfktcf0150s/X+Tq6bj6PycsfHdHW/R40cvkxQPNTdvyEmKa2nNNU4
         gqFyst3E+w34c9xDz4eQditiHZdo6vEOTaku+Fjyn+EMOYQQjS2DQTgPQ14ZiGW8m6
         uvYjJvfqTkLb815FOjVZJp2kYo9/7JrsNgClWQBLOkWuS6bCZF9CDdz3ftWZrSFFm3
         p4mBFhGZbFzta/EHU3XRbFKkFk9Dg4piAcvIYlbQGEJP4VYlp38CWDt/QGTjHBzp5w
         caMg+S2mYdghT8AoIcJSW8qJ866RWhRArkYcfJpMpGMbqugY+v0xkwtZwiCzS5XN7i
         BXDHoneb/+6zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/73] HID: apple: Do not reset quirks when the Fn key is not found
Date:   Mon, 17 Jan 2022 21:43:30 -0500
Message-Id: <20220118024432.1952028-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index 07df64daf7dae..efce31d035ef5 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -389,7 +389,7 @@ static int apple_input_configured(struct hid_device *hdev,
 
 	if ((asc->quirks & APPLE_HAS_FN) && !asc->fn_found) {
 		hid_info(hdev, "Fn key not found (Apple Wireless Keyboard clone?), disabling Fn key handling\n");
-		asc->quirks = 0;
+		asc->quirks &= ~APPLE_HAS_FN;
 	}
 
 	return 0;
-- 
2.34.1

