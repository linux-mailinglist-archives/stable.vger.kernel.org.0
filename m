Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519AD5B498E
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiIJVVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiIJVUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D28E4F648;
        Sat, 10 Sep 2022 14:18:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0915B80915;
        Sat, 10 Sep 2022 21:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFFAC43141;
        Sat, 10 Sep 2022 21:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844683;
        bh=lqB1JfxNpThETl4PF4DAqehD8LkBkbi9zagY4uOJHnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngHYDhxEX1K2ORNwdwMuFpqPV4UFf0k2DQtU4Mb1jtuKMz7K0jO9dyGISb9fYxXq8
         5yth7LdMVisPym/r+4X1zYHhqCpMBNpGKvAFEjXlNpPyUUk1gInkYLsC5UqlQ7lip5
         XVIRAJMrVTiV56q6GCVc95vzIMcv0ZWOgvwkWdDF+dnXSd5rEVVhfyg5B3cyVdhGFL
         mLe2KXkm5AEIqqxZFtrPFvg9RXEv3OGWpieG80tNC2Tspm7stzZc8wnnQtxWdVc1v8
         VJajtUBhKT5TQTSFAaZTt3JzwaepYUR3ss3GQeuGziuq6tfqnPHDIVud2s1UxzMcfX
         z7CEFFg6YZlMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Kilmer <srjek2@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        benjamin.tissoires@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/21] HID: asus: ROG NKey: Ignore portion of 0x5a report
Date:   Sat, 10 Sep 2022 17:17:37 -0400
Message-Id: <20220910211752.70291-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211752.70291-1-sashal@kernel.org>
References: <20220910211752.70291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Kilmer <srjek2@gmail.com>

[ Upstream commit 1c0cc9d11c665020cbeb80e660fb8929164407f4 ]

On an Asus G513QY, of the 5 bytes in a 0x5a report, only the first byte
is a meaningful keycode. The other bytes are zeroed out or hold garbage
from the last packet sent to the keyboard.

This patch fixes up the report descriptor for this event so that the
general hid code will only process 1 byte for keycodes, avoiding
spurious key events and unmapped Asus vendor usagepage code warnings.

Signed-off-by: Josh Kilmer <srjek2@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 08c9a9a60ae47..b59c3dafa6a48 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1212,6 +1212,13 @@ static __u8 *asus_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		rdesc = new_rdesc;
 	}
 
+	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD &&
+			*rsize == 331 && rdesc[190] == 0x85 && rdesc[191] == 0x5a &&
+			rdesc[204] == 0x95 && rdesc[205] == 0x05) {
+		hid_info(hdev, "Fixing up Asus N-KEY keyb report descriptor\n");
+		rdesc[205] = 0x01;
+	}
+
 	return rdesc;
 }
 
-- 
2.35.1

