Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8155F126B5D
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbfLSS4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:56:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbfLSS4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 303BE206EC;
        Thu, 19 Dec 2019 18:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781771;
        bh=DXRwfcdkeourfhTF/yaOngZc4nLdbMz9SJBOFGWLNRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypV6kO4eBTkU9RRhH92+Rl8d9Xdp/p+qJOOLvJ6Qx9d16Z23IrlsVzhpgjNkSWu9o
         hwR/nawdpsYO6pW+HXfC3xBngjyAPSKl8Trh4IJjCOgeiBsto4CPsiIGIkARXCbgV7
         tWkzwlmPoHHm9WV9GK1SReVQ/xfM48Cg9CGFld2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 72/80] drm/amd/display: re-enable wait in pipelock, but add timeout
Date:   Thu, 19 Dec 2019 19:35:04 +0100
Message-Id: <20191219183143.088145146@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 627f75d18910b287472593a4a2c41de9a386f5a2 upstream.

Removing this causes hangs in some games, so re-add it, but add
a timeout so we don't hang while switching flip types.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=205169
Bug: https://bugs.freedesktop.org/show_bug.cgi?id=112266
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1103,6 +1103,25 @@ void dcn20_pipe_control_lock(
 	if (pipe->plane_state != NULL)
 		flip_immediate = pipe->plane_state->flip_immediate;
 
+	if (flip_immediate && lock) {
+		const int TIMEOUT_FOR_FLIP_PENDING = 100000;
+		int i;
+
+		for (i = 0; i < TIMEOUT_FOR_FLIP_PENDING; ++i) {
+			if (!pipe->plane_res.hubp->funcs->hubp_is_flip_pending(pipe->plane_res.hubp))
+				break;
+			udelay(1);
+		}
+
+		if (pipe->bottom_pipe != NULL) {
+			for (i = 0; i < TIMEOUT_FOR_FLIP_PENDING; ++i) {
+				if (!pipe->bottom_pipe->plane_res.hubp->funcs->hubp_is_flip_pending(pipe->bottom_pipe->plane_res.hubp))
+					break;
+				udelay(1);
+			}
+		}
+	}
+
 	/* In flip immediate and pipe splitting case, we need to use GSL
 	 * for synchronization. Only do setup on locking and on flip type change.
 	 */


