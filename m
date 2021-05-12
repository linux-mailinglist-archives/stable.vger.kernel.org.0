Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C3337C8F3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhELQOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239385AbhELQH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F36716199C;
        Wed, 12 May 2021 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833875;
        bh=8uauqwiDWuNi+46mhBTYhX9GY7Yd79pcyntj2cvcRzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfXl7OUb4hVE2rG2eHz0nHVFx8inRW+JWIj37WEqzFkaj1mz1G1vHb3vOxBkv8QTl
         yf9/afaxybJpk0Nqpmy6IuWr3W/yP3YPn/EBVhT9t9iY7dQjfwICrLXbHHZaUUpKQ7
         tLiGUHqCDQz5DSQpPzSBXdo167b2dAORmMmaumTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 322/601] drm/probe-helper: Check epoch counter in output_poll_execute()
Date:   Wed, 12 May 2021 16:46:39 +0200
Message-Id: <20210512144838.415749731@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noralf Trønnes <noralf@tronnes.org>

[ Upstream commit dc659a4e852b591771fc2e5abb60f4455b0cf316 ]

drm_helper_hpd_irq_event() checks the epoch counter to determine
connector status change. This was introduced in
commit 5186421cbfe2 ("drm: Introduce epoch counter to drm_connector").
Do the same for output_poll_execute() so it can detect other changes
beside connection status value changes.

v2:
- Add Fixes tag (Daniel)

Fixes: 5186421cbfe2 ("drm: Introduce epoch counter to drm_connector")
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210313112545.37527-3-noralf@tronnes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_probe_helper.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_probe_helper.c b/drivers/gpu/drm/drm_probe_helper.c
index d6017726cc2a..e5432dcf6999 100644
--- a/drivers/gpu/drm/drm_probe_helper.c
+++ b/drivers/gpu/drm/drm_probe_helper.c
@@ -623,6 +623,7 @@ static void output_poll_execute(struct work_struct *work)
 	struct drm_connector_list_iter conn_iter;
 	enum drm_connector_status old_status;
 	bool repoll = false, changed;
+	u64 old_epoch_counter;
 
 	if (!dev->mode_config.poll_enabled)
 		return;
@@ -659,8 +660,9 @@ static void output_poll_execute(struct work_struct *work)
 
 		repoll = true;
 
+		old_epoch_counter = connector->epoch_counter;
 		connector->status = drm_helper_probe_detect(connector, NULL, false);
-		if (old_status != connector->status) {
+		if (old_epoch_counter != connector->epoch_counter) {
 			const char *old, *new;
 
 			/*
@@ -689,6 +691,9 @@ static void output_poll_execute(struct work_struct *work)
 				      connector->base.id,
 				      connector->name,
 				      old, new);
+			DRM_DEBUG_KMS("[CONNECTOR:%d:%s] epoch counter %llu -> %llu\n",
+				      connector->base.id, connector->name,
+				      old_epoch_counter, connector->epoch_counter);
 
 			changed = true;
 		}
-- 
2.30.2



