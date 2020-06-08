Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB09D1F22AA
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgFHXKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbgFHXJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 661CB20897;
        Mon,  8 Jun 2020 23:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657798;
        bh=3ojo2VBVuawBc4HDxLn8sIbL+mr/RC4gim2D8Fr8+Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tY22pXf9UTv5KXGUzRcd0zZY72CmCxzSjqKrE7L9qbMLS9A2CE90HUrF4nr74Eypo
         HGXiRTg+U13s2OifWYRlEaNE8c5+LulAjFjzm21VFNmzU/k/GJ7pqevUsbR3s6TyIr
         YhQG4EYEQTAiVeHIEcKOExFA9ubHLrS0XhtV9vW8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 176/274] platform/x86: intel-vbtn: Split keymap into buttons and switches parts
Date:   Mon,  8 Jun 2020 19:04:29 -0400
Message-Id: <20200608230607.3361041-176-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f6ba524970c4b73b234bf41ecd6628f5803b1559 ]

Split the sparse keymap into 2 separate keymaps, a buttons and a switches
keymap and combine the 2 to a single map again in intel_vbtn_input_setup().

This is a preparation patch for not telling userspace that we have switches
when we do not have them (and for doing the same for the buttons).

Fixes: de9647efeaa9 ("platform/x86: intel-vbtn: Only activate tablet mode switch on 2-in-1's")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 191894d648bb..634096cef21a 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -40,14 +40,20 @@ static const struct key_entry intel_vbtn_keymap[] = {
 	{ KE_IGNORE, 0xC7, { KEY_VOLUMEDOWN } },	/* volume-down key release */
 	{ KE_KEY,    0xC8, { KEY_ROTATE_LOCK_TOGGLE } },	/* rotate-lock key press */
 	{ KE_KEY,    0xC9, { KEY_ROTATE_LOCK_TOGGLE } },	/* rotate-lock key release */
+};
+
+static const struct key_entry intel_vbtn_switchmap[] = {
 	{ KE_SW,     0xCA, { .sw = { SW_DOCK, 1 } } },		/* Docked */
 	{ KE_SW,     0xCB, { .sw = { SW_DOCK, 0 } } },		/* Undocked */
 	{ KE_SW,     0xCC, { .sw = { SW_TABLET_MODE, 1 } } },	/* Tablet */
 	{ KE_SW,     0xCD, { .sw = { SW_TABLET_MODE, 0 } } },	/* Laptop */
-	{ KE_END },
 };
 
+#define KEYMAP_LEN \
+	(ARRAY_SIZE(intel_vbtn_keymap) + ARRAY_SIZE(intel_vbtn_switchmap) + 1)
+
 struct intel_vbtn_priv {
+	struct key_entry keymap[KEYMAP_LEN];
 	struct input_dev *input_dev;
 	bool wakeup_mode;
 };
@@ -55,13 +61,29 @@ struct intel_vbtn_priv {
 static int intel_vbtn_input_setup(struct platform_device *device)
 {
 	struct intel_vbtn_priv *priv = dev_get_drvdata(&device->dev);
-	int ret;
+	int ret, keymap_len = 0;
+
+	if (true) {
+		memcpy(&priv->keymap[keymap_len], intel_vbtn_keymap,
+		       ARRAY_SIZE(intel_vbtn_keymap) *
+		       sizeof(struct key_entry));
+		keymap_len += ARRAY_SIZE(intel_vbtn_keymap);
+	}
+
+	if (true) {
+		memcpy(&priv->keymap[keymap_len], intel_vbtn_switchmap,
+		       ARRAY_SIZE(intel_vbtn_switchmap) *
+		       sizeof(struct key_entry));
+		keymap_len += ARRAY_SIZE(intel_vbtn_switchmap);
+	}
+
+	priv->keymap[keymap_len].type = KE_END;
 
 	priv->input_dev = devm_input_allocate_device(&device->dev);
 	if (!priv->input_dev)
 		return -ENOMEM;
 
-	ret = sparse_keymap_setup(priv->input_dev, intel_vbtn_keymap, NULL);
+	ret = sparse_keymap_setup(priv->input_dev, priv->keymap, NULL);
 	if (ret)
 		return ret;
 
-- 
2.25.1

