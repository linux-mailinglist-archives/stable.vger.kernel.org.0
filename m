Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3549649C6B
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 11:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiLLKlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 05:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbiLLKkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 05:40:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920BB11A1F;
        Mon, 12 Dec 2022 02:35:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EFD7B80B6E;
        Mon, 12 Dec 2022 10:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F313BC433EF;
        Mon, 12 Dec 2022 10:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841308;
        bh=Vd3Y5m+/n9QbjfeB5jXFh6dbeqEzF5MHbSgyuR6WqcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mO6cz0L81jiLu/tJvqKofPdMDkC+SE85Pkss1wwS8UtOqfUTtkwb+Xnxrjkrlpn7B
         6aHYVNbRnErewpAICD5g8ultwPNHKD6RlASZ0ProgCYubuTHJk7UHWmYHqu024sjeO
         rZmDB32HdJ3h1eyi4F7ao7fn8SbQo5lXnwV3FVa1WHiGXJHUj0TXI1iv6aGnThJB6z
         lEwBmpsx1KWYDvEHFYJ4IxMA5NXjtioP/3lQLeBAu1DmJCpm3LZrBj4al56BKS9+sf
         hE7CVXFMLSyI7yw5LV3hipwxaoyWtTyf/1/5F27oRcUO1mL9jYibOmjhI+zl2Gsnlv
         iWR1WiG++7d1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Torge Matthies <openglfreak@googlemail.com>,
        Alexander Zhang <alex@alexyzhang.dev>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 2/7] HID: uclogic: Add HID_QUIRK_HIDINPUT_FORCE quirk
Date:   Mon, 12 Dec 2022 05:34:58 -0500
Message-Id: <20221212103504.299281-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212103504.299281-1-sashal@kernel.org>
References: <20221212103504.299281-1-sashal@kernel.org>
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
index ff46604ef1d8..683350596ea6 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -192,6 +192,7 @@ static int uclogic_probe(struct hid_device *hdev,
 	 * than the pen, so use QUIRK_MULTI_INPUT for all tablets.
 	 */
 	hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+	hdev->quirks |= HID_QUIRK_HIDINPUT_FORCE;
 
 	/* Allocate and assign driver data */
 	drvdata = devm_kzalloc(&hdev->dev, sizeof(*drvdata), GFP_KERNEL);
-- 
2.35.1

