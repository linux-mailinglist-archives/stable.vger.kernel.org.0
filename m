Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA6830063F
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbhAVOyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbhAVOXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5603123B87;
        Fri, 22 Jan 2021 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325083;
        bh=WkY98pTXoyserW3chDKYSj4bZiElHd/ArBC62LA+JI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uU/VhZIaSEqH8xQJ+B/b7PWKrpXg1m795KoyRHy9VwoaT70HfUpsMU62pVR3rw+zu
         BJnSOuJKwUg9yX7Pwno513D1uXaH85SNnJaZO11gV45iAZuj5OkBGq27k5NH3oUJUH
         ILlYWAZO/MsE9MqMICwZvOMoM7Bs9r0AyV4Jvkrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/43] Revert "kconfig: remove kvmconfig and xenconfig shorthands"
Date:   Fri, 22 Jan 2021 15:12:17 +0100
Message-Id: <20210122135735.705106759@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 17a08680ab6a6c057949cb48c352933e09ea377a which is
commit 9bba03d4473df0b707224d4d2067b62d1e1e2a77 upstream.

As Pavel says at Link: https://lore.kernel.org/r/20210119182837.GA18123@duo.ucw.cz
	I don't believe this is suitable for stable.

And he's right.  It is "after" 5.10.0, but we want to keep these targets
for all of the 5.10.y series.

Reported-by: Pavel Machek <pavel@ucw.cz>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/kconfig/Makefile |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -94,6 +94,16 @@ configfiles=$(wildcard $(srctree)/kernel
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m .config $(configfiles)
 	$(Q)$(MAKE) -f $(srctree)/Makefile olddefconfig
 
+PHONY += kvmconfig
+kvmconfig: kvm_guest.config
+	@echo >&2 "WARNING: 'make $@' will be removed after Linux 5.10"
+	@echo >&2 "         Please use 'make $<' instead."
+
+PHONY += xenconfig
+xenconfig: xen.config
+	@echo >&2 "WARNING: 'make $@' will be removed after Linux 5.10"
+	@echo >&2 "         Please use 'make $<' instead."
+
 PHONY += tinyconfig
 tinyconfig:
 	$(Q)$(MAKE) -f $(srctree)/Makefile allnoconfig tiny.config


