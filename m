Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A54B469E20
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351002AbhLFPgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:36:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47226 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387922AbhLFPcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:32:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B12F612D7;
        Mon,  6 Dec 2021 15:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B54FC34900;
        Mon,  6 Dec 2021 15:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804515;
        bh=PKWJgkbCGU2eHYz/jSTBkmjt40ram+G/ndgtmiCYQSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8n6XkDa5rSaAnpe6FUmtPCXIV4gTHLduA4Zvf8ht6O5a3RVRdST/4BTPy6P3YhrC
         uYWHIcGXCob4Hfl5BxUaTmbAqgySB1gnIqDaKqySbAE84tVjYIVzX2hOiZbIjzANaI
         77L975UHZA010+mxWzegRswHiqubznPAFnOFycBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Jian-Hong Pan <jhp@endlessos.org>
Subject: [PATCH 5.15 142/207] drm/vc4: kms: Clear the HVS FIFO commit pointer once done
Date:   Mon,  6 Dec 2021 15:56:36 +0100
Message-Id: <20211206145615.150183028@linuxfoundation.org>
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

commit d134c5ff71c7f2320fc7997f2fbbdedf0c76889a upstream.

Commit 9ec03d7f1ed3 ("drm/vc4: kms: Wait on previous FIFO users before a
commit") introduced a wait on the previous commit done on a given HVS
FIFO.

However, we never cleared that pointer once done. Since
drm_crtc_commit_put can free the drm_crtc_commit structure directly if
we were the last user, this means that it can lead to a use-after free
if we were to duplicate the state, and that stale pointer would even be
copied to the new state.

Set the pointer to NULL once we're done with the wait so that we don't
carry over a pointer to a free'd structure.

Fixes: 9ec03d7f1ed3 ("drm/vc4: kms: Wait on previous FIFO users before a commit")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Tested-by: Jian-Hong Pan <jhp@endlessos.org>
Link: https://lore.kernel.org/r/20211117094527.146275-5-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_kms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -379,6 +379,7 @@ static void vc4_atomic_commit_tail(struc
 			drm_err(dev, "Timed out waiting for commit\n");
 
 		drm_crtc_commit_put(commit);
+		old_hvs_state->fifo_state[channel].pending_commit = NULL;
 	}
 
 	if (vc4->hvs->hvs5)


