Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA65849182D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344861AbiARCog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58810 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347305AbiARClH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:41:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5280560AB1;
        Tue, 18 Jan 2022 02:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03573C36AEB;
        Tue, 18 Jan 2022 02:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473666;
        bh=mTzcCRXvRXdFMvGvyeb2rwfSPt4Nj5V1BB1LEiRqQ70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUsP3TDZJWiJsA6kFF4/8WBAFRn/107289c6PrF9yOTnUN5KrjsJEqYRsWE/kQnD0
         Go37173SZaPVLj4SjMTaY4UlxUYIVwhoVIf1U608Ufzf6mOpkbeGhtsZAyE64LU5tq
         6RdmO+CbB1LMzrHzFqv0kID7TYycxJ2ln15TJPuWx07DchIVaM34hDcrovP1xsrwpp
         yip9zIn2iT7CeDBTKgvBPQRZET6vOmIPUOjk2qRr09LWq3cFGINubxcLhD3kAWDZmr
         3lc6AQwuRfGAVWDzn4EFQEhqJwFBKhPpvSsmH6wwyxm1Ks1Q9fBm/8AeS1rMR8QZ31
         79dxU5EzeRj8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 018/116] HID: apple: Do not reset quirks when the Fn key is not found
Date:   Mon, 17 Jan 2022 21:38:29 -0500
Message-Id: <20220118024007.1950576-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 5c1d33cda863b..e5d2e7e9541b8 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -415,7 +415,7 @@ static int apple_input_configured(struct hid_device *hdev,
 
 	if ((asc->quirks & APPLE_HAS_FN) && !asc->fn_found) {
 		hid_info(hdev, "Fn key not found (Apple Wireless Keyboard clone?), disabling Fn key handling\n");
-		asc->quirks = 0;
+		asc->quirks &= ~APPLE_HAS_FN;
 	}
 
 	return 0;
-- 
2.34.1

