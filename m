Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA99F48038E
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhL0TEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:04:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39276 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbhL0TED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B35861161;
        Mon, 27 Dec 2021 19:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98660C36AEA;
        Mon, 27 Dec 2021 19:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631842;
        bh=eIhGmX8+z6x2AibWPj9WdrnKNb/9c/wmYoCBUossBXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQgYbCL1M2XAflXNcA88m6tsaJxzdswlP/ozv98m63LGkElBRzWdUPvdxGL/K6rMO
         6Y0C0An8zwctd1GL25XsZyJIwbePXeGkPDRA4C5le5AAUFi1MksJ3W8FmzqIeZFz6k
         t4gk549I/glxguIIiUEdxKaNO8JZjfeRvD/epxUebeFBrwJ3RNt6KvSYXLv7nRbbVF
         lEGcSSLLly/+4T5DL0HoAIQojngNJEEbbXVi1dhkbzt9kYr4hsuUpyrqbyAbf2HEAY
         pQUH43od7u6BOAxRz1xBVD4n61YPJylH4/tXRIfpwJ5Q8E76lZUoeznWpi6jziD9f9
         T1Zk0g4YA03Sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, mpdesouza@suse.com,
        tiwai@suse.de, arnd@arndb.de, po-hsu.lin@canonical.com,
        adobriyan@gmail.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/26] Input: i8042 - enable deferred probe quirk for ASUS UM325UA
Date:   Mon, 27 Dec 2021 14:03:07 -0500
Message-Id: <20211227190327.1042326-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
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
index 1acc7c8449294..148a7c5fd0e22 100644
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

