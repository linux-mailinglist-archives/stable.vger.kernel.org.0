Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A483C5079
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbhGLHdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347030AbhGLHb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AA3661006;
        Mon, 12 Jul 2021 07:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074918;
        bh=RCjUG2JQ5Fn9D2AgnyWAr3vvbV9vOEIeYuaB+5de45g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ha1hx2G1tTwsDnhKtKIpDSx4G7v+/uOxqwCmliJKc4h9SjqBbh60BHLAJ0dZZ6vmx
         M5V6Al62GrZIYZFKdbuZF7og+eIHv1HZ571v+pC/Ozywo08MWPTydgwkJ06k2xae8z
         WMSWHVBuuuMnwT9bo3DIFISBSwqsVbqRo5UQsB+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.13 035/800] selftests/lkdtm: Avoid needing explicit sub-shell
Date:   Mon, 12 Jul 2021 08:00:58 +0200
Message-Id: <20210712060918.209035512@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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


