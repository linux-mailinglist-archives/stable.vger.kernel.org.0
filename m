Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5334803FE
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhL0TGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbhL0TGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:06:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBFCC061757;
        Mon, 27 Dec 2021 11:06:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D381260FB3;
        Mon, 27 Dec 2021 19:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407A0C36AE7;
        Mon, 27 Dec 2021 19:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631962;
        bh=PXiKZ5/+VkOThTo1q2YxSENXuwQ31fc09fEktv2lT7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irDgZb+/fcQQjWa0aFfWERj7HubjHIP07I6yRnXRALpA/fmzmOGzGCT9il8LqOPqE
         7QwTNu/eWhgT0+amUDAk8cjUCVJxAgb89WQdHcwzLtSO8nW86mKvcOiA0JU1QkEHSr
         Tw8XW+K0R7GPpjx2bx6Q57ODzheyY7A9++IlLebK9dMkEyQmevnWgMz5kZYuO/6uN1
         RhOjlsF2HJE3pA2a97xVFIFuTm3oCXGb1FoZQyfWmLg8363k//xarx33xa/Vj1Nmqu
         ynRtiyOJYXxJzzQP5MhbpII/RA1ZTkvGfrIXdheuVdUregIrgt66xaWP5FE0UbTkua
         9n4dg/vCNA12g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, tiwai@suse.de,
        mpdesouza@suse.com, po-hsu.lin@canonical.com, arnd@arndb.de,
        adobriyan@gmail.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 3/9] Input: i8042 - enable deferred probe quirk for ASUS UM325UA
Date:   Mon, 27 Dec 2021 14:05:30 -0500
Message-Id: <20211227190536.1042975-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190536.1042975-1-sashal@kernel.org>
References: <20211227190536.1042975-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Čavoj <samuel@cavoj.net>

[ Upstream commit 44ee250aeeabb28b52a10397ac17ffb8bfe94839 ]

The ASUS UM325UA suffers from the same issue as the ASUS UX425UA, which
is a very similar laptop. The i8042 device is not usable immediately
after boot and fails to initialize, requiring a deferred retry.

Enable the deferred probe quirk for the UM325UA.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1190256
Signed-off-by: Samuel Čavoj <samuel@cavoj.net>
Link: https://lore.kernel.org/r/20211204015615.232948-1-samuel@cavoj.net
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 2bd33a28b97cc..0282c4c55e9da 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -1003,6 +1003,13 @@ static const struct dmi_system_id i8042_dmi_probe_defer_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425UA"),
 		},
 	},
+	{
+		/* ASUS ZenBook UM325UA */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
+		},
+	},
 	{ }
 };
 
-- 
2.34.1

