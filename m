Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641E93C477F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbhGLGdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236143AbhGLGbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86A32610A7;
        Mon, 12 Jul 2021 06:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071343;
        bh=RCjUG2JQ5Fn9D2AgnyWAr3vvbV9vOEIeYuaB+5de45g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSnWhQ+exMXOyizZoBPG10LEIHNAYHp8ZXetvn8KQskHAAvos8w7/wWRgyZEB9rFJ
         EAI+q31/zgAzXULNcuj/hlNYTj4A0T00qpwuk2QmcWnz8p4iJ/fH/I9/6ZaPF2d1cj
         0terCi/fO8j/YsyVRgAKX9Cz+Xt8Cm2lgn8azZ6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 030/593] selftests/lkdtm: Avoid needing explicit sub-shell
Date:   Mon, 12 Jul 2021 08:03:10 +0200
Message-Id: <20210712060846.491571648@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 04831e892b41618914b2123ae3b4fa77252e8656 upstream.

Some environments do not set $SHELL when running tests. There's no
need to use $SHELL here anyway, since "cat" can be used to receive any
delivered signals from the kernel. Additionally avoid using bash-isms
in the command, and record stderr for posterity.

Fixes: 46d1a0f03d66 ("selftests/lkdtm: Add tests for LKDTM targets")
Cc: stable@vger.kernel.org
Suggested-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210623203936.3151093-2-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/lkdtm/run.sh |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/lkdtm/run.sh
+++ b/tools/testing/selftests/lkdtm/run.sh
@@ -76,10 +76,14 @@ fi
 # Save existing dmesg so we can detect new content below
 dmesg > "$DMESG"
 
-# Most shells yell about signals and we're expecting the "cat" process
-# to usually be killed by the kernel. So we have to run it in a sub-shell
-# and silence errors.
-($SHELL -c 'cat <(echo '"$test"') >'"$TRIGGER" 2>/dev/null) || true
+# Since the kernel is likely killing the process writing to the trigger
+# file, it must not be the script's shell itself. i.e. we cannot do:
+#     echo "$test" >"$TRIGGER"
+# Instead, use "cat" to take the signal. Since the shell will yell about
+# the signal that killed the subprocess, we must ignore the failure and
+# continue. However we don't silence stderr since there might be other
+# useful details reported there in the case of other unexpected conditions.
+echo "$test" | cat >"$TRIGGER" || true
 
 # Record and dump the results
 dmesg | comm --nocheck-order -13 "$DMESG" - > "$LOG" || true


