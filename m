Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E74A29AFCB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756328AbgJ0OMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756313AbgJ0OMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:12:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F3652076A;
        Tue, 27 Oct 2020 14:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807953;
        bh=Kz/RB3eu55Y/c3Qn/xRk6I4YHCGlMK2/L6EWIHnbBBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQmkSlzloXHAW4LFh2cO6/RMVI+UcADNx/CzYtDijYovndUBw3BH59hShJkFcKltF
         3eV5R7JdCN2yXSCQTDiu2V5/0sJxQNXJuUj90VsGlFUTqsZW9LWYH/sdzHXPzz8CW8
         15hRMOJrXJGzyEgV4ZjIi8VZd1kxt/5kIGoL0AI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Albanowski <kenalba@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 071/191] HID: hid-input: fix stylus battery reporting
Date:   Tue, 27 Oct 2020 14:48:46 +0100
Message-Id: <20201027134913.133824306@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 505f394fa239cecb76d916aa858f87ed7ea7fde4 ]

With commit 4f3882177240 hid-input started clearing of "ignored" usages
to avoid using garbage that might have been left in them. However
"battery strength" usages should not be ignored, as we do want to
use them.

Fixes: 4f3882177240 ("HID: hid-input: clear unmapped usages")
Reported-by: Kenneth Albanowski <kenalba@google.com>
Tested-by: Kenneth Albanowski <kenalba@google.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 3624d6e3384ff..07a043ae69f12 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -796,7 +796,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x3b: /* Battery Strength */
 			hidinput_setup_battery(device, HID_INPUT_REPORT, field);
 			usage->type = EV_PWR;
-			goto ignore;
+			return;
 
 		case 0x3c: /* Invert */
 			map_key_clear(BTN_TOOL_RUBBER);
@@ -1043,7 +1043,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case HID_DC_BATTERYSTRENGTH:
 			hidinput_setup_battery(device, HID_INPUT_REPORT, field);
 			usage->type = EV_PWR;
-			goto ignore;
+			return;
 		}
 		goto unknown;
 
-- 
2.25.1



