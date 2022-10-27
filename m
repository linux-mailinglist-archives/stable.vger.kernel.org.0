Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEC260FE9F
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbiJ0RG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237006AbiJ0RG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:06:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2342419A22C
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:06:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBED9B824DB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8E3C433C1;
        Thu, 27 Oct 2022 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890414;
        bh=QqOaBemi179+8VbN8ePZ++uTKplpHF4R58pT1dwPLhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTyP+75GMztWZeX2A8qXeQL0l9xWFRZBY/eH8T01pjxLrF34pkgmCW4BVmmLt8kEJ
         oHxoqdDSMHPlJO7Y60qUxttLsdTJ5csltbqOIm4RSNO7MTYmNpvyP0GKzb7CarS8wd
         E2PgGoduxbz7rGp5uwiwiODyXmpw6EEb8M8SfBG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nulo <git@nulo.in>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/79] HID: magicmouse: Do not set BTN_MOUSE on double report
Date:   Thu, 27 Oct 2022 18:55:41 +0200
Message-Id: <20221027165055.443204261@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
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



