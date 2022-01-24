Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3271498C10
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344523AbiAXTTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347251AbiAXTRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:17:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3204DC094255;
        Mon, 24 Jan 2022 11:06:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E276BB811FC;
        Mon, 24 Jan 2022 19:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AABC36AE9;
        Mon, 24 Jan 2022 19:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051216;
        bh=RKOUeEIT2OTdH0HT/qTJnMAncQPd625vzYG4H7TFQig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgVv6pO0ulkmQp0c6i3dbCGiaLL9d1+UxjYtgm7ofn4XhgcJ0eyNLDcYGM9Vx029s
         noyl+0O3NzLIJDmyBHhE0AVdk9xWdUxO5bGBVrwc1z+hWzvAPv6h89buWCD6N0PVsr
         YSyzAq6TsL+d27nR3ycCXkgOu1FrFe4hjMNU8QXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 091/186] HID: apple: Do not reset quirks when the Fn key is not found
Date:   Mon, 24 Jan 2022 19:42:46 +0100
Message-Id: <20220124183940.042368417@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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



