Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3111F61106B
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiJ1MFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiJ1MFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:05:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61356118
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:05:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F23C062805
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D87AC433C1;
        Fri, 28 Oct 2022 12:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958717;
        bh=QqOaBemi179+8VbN8ePZ++uTKplpHF4R58pT1dwPLhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mej/diibUkbNPqM5lG9p2DVIQY6SqACElqLdkw0URZHQ6h9k271aVqHjES5t1TsoJ
         EPVioV6UDUo1FxUR/5BG3SYYls3tj/KC9Y5c/KNiuq9LPipiXVoZakPGX6wnd5aVgl
         vQZQdVld+2GYdMn2ITjRVC00KVZKZaqgRY6b2TzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nulo <git@nulo.in>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/73] HID: magicmouse: Do not set BTN_MOUSE on double report
Date:   Fri, 28 Oct 2022 14:03:22 +0200
Message-Id: <20221028120233.455503866@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit bb5f0c855dcfc893ae5ed90e4c646bde9e4498bf ]

Under certain conditions the Magic Trackpad can group 2 reports in a
single packet. The packet is split and the raw event function is
invoked recursively for each part.

However, after processing each part, the BTN_MOUSE status is updated,
sending multiple click events. [1]

Return after processing double reports to avoid this issue.

Link: https://gitlab.freedesktop.org/libinput/libinput/-/issues/811  # [1]
Fixes: a462230e16ac ("HID: magicmouse: enable Magic Trackpad support")
Reported-by: Nulo <git@nulo.in>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20221009182747.90730-1-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index fc4c07459753..28158d2f2352 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -387,7 +387,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		magicmouse_raw_event(hdev, report, data + 2, data[1]);
 		magicmouse_raw_event(hdev, report, data + 2 + data[1],
 			size - 2 - data[1]);
-		break;
+		return 0;
 	default:
 		return 0;
 	}
-- 
2.35.1



