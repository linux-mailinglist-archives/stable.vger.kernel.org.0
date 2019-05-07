Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE7A15D10
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfEGGJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfEGFcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:32:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C31BE2087F;
        Tue,  7 May 2019 05:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207167;
        bh=sw2etluuU/zmVe92Uj2XTHpP+tbisLk0ukAhe3FuuwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pr857ClQ92Xc074tdtMh7uCEK/hGlTH2tpKeFuxQX+Z+4xY5rRgzNuToad/0dO36U
         BoTWIu6BRzpeo3+KSjtfa36DkSGhfyIMGLblxhJgAKeDcYSrg6k3cbNnQEN25oQLxU
         CpzmUODqenT8gGVHOrL1WDDSUyhXOYVQNdVOFMIY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 08/99] HID: input: add mapping for "Toggle Display" key
Date:   Tue,  7 May 2019 01:31:02 -0400
Message-Id: <20190507053235.29900-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit c01908a14bf735b871170092807c618bb9dae654 ]

According to HUT 1.12 usage 0xb5 from the generic desktop page is reserved
for switching between external and internal display, so let's add the
mapping.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index a985d55e3510..e2b933972465 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -677,6 +677,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			break;
 		}
 
+		if ((usage->hid & 0xf0) == 0xb0) {	/* SC - Display */
+			switch (usage->hid & 0xf) {
+			case 0x05: map_key_clear(KEY_SWITCHVIDEOMODE); break;
+			default: goto ignore;
+			}
+			break;
+		}
+
 		/*
 		 * Some lazy vendors declare 255 usages for System Control,
 		 * leading to the creation of ABS_X|Y axis and too many others.
-- 
2.20.1

