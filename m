Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A6F3AA8A
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbfFIQtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731412AbfFIQtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:49:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7127206DF;
        Sun,  9 Jun 2019 16:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098951;
        bh=gDN3Royv62WSTTTpPYuCAZqOoHLWjI5lA2MMTSlDF8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0VodXEDqY1Eoies2fsFmQxqByhQEfQiqn+t+G82FAX7xEu9H18NkVrkYG4C0Nm8M
         YLPX1M/6LXQdzyCcKHBizvm5XZ6WgBxEJCSncZ9FRzbkfwi/gr9Mk+lO4w1sgeLWD0
         gFtRVtjzrnqQhRuPY5iMoKkPQenaDoevm3RPn4VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4.19 48/51] drm/i915: Maintain consistent documentation subsection ordering
Date:   Sun,  9 Jun 2019 18:42:29 +0200
Message-Id: <20190609164130.697342252@linuxfoundation.org>
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

From: Jonathan Corbet <corbet@lwn.net>

commit 551bd3368a7b3cfef01edaade8970948d178d40a upstream.

With Sphinx 2.0 (or prior versions with the deprecation warnings fixed) the
docs build fails with:

  Documentation/gpu/i915.rst:403: WARNING: Title level inconsistent:

  Global GTT Fence Handling
  ~~~~~~~~~~~~~~~~~~~~~~~~~

  reST markup error:
  Documentation/gpu/i915.rst:403: (SEVERE/4) Title level inconsistent:

I "fixed" it by changing the subsections in i915.rst, but that didn't seem
like the correct change.  It turns out that a couple of i915 files create
their own subsections in kerneldoc comments using apostrophes as the
heading marker:

  Layout
  ''''''

That breaks the normal subsection marker ordering, and newer Sphinx is
rather more strict about enforcing that ordering.  So fix the offending
comments to make Sphinx happy.

(This is unfortunate, in that kerneldoc comments shouldn't need to be aware
of where they might be included in the heading hierarchy, but I don't see
a better way around it).

Cc: stable@vger.kernel.org  # v4.14+
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h          |    6 +++---
 drivers/gpu/drm/i915/intel_workarounds.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -32,7 +32,7 @@
  * macros. Do **not** mass change existing definitions just to update the style.
  *
  * Layout
- * ''''''
+ * ~~~~~~
  *
  * Keep helper macros near the top. For example, _PIPE() and friends.
  *
@@ -78,7 +78,7 @@
  * style. Use lower case in hexadecimal values.
  *
  * Naming
- * ''''''
+ * ~~~~~~
  *
  * Try to name registers according to the specs. If the register name changes in
  * the specs from platform to another, stick to the original name.
@@ -96,7 +96,7 @@
  * suffix to the name. For example, ``_SKL`` or ``_GEN8``.
  *
  * Examples
- * ''''''''
+ * ~~~~~~~~
  *
  * (Note that the values in the example are indented using spaces instead of
  * TABs to avoid misalignment in generated documentation. Use TABs in the
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -37,7 +37,7 @@
  *    costly and simplifies things. We can revisit this in the future.
  *
  * Layout
- * ''''''
+ * ~~~~~~
  *
  * Keep things in this file ordered by WA type, as per the above (context, GT,
  * display, register whitelist, batchbuffer). Then, inside each type, keep the


