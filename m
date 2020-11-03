Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983662A557F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388673AbgKCVTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:19:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388599AbgKCVIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:08:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36E1F207BC;
        Tue,  3 Nov 2020 21:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437727;
        bh=3KSKvUm5ZkRkwxCc0W0Zk+dSy3snRkDj8hsCqDGc6w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=woAVHHx95rsP7sjIS0gjA5FBrXPRnmZlUmu3dwieeBYT2HUg4yAtSUsTr871UiQ+J
         F++uOoVNp/HNL/DI8bPNxEoqUUyckRl/gop+R3DDuuDprfqkegvAYE3mXVjvPCowVy
         4dO3kwE/LY/plL2858IpXTqkepTut2hHf6G+f74I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 167/191] drm/amd/display: Dont invoke kgdb_breakpoint() unconditionally
Date:   Tue,  3 Nov 2020 21:37:39 +0100
Message-Id: <20201103203248.105268892@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 8b7dc1fe1a5c1093551f6cd7dfbb941bd9081c2e upstream.

ASSERT_CRITICAL() invokes kgdb_breakpoint() whenever either
CONFIG_KGDB or CONFIG_HAVE_KGDB is set.  This, however, may lead to a
kernel panic when no kdb stuff is attached, since the
kgdb_breakpoint() call issues INT3.  It's nothing but a surprise for
normal end-users.

For avoiding the pitfall, make the kgdb_breakpoint() call only when
CONFIG_DEBUG_KERNEL_DC is set.

https://bugzilla.opensuse.org/show_bug.cgi?id=1177973
Cc: <stable@vger.kernel.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/os_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/os_types.h
+++ b/drivers/gpu/drm/amd/display/dc/os_types.h
@@ -57,7 +57,7 @@
  * general debug capabilities
  *
  */
-#if defined(CONFIG_HAVE_KGDB) || defined(CONFIG_KGDB)
+#if defined(CONFIG_DEBUG_KERNEL_DC) && (defined(CONFIG_HAVE_KGDB) || defined(CONFIG_KGDB))
 #define ASSERT_CRITICAL(expr) do {	\
 	if (WARN_ON(!(expr))) { \
 		kgdb_breakpoint(); \


