Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AD8498A3D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiAXTCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:02:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56126 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344165AbiAXS6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:58:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E94A4B8122F;
        Mon, 24 Jan 2022 18:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A08C340E5;
        Mon, 24 Jan 2022 18:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050698;
        bh=+0PMCPFJn7nX+bXhEzg0RONY2GIh1YcE9doSXyviagA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTnQ6D00rw2cKE0/1U+7ujWlhFa98V8fKTRMrejd0ceHu5LzeQRnT9mNOlIP/Nu46
         BuQ4I3tZNPJCDaanz7vQhAZeFlVosc0DOLDga+SN9TD5iFrY7u1+IjGdZBA9mw0N0R
         IW0ipgYfSIJ72WfuF7VPvhM9wfrk4N0LiQjJx2uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 077/157] HID: apple: Do not reset quirks when the Fn key is not found
Date:   Mon, 24 Jan 2022 19:42:47 +0100
Message-Id: <20220124183935.228809192@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 149902619cbc8..0074091c27aa2 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -390,7 +390,7 @@ static int apple_input_configured(struct hid_device *hdev,
 
 	if ((asc->quirks & APPLE_HAS_FN) && !asc->fn_found) {
 		hid_info(hdev, "Fn key not found (Apple Wireless Keyboard clone?), disabling Fn key handling\n");
-		asc->quirks = 0;
+		asc->quirks &= ~APPLE_HAS_FN;
 	}
 
 	return 0;
-- 
2.34.1



