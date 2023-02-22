Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0711969F361
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 12:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjBVLXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 06:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjBVLXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 06:23:05 -0500
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926F832E49
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:22:59 -0800 (PST)
Received: by mail-ed1-x54a.google.com with SMTP id dk16-20020a0564021d9000b004aaa054d189so10185931edb.11
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oUsFDIt+en/p6sUQPbh9dJjmzdUxDXKN1SBhXjDkwpg=;
        b=puensBLrVDEvzcWAY1rAWiStnl55c0wdEJrM2vMzD4oJJpRcg9t10FxEJubD8ByE16
         TI1ljAOrxhayi/2hNV2E8VhN59tkDpznD+9svSEHZOt6khLSGcdWp4WP3DShE4Ym94qV
         SX3idukqNg7wQQKUB0RoXUZwVVaf2SYu/N1ghKdAqdRUAjNL8Vvp410PD2jdPtjVspZ/
         1BddfyIE2hWyADJMmIks6V95O4vBHM/mB6dyFjINUu37mOqVCBM+FtFfRbVXgMbNAiiP
         L6rbwASrp+aPMGkYxcsvWjoW9L+bKLmxjGz07wys3J2UVnfQKYa1iv2VN0OZFveIs6Tf
         L48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oUsFDIt+en/p6sUQPbh9dJjmzdUxDXKN1SBhXjDkwpg=;
        b=rZfz/Oh1DE+HiInLBsv+yN8AavfY1xFU9I8nH6l8xIkYbIyywphcURfWS+W/6APfi7
         uJZIVP2F1RgNLcXy2DQZNU3jz6fy2fowITzdiK8Foa3bxJRIrBHzGKvPwEIue7LiYQZz
         JonXuZwlp8bh8S1tdO78uQna7zFd0fa78kGauxFKdsaJWgLUoQ2RVVvp+Jtt0Vx0bAT0
         sER3uvQAXVZkTJB7f6SKMVxNgycjWqbqqmAEENrRbbJ1T+eooXkCcMYtaxfLSPOcgmkm
         caoIBt6bU/uih9MY44+4CJDcBsugsUkyjZHEraj27RTikb9Xf8ZQwCt7MZyVtvO8gegN
         l1ig==
X-Gm-Message-State: AO0yUKXcn+NEUTchh0Sj44ZiE8Ls+oNrZ5r77J0vL8yIjmMrMZ0Zwgq4
        x4goxWriyh4QqINTSe8K11Eib4Mtb00ejQ==
X-Google-Smtp-Source: AK7set8f5p3oIRS4H5EM3Dhvo/hCfa9rAhtcBI5HzBpGDXxebJIOqfJnnE5Jl8UYZNNJEppXSUgZMpqc0dcorQ==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:209:35a9:4800:d90c:e9bc])
 (user=maennich job=sendgmr) by 2002:a50:d701:0:b0:4ad:7265:82db with SMTP id
 t1-20020a50d701000000b004ad726582dbmr3597452edi.1.1677064978058; Wed, 22 Feb
 2023 03:22:58 -0800 (PST)
Date:   Wed, 22 Feb 2023 11:21:41 +0000
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
Message-Id: <20230222112141.278066-3-maennich@google.com>
Mime-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH 2/5] kbuild: Add CONFIG_PAHOLE_VERSION
From:   maennich@google.com
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

There are a few different places where pahole's version is turned into a
three digit form with the exact same command. Move this command into
scripts/pahole-version.sh to reduce the amount of duplication across the
tree.

Create CONFIG_PAHOLE_VERSION so the version code can be used in Kconfig
to enable and disable configuration options based on the pahole version,
which is already done in a couple of places.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220201205624.652313-3-nathan@kernel.org
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 MAINTAINERS               |  1 +
 init/Kconfig              |  4 ++++
 scripts/pahole-version.sh | 13 +++++++++++++
 3 files changed, 18 insertions(+)
 create mode 100755 scripts/pahole-version.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 176485e625a0..ee8a1b5c28a6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3408,6 +3408,7 @@ F:	net/sched/cls_bpf.c
 F:	samples/bpf/
 F:	scripts/bpf_doc.py
 F:	scripts/pahole-flags.sh
+F:	scripts/pahole-version.sh
 F:	tools/bpf/
 F:	tools/lib/bpf/
 F:	tools/testing/selftests/bpf/
diff --git a/init/Kconfig b/init/Kconfig
index a4144393717b..dafc3ba6fa7a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -91,6 +91,10 @@ config CC_HAS_ASM_INLINE
 config CC_HAS_NO_PROFILE_FN_ATTR
 	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
 
+config PAHOLE_VERSION
+	int
+	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
+
 config CONSTRUCTORS
 	bool
 
diff --git a/scripts/pahole-version.sh b/scripts/pahole-version.sh
new file mode 100755
index 000000000000..f8a32ab93ad1
--- /dev/null
+++ b/scripts/pahole-version.sh
@@ -0,0 +1,13 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Usage: $ ./pahole-version.sh pahole
+#
+# Prints pahole's version in a 3-digit form, such as 119 for v1.19.
+
+if [ ! -x "$(command -v "$@")" ]; then
+	echo 0
+	exit 1
+fi
+
+"$@" --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'
-- 
2.39.2.637.g21b0678d19-goog

