Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78D9491496
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245209AbiARCXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245026AbiARCWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:22:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F010C061747;
        Mon, 17 Jan 2022 18:22:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BBED60B01;
        Tue, 18 Jan 2022 02:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD20C36AF2;
        Tue, 18 Jan 2022 02:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472549;
        bh=wgi+j8udB1hBs2lDS+VQzIfA/QubZozAoFQHsIgrftA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ud/NZGx7lWL2w+K16fNEZ5oXmewVO71XNp2sHdLnOChKaVMEpWtjCOF2YKmmJm0yG
         R7xFFB3OmZMvDNt54D+Fab3DN1k2d9avFe/3zCm8AHzaD8t4dRtXhKr6OB1ZYqpI0C
         ukA3tFhi0n4C/Jzu/PFyMWxJpFOwXLDfGE+nZJ6NKJdUIWug0t1mTC07d/7Sc7ejmb
         jB8eYisjkMEwdqjOiMYr5e2X27mduFDZgcDvUBoR9nLLH5YZEzzreq/D2AcQLckn+r
         4i3/baFcDBHCMuIin3v3AV2knqCIF3zXkW7cB3dzvKmofrakJLTSe4owzML30FINWL
         rggpz+roTDCuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 049/217] HID: apple: Do not reset quirks when the Fn key is not found
Date:   Mon, 17 Jan 2022 21:16:52 -0500
Message-Id: <20220118021940.1942199-49-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 2c9c5faa74a97..a4ca5ed00e5f5 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -428,7 +428,7 @@ static int apple_input_configured(struct hid_device *hdev,
 
 	if ((asc->quirks & APPLE_HAS_FN) && !asc->fn_found) {
 		hid_info(hdev, "Fn key not found (Apple Wireless Keyboard clone?), disabling Fn key handling\n");
-		asc->quirks = 0;
+		asc->quirks &= ~APPLE_HAS_FN;
 	}
 
 	return 0;
-- 
2.34.1

