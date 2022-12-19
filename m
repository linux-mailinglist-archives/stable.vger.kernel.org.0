Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE43651342
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiLST3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbiLST2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:28:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C9813D61
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:28:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 124196109A
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16056C433D2;
        Mon, 19 Dec 2022 19:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671478114;
        bh=hI+POaKolA3gfaiu9iwBCuI3o6+XmO5o77l4DOYHUXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grCx9cv6z9HCSP9RAXcWdk4E9IUj451uu/Xd65BsLYOYK2afoIs3CjWAMCCIe8HaZ
         9s5Q0CyFpvKv3vQcABlvgL2ccQSgBewbQnIW5SCFxYo74B9+7R0GFtdP5fts/D8VJM
         naYu6ECsHb30CG6KxA79AdrLwTptOWX5kL0rnGj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Torge Matthies <openglfreak@googlemail.com>,
        Alexander Zhang <alex@alexyzhang.dev>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/18] HID: uclogic: Add HID_QUIRK_HIDINPUT_FORCE quirk
Date:   Mon, 19 Dec 2022 20:25:09 +0100
Message-Id: <20221219182941.189200407@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
References: <20221219182940.701087296@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



