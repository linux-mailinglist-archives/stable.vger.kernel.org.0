Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D557F328AFD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhCAS05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:26:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239750AbhCASUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:20:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3FB564FC5;
        Mon,  1 Mar 2021 17:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620569;
        bh=4UwRXtfGzxRjdjTPjhJgmozz8cUCehwNFBQxgQgsOaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiOJ4AmKHYWM0J6TvIhlbu2NFfrjS4hAGPoSK2QU27ahqIQLWkdZt5SDfYAKCoqdz
         IiF9Gu4UyIrzJAPH9ocei/jpMs4akEmEMjo3nllrv/XRDUaX8KI7z45TJdIdUawE3i
         1XBHaUI2KBYHlBO8GxxPu2254LCxjIXq8gkqookY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 170/775] drm: document that user-space should force-probe connectors
Date:   Mon,  1 Mar 2021 17:05:38 +0100
Message-Id: <20210301161210.046974473@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

[ Upstream commit a7e2e1c50450c6a0f020b35960edecbe25dde520 ]

It seems like we can't have nice things, so let's just document the
disappointing behaviour instead.

The previous version assumed the kernel would perform the probing work
when appropriate, however this is not the case today. Update the
documentation to reflect reality.

v2:

- Improve commit message to explain why this change is made (Pekka)
- Keep the bit about flickering (Daniel)
- Explain when user-space should force-probe, and when it shouldn't (Daniel)

Signed-off-by: Simon Ser <contact@emersion.fr>
Fixes: 2ac5ef3b2362 ("drm: document drm_mode_get_connector")
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Pekka Paalanen <pekka.paalanen@collabora.com>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/AxqLnTAsFCRishOVB5CLsqIesmrMrm7oytnOVB7oPA@cp7-web-043.plabs.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/drm/drm_mode.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index b49fbf2bdc408..1c064627e6c33 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -414,15 +414,12 @@ enum drm_mode_subconnector {
  *
  * If the @count_modes field is set to zero, the kernel will perform a forced
  * probe on the connector to refresh the connector status, modes and EDID.
- * A forced-probe can be slow and the ioctl will block. A force-probe can cause
- * flickering and temporary freezes, so it should not be performed
- * automatically.
+ * A forced-probe can be slow, might cause flickering and the ioctl will block.
  *
- * User-space shouldn't need to force-probe connectors in general: the kernel
- * will automatically take care of probing connectors that don't support
- * hot-plug detection when appropriate. However, user-space may force-probe
- * connectors on user request (e.g. clicking a "Scan connectors" button, or
- * opening a UI to manage screens).
+ * User-space needs to force-probe connectors to ensure their metadata is
+ * up-to-date at startup and after receiving a hot-plug event. User-space
+ * may perform a forced-probe when the user explicitly requests it. User-space
+ * shouldn't perform a forced-probe in other situations.
  */
 struct drm_mode_get_connector {
 	/** @encoders_ptr: Pointer to ``__u32`` array of object IDs. */
-- 
2.27.0



