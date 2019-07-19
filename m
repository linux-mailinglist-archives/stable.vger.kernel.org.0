Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8793F6DBC5
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388431AbfGSELY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388410AbfGSELX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:11:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4348721872;
        Fri, 19 Jul 2019 04:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509482;
        bh=WNjxKfVglkiS8lEwzicqeDhTFnwuzi16XtGFvZQExiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWeh660LiGyZu4x6fsGznhhl57FZ3uWlnkyUh3AT6D2e2efJmBLuQg8LnFYhwO0oc
         YT5YU4BgMS9slBx8ZBCcppk1oA+T+Y0AUrfsZP6r1XQROWk8vNtarmueStJ99WLBIN
         7C4wLIPRFVuAMHwRC4Zt6f8D3RAJ7YcUodGWSXko=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 08/60] drm/bridge: tc358767: read display_props in get_modes()
Date:   Fri, 19 Jul 2019 00:10:17 -0400
Message-Id: <20190719041109.18262-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

[ Upstream commit 3231573065ad4f4ecc5c9147b24f29f846dc0c2f ]

We need to know the link bandwidth to filter out modes we cannot
support, so we need to have read the display props before doing the
filtering.

To ensure we have up to date display props, call tc_get_display_props()
in the beginning of tc_connector_get_modes().

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190528082747.3631-22-tomi.valkeinen@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 6eebd8ad0c52..9705ca197b90 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1147,6 +1147,13 @@ static int tc_connector_get_modes(struct drm_connector *connector)
 	struct tc_data *tc = connector_to_tc(connector);
 	struct edid *edid;
 	unsigned int count;
+	int ret;
+
+	ret = tc_get_display_props(tc);
+	if (ret < 0) {
+		dev_err(tc->dev, "failed to read display props: %d\n", ret);
+		return 0;
+	}
 
 	if (tc->panel && tc->panel->funcs && tc->panel->funcs->get_modes) {
 		count = tc->panel->funcs->get_modes(tc->panel);
-- 
2.20.1

