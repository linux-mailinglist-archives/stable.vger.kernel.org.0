Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B50D4625BF
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbhK2WnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbhK2Wmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:42:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D97C1A25E8;
        Mon, 29 Nov 2021 10:38:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1759B815FE;
        Mon, 29 Nov 2021 18:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B8DC58322;
        Mon, 29 Nov 2021 18:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211108;
        bh=wxcImDFfBA74zUbspjrRcwg/4BMLKA49CRZaFphyD1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8Iloa85rCzN7xfDj+Ly4bY1x4hol+AUS2/xowv20sfLEt6BcsqFGoIHOFIMUKwg6
         Ir2bOgTjc4MdK/szZMxZ3ih5joCLheL41Mp79lDIXFoi0XhcGpZrV62wmZLI5S1Oqd
         VN91LZhaA4oyklLk6eAzl1I+xSkkXdqLhyObxCbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Benjamin Tissoires <btissoir@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/179] HID: input: Fix parsing of HID_CP_CONSUMER_CONTROL fields
Date:   Mon, 29 Nov 2021 19:18:09 +0100
Message-Id: <20211129181722.053703149@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7fc48fd6b2c0acacd8130d83d2a037670d6192d2 ]

Fix parsing of HID_CP_CONSUMER_CONTROL fields which are not in
the HID_CP_PROGRAMMABLEBUTTONS collection.

Fixes: bcfa8d14570d ("HID: input: Add support for Programmable Buttons")
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=2018096
Cc: Thomas Weißschuh <linux@weissschuh.net>
Suggested-by: Benjamin Tissoires <btissoir@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-By: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 4b5ebeacd2836..4b3f4a5e23058 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -650,10 +650,9 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 						code += KEY_MACRO1;
 					else
 						code += BTN_TRIGGER_HAPPY - 0x1e;
-				} else {
-					goto ignore;
+					break;
 				}
-				break;
+				fallthrough;
 		default:
 			switch (field->physical) {
 			case HID_GD_MOUSE:
-- 
2.33.0



