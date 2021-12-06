Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3F5469F26
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391467AbhLFPpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390582AbhLFPmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38826C08ED0A;
        Mon,  6 Dec 2021 07:28:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04230B810AC;
        Mon,  6 Dec 2021 15:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D920C34902;
        Mon,  6 Dec 2021 15:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804517;
        bh=XI5BrHwe9w/7PkEuLy0WwGqBx5uT6yxz/J1aLatBouw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JunkZsZ92zmN6HawnKtMJLwl9H0I/uPumokdnKeUq/kvt20JrGGDJB5OaGS4rlNOP
         ivEoAD9kKH98Kx04D+VU24s/im9hNv7994gWPX+xHBQDhT2uB7ho1em2a8t1I5RC3f
         0IDHj3hson7xN7gn1UhG8xQbZvzAQcDHoLrtgWmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Jian-Hong Pan <jhp@endlessos.org>
Subject: [PATCH 5.15 143/207] drm/vc4: kms: Dont duplicate pending commit
Date:   Mon,  6 Dec 2021 15:56:37 +0100
Message-Id: <20211206145615.185601826@linuxfoundation.org>
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

commit d354699e2292c60f25496d3c31ce4e7b1563b899 upstream.

Our HVS global state, when duplicated, will also copy the pointer to the
drm_crtc_commit (and increase the reference count) for each FIFO if the
pointer is not NULL.

However, our atomic_setup function will overwrite that pointer without
putting the reference back leading to a memory leak.

Since the commit is only relevant during the atomic commit process, it
doesn't make sense to duplicate the reference to the commit anyway.
Let's remove it.

Fixes: 9ec03d7f1ed3 ("drm/vc4: kms: Wait on previous FIFO users before a commit")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Tested-by: Jian-Hong Pan <jhp@endlessos.org>
Link: https://lore.kernel.org/r/20211117094527.146275-6-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_kms.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -676,12 +676,6 @@ vc4_hvs_channels_duplicate_state(struct
 
 	for (i = 0; i < HVS_NUM_CHANNELS; i++) {
 		state->fifo_state[i].in_use = old_state->fifo_state[i].in_use;
-
-		if (!old_state->fifo_state[i].pending_commit)
-			continue;
-
-		state->fifo_state[i].pending_commit =
-			drm_crtc_commit_get(old_state->fifo_state[i].pending_commit);
 	}
 
 	return &state->base;


