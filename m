Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7040B29BC48
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801981AbgJ0PpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799756AbgJ0PdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:33:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF60622263;
        Tue, 27 Oct 2020 15:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812791;
        bh=O1Bv4Z9DszUfWEUzrbjrOcrk1+Kj0qBsYa/puo4dkKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gm9Jp6oe3/BTR+xzA3RW/1ASdY8BHZ1XXeEEsg83rLElC377Jg5AXLOaDdymgOWZ2
         oJUVHBKc9JzzDmsMUxdDJxVgKZKTMnbhWWU/iwGnu/lAqPLehW7MBAW/5YC5AcHQPn
         PH+SxiAqTZAwgHR4DSde2rHZCy41OwHiG2GzJq9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Albanowski <kenalba@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 331/757] HID: hid-input: fix stylus battery reporting
Date:   Tue, 27 Oct 2020 14:49:41 +0100
Message-Id: <20201027135506.075605341@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 88e19996427e6..9770db624bfaf 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -797,7 +797,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x3b: /* Battery Strength */
 			hidinput_setup_battery(device, HID_INPUT_REPORT, field);
 			usage->type = EV_PWR;
-			goto ignore;
+			return;
 
 		case 0x3c: /* Invert */
 			map_key_clear(BTN_TOOL_RUBBER);
@@ -1059,7 +1059,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case HID_DC_BATTERYSTRENGTH:
 			hidinput_setup_battery(device, HID_INPUT_REPORT, field);
 			usage->type = EV_PWR;
-			goto ignore;
+			return;
 		}
 		goto unknown;
 
-- 
2.25.1



