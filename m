Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB401649CC5
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 11:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiLLKnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 05:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbiLLKlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 05:41:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FE11007A;
        Mon, 12 Dec 2022 02:36:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63AC060F40;
        Mon, 12 Dec 2022 10:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA686C433EF;
        Mon, 12 Dec 2022 10:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841402;
        bh=hI+POaKolA3gfaiu9iwBCuI3o6+XmO5o77l4DOYHUXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwr4WhShUOjNiT6mq+UcK8buHdYjAbPe3eT4YauLPEBw/8B1Lhjo7kkpCMpLkfeo8
         RTCAlNFlAYcJRZWMGZ/uZOC3ET9DNfLx4F/ZI9gYhWHX48W39UW36wSdsKDuGyNI9y
         9i7G4Oq91zftDRCYNUI5EcFrWncGHZbqE472qMsuA1oonNnn62CVUIvFYCBHLy7rW9
         /LD65k+GoqUQKSHLbulxBD9u6ir0NAHCG0gif3YGs0wXy0bthkiP4zkPG0unwEl9La
         xQ3PT0wBimFFfD3KOU1Z9rL82AsscAs3p3c7983B5qMZFP0OF7r0LRvH0UJYi/v1qI
         WnfB8biFsW14A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Torge Matthies <openglfreak@googlemail.com>,
        Alexander Zhang <alex@alexyzhang.dev>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 4/7] HID: uclogic: Add HID_QUIRK_HIDINPUT_FORCE quirk
Date:   Mon, 12 Dec 2022 05:36:29 -0500
Message-Id: <20221212103633.300240-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212103633.300240-1-sashal@kernel.org>
References: <20221212103633.300240-1-sashal@kernel.org>
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

