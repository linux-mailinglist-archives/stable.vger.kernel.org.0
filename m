Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50DF3AA89
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731380AbfFIQtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729661AbfFIQtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:49:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 004002070B;
        Sun,  9 Jun 2019 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098948;
        bh=3snimYtLiW81QvdIBMukURLkhku++669pMJK/Z942Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lv5lgMaGMA2j0v1iovgeEDCh5oRmF5isNngFZKzin0BlxI8519IbXtLFJ8sIXXhZg
         9A7+WrVkdQzPORFMgk7YBBkNjdKsWppPeTbViE+A1ymiFmDw/I/CsxnIkEH26sAg9w
         t1W54AC9J6JJuvPGlhW9N/NMii/U4QeFUsYEMXfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Drake <drake@endlessm.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 4.19 47/51] drm/i915/fbc: disable framebuffer compression on GeminiLake
Date:   Sun,  9 Jun 2019 18:42:28 +0200
Message-Id: <20190609164130.583496940@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
References: <20190609164127.123076536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Drake <drake@endlessm.com>

commit 396dd8143bdd94bd1c358a228a631c8c895a1126 upstream.

On many (all?) the Gemini Lake systems we work with, there is frequent
momentary graphical corruption at the top of the screen, and it seems
that disabling framebuffer compression can avoid this.

The ticket was reported 6 months ago and has already affected a
multitude of users, without any real progress being made. So, lets
disable framebuffer compression on GeminiLake until a solution is found.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=108085
Fixes: fd7d6c5c8f3e ("drm/i915: enable FBC on gen9+ too")
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: <stable@vger.kernel.org> # v4.11+
Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Drake <drake@endlessm.com>
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190423092810.28359-1-jian-hong@endlessm.com
(cherry picked from commit 1d25724b41fad7eeb2c3058a5c8190d6ece73e08)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_fbc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/intel_fbc.c
+++ b/drivers/gpu/drm/i915/intel_fbc.c
@@ -1267,6 +1267,10 @@ static int intel_sanitize_fbc_option(str
 	if (!HAS_FBC(dev_priv))
 		return 0;
 
+	/* https://bugs.freedesktop.org/show_bug.cgi?id=108085 */
+	if (IS_GEMINILAKE(dev_priv))
+		return 0;
+
 	if (IS_BROADWELL(dev_priv) || INTEL_GEN(dev_priv) >= 9)
 		return 1;
 


