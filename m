Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B144514BE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349404AbhKOUMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344949AbhKOTZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 252DD63499;
        Mon, 15 Nov 2021 19:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003248;
        bh=vWdzKBr/23yPIwG9CxZQJGct2T6Ul5/g8eNvRuOjaWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gekPGzzBTfU6Mw9CXO8M0xwgtqj60zNVE1PUWmiTw0zZb8H+m856She3WCnuB4WDk
         XIQdH/1m9AE0XNgdqzhPtrpoyNtZ5IzHNgMjtAfhcHNfprEn7eIEqpE0ywGkttk1pl
         N9KtWAztSsfTe8JwY1ZokEAEtfCbrzb2PpCfdQoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Harrison <John.C.Harrison@Intel.com>
Subject: [PATCH 5.15 865/917] drm/i915/guc: Fix blocked context accounting
Date:   Mon, 15 Nov 2021 18:06:00 +0100
Message-Id: <20211115165458.363094484@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Brost <matthew.brost@intel.com>

commit fc30a6764a54dea42291aeb7009bef7aa2fc1cd4 upstream.

Prior to this patch the blocked context counter was cleared on
init_sched_state (used during registering a context & resets) which is
incorrect. This state needs to be persistent or the counter can read the
incorrect value resulting in scheduling never getting enabled again.

Fixes: 62eaf0ae217d ("drm/i915/guc: Support request cancellation")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: <stable@vger.kernel.org>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210909164744.31249-2-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -152,7 +152,7 @@ static inline void init_sched_state(stru
 {
 	/* Only should be called from guc_lrc_desc_pin() */
 	atomic_set(&ce->guc_sched_state_no_lock, 0);
-	ce->guc_state.sched_state = 0;
+	ce->guc_state.sched_state &= SCHED_STATE_BLOCKED_MASK;
 }
 
 static inline bool


