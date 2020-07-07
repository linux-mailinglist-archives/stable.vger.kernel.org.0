Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7E72171E4
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbgGGP0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730290AbgGGP0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE0112078D;
        Tue,  7 Jul 2020 15:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135597;
        bh=sQ5kSR3L5ZKqeAIZus4dlttc87HlpU80DJf60vHzsTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBdyrbxhteWya/yLhKtt5tqzMtT/tREAQjWuosSSXhMROGRMl4jOT8gH8bf3UgNAJ
         80bZLuCHnekReoNSVWt00EpiJpfFEbBbYp5pihFvCvouvsyp/z2Gli8in6tu3SfSIR
         qnTYILyH1OLVI5okXywHVCd1tLs26BNOI48xm6Rc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Roman Li <Roman.Li@amd.com>
Subject: [PATCH 5.7 104/112] drm/amd/display: Only revalidate bandwidth on medium and fast updates
Date:   Tue,  7 Jul 2020 17:17:49 +0200
Message-Id: <20200707145805.920250048@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
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
@@ -2533,10 +2533,12 @@ void dc_commit_updates_for_stream(struct
 
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


