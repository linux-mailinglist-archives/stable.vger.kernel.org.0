Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B97649C8B
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 11:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiLLKmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 05:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiLLKlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 05:41:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61D0F028;
        Mon, 12 Dec 2022 02:36:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 153B4CE0E1D;
        Mon, 12 Dec 2022 10:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C08CC433F2;
        Mon, 12 Dec 2022 10:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841365;
        bh=NmHYeCaXXFEtSVNq2vYn2o2X3MdTvxoe/2Pv2zKOdrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OeIwH1OGnxp6jy/EClzlVbY4X2zrs8Xh2P1rREpYlb+1NdGVh7eeaC6cQyHR6RJJs
         pZONh/fKS/V4gZk6an5XB2sKkJPYD3IEFCfiiSnpBRSaThFKxOS3l5RalyrPqVoUB8
         yo3lXCitssf6nzhLXtyDJ1Bm68U2nw4nuF1d7H/kkHpB+OjFW3DlNkrZ/zGjoZaU99
         VUrsuqPsyJNY4sAx8zc8RL7bsE6YoT9PsAGhaIac+qJ5tRgEQfIwlGIL+j1ALFwC8+
         d5E91xXLaM7bAC3LaoIBYzZenH28AsHqk45lo40z+PK/FB3ayormB2VORaJZEenLrl
         vc73jLk7J1QLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Torge Matthies <openglfreak@googlemail.com>,
        Alexander Zhang <alex@alexyzhang.dev>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 2/6] HID: uclogic: Add HID_QUIRK_HIDINPUT_FORCE quirk
Date:   Mon, 12 Dec 2022 05:35:54 -0500
Message-Id: <20221212103600.299810-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212103600.299810-1-sashal@kernel.org>
References: <20221212103600.299810-1-sashal@kernel.org>
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
index d8ab0139e5cd..785d81d61ba4 100644
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

