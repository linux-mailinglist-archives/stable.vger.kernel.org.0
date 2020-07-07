Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A58B21718E
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgGGPVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgGGPVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:21:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 494DF207BB;
        Tue,  7 Jul 2020 15:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135311;
        bh=I6QCAKGQQJ8wzfFob8w7MMgYMONcPCHm/3XWFx4Lo9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bm/xWZc4Tg3auvLIgb/ES4iyi38I4wyL0v2k+ok1H409NiyPZSnHUCzqoF3Do4oem
         ip5FKRekPaq/hLjNPfNZXG8gutAJoP8/PEu+ZqM+lDA1oymNDDzniOO/HiCKu2Pmtp
         rA25SiZcvWdUe2ygiVuXYMkPakxibzjT3Epw1zfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Roman Li <Roman.Li@amd.com>
Subject: [PATCH 5.4 56/65] drm/amd/display: Only revalidate bandwidth on medium and fast updates
Date:   Tue,  7 Jul 2020 17:17:35 +0200
Message-Id: <20200707145755.168565034@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 6eb3cf2e06d22b2b08e6b0ab48cb9c05a8e1a107 upstream.

[Why]
Changes that are fast don't require updating DLG parameters making
this call unnecessary. Considering this is an expensive call it should
not be done on every flip.

DML touches clocks, p-state support, DLG params and a few other DC
internal flags and these aren't expected during fast. A hang has been
reported with this change when called on every flip which suggests that
modifying these fields is not recommended behavior on fast updates.

[How]
Guard the validation to only happen if update type isn't FAST.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1191
Fixes: a24eaa5c51255b ("drm/amd/display: Revalidate bandwidth before commiting DC updates")
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/core/dc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2226,10 +2226,12 @@ void dc_commit_updates_for_stream(struct
 
 	copy_stream_update_to_stream(dc, context, stream, stream_update);
 
-	if (!dc->res_pool->funcs->validate_bandwidth(dc, context, false)) {
-		DC_ERROR("Mode validation failed for stream update!\n");
-		dc_release_state(context);
-		return;
+	if (update_type > UPDATE_TYPE_FAST) {
+		if (!dc->res_pool->funcs->validate_bandwidth(dc, context, false)) {
+			DC_ERROR("Mode validation failed for stream update!\n");
+			dc_release_state(context);
+			return;
+		}
 	}
 
 	commit_planes_for_stream(


