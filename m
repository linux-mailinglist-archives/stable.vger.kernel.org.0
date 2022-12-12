Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7E2649C9F
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 11:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiLLKnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 05:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbiLLKlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 05:41:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B49F024;
        Mon, 12 Dec 2022 02:36:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BB58B80B70;
        Mon, 12 Dec 2022 10:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679A2C433F0;
        Mon, 12 Dec 2022 10:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841385;
        bh=hI+POaKolA3gfaiu9iwBCuI3o6+XmO5o77l4DOYHUXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYiGRFIyt0b0/mhuuwoa38GKFlKEkawbMtHpwYYAKCgrBtYcy7tCa7KhaI1qEldWg
         f8JX2wwfJeTHDcLJdGfSdNl6FWdjALLRxVth3/5qXA+JUKqzTbACt9CAJ8Z+cobDx5
         yJl8PT4/W2033dtInGbDuwCSQVGG75JGZgaQPyLvnaM8s57nhCXtJ5cUvdtyYrL6f+
         e/+hbPQ+b80Ekyk0vch1nNQcrwO2t/QGQfe0uidkTe+utKuCJ6shUbrjnu3aEk36rd
         zodFX2eqn10463ZxRlFVDtixI/rbnugucYcAlHL5KnfVLeXHo4d9C668xjOeuoDOlD
         k5ocBWBan9HuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Torge Matthies <openglfreak@googlemail.com>,
        Alexander Zhang <alex@alexyzhang.dev>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 4/7] HID: uclogic: Add HID_QUIRK_HIDINPUT_FORCE quirk
Date:   Mon, 12 Dec 2022 05:36:12 -0500
Message-Id: <20221212103616.300049-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212103616.300049-1-sashal@kernel.org>
References: <20221212103616.300049-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 3405a4beaaa852f3ed2a5eb3b5149932d5c3779b ]

Commit f7d8e387d9ae ("HID: uclogic: Switch to Digitizer usage for
styluses") changed the usage used in UCLogic from "Pen" to "Digitizer".

However, the IS_INPUT_APPLICATION() macro evaluates to false for
HID_DG_DIGITIZER causing issues with the XP-Pen Star G640 tablet.

Add the HID_QUIRK_HIDINPUT_FORCE quirk to bypass the
IS_INPUT_APPLICATION() check.

Reported-by: Torge Matthies <openglfreak@googlemail.com>
Reported-by: Alexander Zhang <alex@alexyzhang.dev>
Tested-by: Alexander Zhang <alex@alexyzhang.dev>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index 4edb24195704..e4811d37ca77 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -172,6 +172,7 @@ static int uclogic_probe(struct hid_device *hdev,
 	 * than the pen, so use QUIRK_MULTI_INPUT for all tablets.
 	 */
 	hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+	hdev->quirks |= HID_QUIRK_HIDINPUT_FORCE;
 
 	/* Allocate and assign driver data */
 	drvdata = devm_kzalloc(&hdev->dev, sizeof(*drvdata), GFP_KERNEL);
-- 
2.35.1

