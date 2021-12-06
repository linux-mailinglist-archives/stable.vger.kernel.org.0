Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A00469EE8
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358411AbhLFPor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390552AbhLFPmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FA0C0698D9;
        Mon,  6 Dec 2021 07:28:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBCB6B81126;
        Mon,  6 Dec 2021 15:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0148C34901;
        Mon,  6 Dec 2021 15:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804509;
        bh=R4jRLPw8myO6YlyOTAbKgEi/wLuZas4IHp4XoVlJOq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKykQNVXEdPBFBoCUmcGESr5tKpwwhdRNed84YUW8gR6bjWXlh4rwjlW/7G6iof8Q
         Ie3EJOIhFsxtBk2Uis3BTLKUYZ0z45XiVzciTRLy8p0diPdOj7hK9Nz55Z02GFSwLh
         2bVQwuVmCV1SGwuY2TFkW/3m7KRY1SuFe6ACW5Uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Jian-Hong Pan <jhp@endlessos.org>
Subject: [PATCH 5.15 140/207] drm/vc4: kms: Fix return code check
Date:   Mon,  6 Dec 2021 15:56:34 +0100
Message-Id: <20211206145615.073637127@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

commit f927767978d201d4ac023fcd797adbb963a6565d upstream.

The HVS global state functions return an error pointer, but in most
cases we check if it's NULL, possibly resulting in an invalid pointer
dereference.

Fixes: 9ec03d7f1ed3 ("drm/vc4: kms: Wait on previous FIFO users before a commit")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Tested-by: Jian-Hong Pan <jhp@endlessos.org>
Link: https://lore.kernel.org/r/20211117094527.146275-3-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_kms.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -354,7 +354,7 @@ static void vc4_atomic_commit_tail(struc
 	}
 
 	old_hvs_state = vc4_hvs_get_old_global_state(state);
-	if (!old_hvs_state)
+	if (IS_ERR(old_hvs_state))
 		return;
 
 	for_each_old_crtc_in_state(state, crtc, old_crtc_state, i) {
@@ -410,8 +410,8 @@ static int vc4_atomic_commit_setup(struc
 	unsigned int i;
 
 	hvs_state = vc4_hvs_get_new_global_state(state);
-	if (!hvs_state)
-		return -EINVAL;
+	if (WARN_ON(IS_ERR(hvs_state)))
+		return PTR_ERR(hvs_state);
 
 	for_each_new_crtc_in_state(state, crtc, crtc_state, i) {
 		struct vc4_crtc_state *vc4_crtc_state =
@@ -762,8 +762,8 @@ static int vc4_pv_muxing_atomic_check(st
 	unsigned int i;
 
 	hvs_new_state = vc4_hvs_get_global_state(state);
-	if (!hvs_new_state)
-		return -EINVAL;
+	if (IS_ERR(hvs_new_state))
+		return PTR_ERR(hvs_new_state);
 
 	for (i = 0; i < ARRAY_SIZE(hvs_new_state->fifo_state); i++)
 		if (!hvs_new_state->fifo_state[i].in_use)


