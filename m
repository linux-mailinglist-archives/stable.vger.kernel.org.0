Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9046D483245
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiACO02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:26:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56502 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiACOZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:25:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C31F261139;
        Mon,  3 Jan 2022 14:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C67C36AED;
        Mon,  3 Jan 2022 14:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219953;
        bh=6YGgRH6ThzbzsmiBnkn8aHEm9OO34efPccdNlOv5AlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkiZePRdYr2ha1K68SS5zvCqwV/who23dF5/r3aB7CdazcAKUYrOi4FhMYhXtkH0V
         OgaCzJcZ8f4Y4h2hImhfLEXRLKl4amaVOWYNCh9rv7FZdh5D0Wm4OxIzPy816BzEQ1
         UpZRJ2cxCSzvOj1yWtzHikzMVGXL/h+YCAsR0/2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/27] Input: i8042 - enable deferred probe quirk for ASUS UM325UA
Date:   Mon,  3 Jan 2022 15:23:44 +0100
Message-Id: <20220103142052.319197706@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 29179d42b467a..ee0b0a7237ad8 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -1007,6 +1007,13 @@ static const struct dmi_system_id i8042_dmi_probe_defer_table[] __initconst = {
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



