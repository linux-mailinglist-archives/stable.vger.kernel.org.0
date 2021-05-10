Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A46378162
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhEJK0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231285AbhEJKZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDB2E6144F;
        Mon, 10 May 2021 10:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642281;
        bh=bM5vnLEX9oW3SHbz0ddTRPsiZuD0vRSfgOYjYyjAByo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfQ0i1BKBDUWzj+15YA7uLvYdqLuDs8Yucdpvy85FXJ8LDr43oMjjqC7C2X422boJ
         5rZGWaXV5gxHsQcWH60UMqLfhXnMsdqAnpWLCxYshOo5S51cCHayg5MKsxZ5yNWUCy
         Kq9C5i3jdoYOKBCCS/xjgmpi4T0Q80Z/1/Z8oK9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.4 031/184] modules: inherit TAINT_PROPRIETARY_MODULE
Date:   Mon, 10 May 2021 12:18:45 +0200
Message-Id: <20210510101951.249384110@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 262e6ae7081df304fc625cf368d5c2cbba2bb991 upstream.

If a TAINT_PROPRIETARY_MODULE exports symbol, inherit the taint flag
for all modules importing these symbols, and don't allow loading
symbols from TAINT_PROPRIETARY_MODULE modules if the module previously
imported gplonly symbols.  Add a anti-circumvention devices so people
don't accidentally get themselves into trouble this way.

Comment from Greg:
  "Ah, the proven-to-be-illegal "GPL Condom" defense :)"

[jeyu: pr_info -> pr_err and pr_warn as per discussion]
Link: http://lore.kernel.org/r/20200730162957.GA22469@lst.de
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/module.h |    1 +
 kernel/module.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -376,6 +376,7 @@ struct module {
 	unsigned int num_gpl_syms;
 	const struct kernel_symbol *gpl_syms;
 	const s32 *gpl_crcs;
+	bool using_gplonly_symbols;
 
 #ifdef CONFIG_UNUSED_SYMBOLS
 	/* unused exported symbols. */
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1429,6 +1429,24 @@ static int verify_namespace_is_imported(
 	return 0;
 }
 
+static bool inherit_taint(struct module *mod, struct module *owner)
+{
+	if (!owner || !test_bit(TAINT_PROPRIETARY_MODULE, &owner->taints))
+		return true;
+
+	if (mod->using_gplonly_symbols) {
+		pr_err("%s: module using GPL-only symbols uses symbols from proprietary module %s.\n",
+			mod->name, owner->name);
+		return false;
+	}
+
+	if (!test_bit(TAINT_PROPRIETARY_MODULE, &mod->taints)) {
+		pr_warn("%s: module uses symbols from proprietary module %s, inheriting taint.\n",
+			mod->name, owner->name);
+		set_bit(TAINT_PROPRIETARY_MODULE, &mod->taints);
+	}
+	return true;
+}
 
 /* Resolve a symbol for this module.  I.e. if we find one, record usage. */
 static const struct kernel_symbol *resolve_symbol(struct module *mod,
@@ -1454,6 +1472,14 @@ static const struct kernel_symbol *resol
 	if (!sym)
 		goto unlock;
 
+	if (license == GPL_ONLY)
+		mod->using_gplonly_symbols = true;
+
+	if (!inherit_taint(mod, owner)) {
+		sym = NULL;
+		goto getname;
+	}
+
 	if (!check_version(info, name, mod, crc)) {
 		sym = ERR_PTR(-EINVAL);
 		goto getname;


