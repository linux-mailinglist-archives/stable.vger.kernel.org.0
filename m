Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DA1491C67
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356032AbiARDPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346676AbiARDI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:08:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FBDC06175D;
        Mon, 17 Jan 2022 18:51:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CE07B81258;
        Tue, 18 Jan 2022 02:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFE4C36AF3;
        Tue, 18 Jan 2022 02:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474286;
        bh=+0PMCPFJn7nX+bXhEzg0RONY2GIh1YcE9doSXyviagA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBlFSQiVqahO5ea1XRtn6kCOEnBpkwEN5GgwIL90C1ZOiWs1aK0LpTOhR6g/Dpqp4
         Gyb1mIyVahgF28NLbfHKokH4p+9gBrdJ9b2mSnsUpFsC9PizQtpvAWKiSGW7AxBIvm
         ZXT6DcyGn83NqVo25J1FgIXtS4q4tEimZYXaSluxJnLQ8KtBst+ntNgLYM3rs/nv9u
         nbMqqDJEORGcRKmuDtaPAttfaygTjZH6+zMqb64CEayPeUE0HmPUPS4zdPos2yKLoT
         qxhwhKR2EgqUt5x/EixKhIvy96QygQbpH+coBr3JxTG4ltMw2IL/97J91LgVM3yxQc
         rwDsqo8ATUKJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/33] HID: apple: Do not reset quirks when the Fn key is not found
Date:   Mon, 17 Jan 2022 21:50:47 -0500
Message-Id: <20220118025116.1954375-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118025116.1954375-1-sashal@kernel.org>
References: <20220118025116.1954375-1-sashal@kernel.org>
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

