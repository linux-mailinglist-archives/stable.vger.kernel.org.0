Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E143FDC7B
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345239AbhIAMvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345858AbhIAMsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58288611C6;
        Wed,  1 Sep 2021 12:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500053;
        bh=h4u0Bx6aeNoGpapTXM+eifytyobrG/LQIW8hVQOGC7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wDbwusq23/YRTZ7hTmHITUESTEpgghlXXqdQ7XgNCMPgDEaQByltdsbYOdw3pK0mi
         ZiruP85eHcy8N5iaPpRnCwCsbjjjrZYsPgSYcMWJmTRc99EVLLyOksQB8tzUyBZDJJ
         /YrE1ymtBN6JaMgOCWFTqSDOcaMlp0gd82C8HYB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 084/113] platform/x86: asus-nb-wmi: Add tablet_mode_sw=lid-flip quirk for the TP200s
Date:   Wed,  1 Sep 2021 14:28:39 +0200
Message-Id: <20210901122304.787641482@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 73fcbad691110ece47a487c9e584822070e3626f ]

The Asus TP200s / E205SA 360 degree hinges 2-in-1 supports reporting
SW_TABLET_MODE info through the ASUS_WMI_DEVID_LID_FLIP WMI device-id.
Add a quirk to enable this.

BugLink: https://gitlab.freedesktop.org/libinput/libinput/-/issues/639
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210812145513.39117-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 9929eedf7dd8..a81dc4b191b7 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -462,6 +462,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_use_lid_flip_devid,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS TP200s / E205SA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E205SA"),
+		},
+		.driver_data = &quirk_asus_use_lid_flip_devid,
+	},
 	{},
 };
 
-- 
2.30.2



