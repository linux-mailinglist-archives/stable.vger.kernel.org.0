Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B919333DC9
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbhCJNYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232834AbhCJNYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB0BB64FF3;
        Wed, 10 Mar 2021 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382674;
        bh=UeDav3EGNIgPzfN43RzWdmp3M+EGl0rvc8wbcvJx5Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUnNXf8CY3+g7O3OOkO68oFbSIuQIZcw4FR/YUYlTNxuTBtIYO0FtE9YbqAlorL/E
         1bB/QMH5slW41ALflfV3vnEjy1IP2+0ak+9tau4cf8ykBZslzlWgxYxlutOunEb/Zi
         SeK9qAMEfgKLE0HQE9bwndL1Lj6DVdOWTtHKmgos=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/49] platform/x86: acer-wmi: Cleanup ACER_CAP_FOO defines
Date:   Wed, 10 Mar 2021 14:23:26 +0100
Message-Id: <20210310132322.443951388@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7c936d8d26afbc74deac0651d613dead2f76e81c ]

Cleanup the ACER_CAP_FOO defines:
-Switch to using BIT() macro.
-The ACER_CAP_RFBTN flag is set, but it is never checked anywhere, drop it.
-Drop the unused ACER_CAP_ANY define.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201019185628.264473-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 5592a929b593..75b1f6ceb76e 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -206,14 +206,12 @@ struct hotkey_function_type_aa {
 /*
  * Interface capability flags
  */
-#define ACER_CAP_MAILLED		(1<<0)
-#define ACER_CAP_WIRELESS		(1<<1)
-#define ACER_CAP_BLUETOOTH		(1<<2)
-#define ACER_CAP_BRIGHTNESS		(1<<3)
-#define ACER_CAP_THREEG			(1<<4)
-#define ACER_CAP_ACCEL			(1<<5)
-#define ACER_CAP_RFBTN			(1<<6)
-#define ACER_CAP_ANY			(0xFFFFFFFF)
+#define ACER_CAP_MAILLED		BIT(0)
+#define ACER_CAP_WIRELESS		BIT(1)
+#define ACER_CAP_BLUETOOTH		BIT(2)
+#define ACER_CAP_BRIGHTNESS		BIT(3)
+#define ACER_CAP_THREEG			BIT(4)
+#define ACER_CAP_ACCEL			BIT(5)
 
 /*
  * Interface type flags
@@ -1253,10 +1251,8 @@ static void __init type_aa_dmi_decode(const struct dmi_header *header, void *d)
 		interface->capability |= ACER_CAP_THREEG;
 	if (type_aa->commun_func_bitmap & ACER_WMID3_GDS_BLUETOOTH)
 		interface->capability |= ACER_CAP_BLUETOOTH;
-	if (type_aa->commun_func_bitmap & ACER_WMID3_GDS_RFBTN) {
-		interface->capability |= ACER_CAP_RFBTN;
+	if (type_aa->commun_func_bitmap & ACER_WMID3_GDS_RFBTN)
 		commun_func_bitmap &= ~ACER_WMID3_GDS_RFBTN;
-	}
 
 	commun_fn_key_number = type_aa->commun_fn_key_number;
 }
-- 
2.30.1



