Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08076A07C6
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 12:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbjBWLyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 06:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbjBWLyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 06:54:00 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC98027492
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:53:58 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536af109f9aso127435437b3.13
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N8HNcqhgVSPQjofHY9HHdIOhJTzECil/jKWvuQznJ68=;
        b=Z3UuFNSReuZnspRBUTXn6xA0XjsS6l9KP5XVnWEdr9dGHjRh1pl/bW1vjts/JQ0v3z
         0319caZbtMTvuy3cW8JqhJ3jT92gRYutd7S+XmN8B8Z+dRbaTAbQtQ8Dv/kPuuMnUxty
         alkzx7gAB7iqJ/lxcT0AS9VT1kyCAsVqRjafog2bRM6t9vrG+3Z92Htr9whhxOm8FaAI
         g/9whJggh8+IxLCUYFNE1Kb5+0f/zYP7JGThoXcdqQagtbEY4VvSBI+JQuXk52vVF4Su
         W7+WNUI1LG85bAyQZioDjBw/GNDgMP2ir2v+fHy8jyZ8stulAmicI6xBU+N9iaACdNoM
         65/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N8HNcqhgVSPQjofHY9HHdIOhJTzECil/jKWvuQznJ68=;
        b=5pWtuYzju3Jt8IVt/Q25SACUdSux1HJwMHuA6LTaw+WjNWgS/N7pv017TTNhb+zt9h
         iMBSVgIz9fwghy/1Qvn8ThTF4vhqa4HGeTG/fYnbZbH7wZIX3YjbFwFWiuZ2V0kXuyNI
         QpFMsw7xaUXexmpCcCmUqmCrsFxqBxvu4/cZ7ZEj/vXmXobfL9aJVEFnOspLsQu1F/Mk
         VC3wpxdvV9o+5edpByLBbLEMKt/dqmjPNyEzRl3+87/Xha7b4kxB2mjFganclQY8dPNX
         Vt/IZ4U8Xf4JfIMsPXzJJ/n5S1QWuWpXWCxlLdcdjm73h2NtHpBfDFeenuElRpyK+5hA
         qsRQ==
X-Gm-Message-State: AO0yUKUmgOyJJ84E1Eh0Dcu5TFfBiu6k2A07iU9qU6Xvobe3SUJKKJJI
        ak+Zleof5ZUqZ9lp4TNOWvkkFpN4IgsKrg==
X-Google-Smtp-Source: AK7set+I4E8Ic9RobItVWKhwGewzOFBfJwr18n2356kXAEqAzOXFphfRQxMcgfc12aDp1ZnI6wg2wBpW2AzF/g==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:209:cf33:dc28:3e98:f5e9])
 (user=maennich job=sendgmr) by 2002:a0d:d503:0:b0:52e:d56b:18c3 with SMTP id
 x3-20020a0dd503000000b0052ed56b18c3mr1071272ywd.74.1677153237942; Thu, 23 Feb
 2023 03:53:57 -0800 (PST)
Date:   Thu, 23 Feb 2023 11:53:48 +0000
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
Message-Id: <20230223115351.1241401-2-maennich@google.com>
Mime-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH v5.15 v2 1/4] kbuild: Add CONFIG_PAHOLE_VERSION
From:   Matthias Maennich <maennich@google.com>
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

[ Upstream commit 613fe169237785a4bb1d06397b52606b2967da53 ]

There are a few different places where pahole's version is turned into a
three digit form with the exact same command. Move this command into
scripts/pahole-version.sh to reduce the amount of duplication across the
tree.

Create CONFIG_PAHOLE_VERSION so the version code can be used in Kconfig
to enable and disable configuration options based on the pahole version,
which is already done in a couple of places.

Change-Id: Id18c1808832cead0d32f6992a52eb35b0ec269bb
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
index 4f50a453e18a..826e2ba7b09a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3407,6 +3407,7 @@ F:	net/sched/act_bpf.c
 F:	net/sched/cls_bpf.c
 F:	samples/bpf/
 F:	scripts/bpf_doc.py
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

