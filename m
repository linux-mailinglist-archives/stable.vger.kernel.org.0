Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FB52A5277
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbgKCUuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:50:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731768AbgKCUuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B7E22404;
        Tue,  3 Nov 2020 20:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436612;
        bh=xhu6etbmfKbIw8/axD+64khHwZczgy41El3pJK5mIaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9QvT+DEjCwvWlgCONaF+RvwLxHm+UiZwGNkM9gdODfkl0QwwWFahpJLXPwd0p5ov
         nAg8xUFKkQcWO9JsNQcY11fm30CNAajL35AmFitWnh8n+paaWqLYR/pn/HkwkaQZk1
         iUu8Ot44MYpgwjL9kxNfClFDhhWZ5ORissNIc9jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 326/391] drm/amd/display: Dont invoke kgdb_breakpoint() unconditionally
Date:   Tue,  3 Nov 2020 21:36:17 +0100
Message-Id: <20201103203409.122501067@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
@@ -90,7 +90,7 @@
  * general debug capabilities
  *
  */
-#if defined(CONFIG_HAVE_KGDB) || defined(CONFIG_KGDB)
+#if defined(CONFIG_DEBUG_KERNEL_DC) && (defined(CONFIG_HAVE_KGDB) || defined(CONFIG_KGDB))
 #define ASSERT_CRITICAL(expr) do {	\
 	if (WARN_ON(!(expr))) { \
 		kgdb_breakpoint(); \


