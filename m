Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226AA40E88D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356035AbhIPRo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355495AbhIPRlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E83D63263;
        Thu, 16 Sep 2021 16:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811195;
        bh=ohGa5jPwOPe3XBKLp+TBta9fsyHIDorWfMVxvJynow4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPQi0hr/w1MOg4sE0LWsUS+IQyHFgdqT3HaiL3750o6/XRnUXL0alsTZ93/kkBMyE
         HDB3VUDNGy0YiIEiYkD0a4mgwq/Rod6kVxbLa+7XdkkvvYVuR/1v+LwWoxfnvY1PvC
         3qUoPscM/2JZ16x+mEp2AaxmsSdTpul8qZpgtwck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajkumar Subbiah <rsubbia@codeaurora.org>,
        Kuogee Hsieh <khsieh@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.14 418/432] drm/dp_mst: Fix return code on sideband message failure
Date:   Thu, 16 Sep 2021 18:02:47 +0200
Message-Id: <20210916155824.998049414@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajkumar Subbiah <rsubbia@codeaurora.org>

commit 92bd92c44d0d9be5dcbcda315b4be4b909ed9740 upstream.

Commit 2f015ec6eab6 ("drm/dp_mst: Add sideband down request tracing +
selftests") added some debug code for sideband message tracing. But
it seems to have unintentionally changed the behavior on sideband message
failure. It catches and returns failure only if DRM_UT_DP is enabled.
Otherwise it ignores the error code and returns success. So on an MST
unplug, the caller is unaware that the clear payload message failed and
ends up waiting for 4 seconds for the response. Fixes the issue by
returning the proper error code.

Changes in V2:
-- Revise commit text as review comment
-- add Fixes text

Changes in V3:
-- remove "unlikely" optimization

Fixes: 2f015ec6eab6 ("drm/dp_mst: Add sideband down request tracing + selftests")
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Rajkumar Subbiah <rsubbia@codeaurora.org>
Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1625585434-9562-1-git-send-email-khsieh@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2872,11 +2872,13 @@ static int process_single_tx_qlock(struc
 	idx += tosend + 1;
 
 	ret = drm_dp_send_sideband_msg(mgr, up, chunk, idx);
-	if (unlikely(ret) && drm_debug_enabled(DRM_UT_DP)) {
-		struct drm_printer p = drm_debug_printer(DBG_PREFIX);
+	if (ret) {
+		if (drm_debug_enabled(DRM_UT_DP)) {
+			struct drm_printer p = drm_debug_printer(DBG_PREFIX);
 
-		drm_printf(&p, "sideband msg failed to send\n");
-		drm_dp_mst_dump_sideband_msg_tx(&p, txmsg);
+			drm_printf(&p, "sideband msg failed to send\n");
+			drm_dp_mst_dump_sideband_msg_tx(&p, txmsg);
+		}
 		return ret;
 	}
 


