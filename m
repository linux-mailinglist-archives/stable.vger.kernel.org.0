Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB4F3B21E2
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 22:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhFWUmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 16:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFWUmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 16:42:05 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5F5C061767
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:39:47 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pf4-20020a17090b1d84b029016f6699c3f2so4562889pjb.0
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a/NHLnzJB2ygZFZV6tY0zJmtOu+fbM3j2iEZapLwC/A=;
        b=I/banPaTpbTehL6OdlALe/IibBFT5OlgTdWS6XNKoIoXm+GiZtXArwzsPg+rtwRkgg
         NmrSVIMu+8EuZ9CYJ01zzWl4kbE+LLteCDRjIKB9SxVkzoI6SWm+GokpeXxJUhilXbxr
         V3BTbXTDX4uqb6Jl4nP19anmnYosCw2t8IZxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a/NHLnzJB2ygZFZV6tY0zJmtOu+fbM3j2iEZapLwC/A=;
        b=jOPPhPlbbGtDP4ah8iwMFcvLW/75MEKkDQlJXRzBZsI7sLNgT5AABw4bGx9zX7S04E
         3niRfTelWKHFeN1hCdfBbBniGoJH0e9IfIq9ZeogqlnwsBckut0k6sFYiRHR6pjn/gYH
         x1AiFcobvsJRTAH9EDaPQMvgcx17bwwdNhVLdXD7iZj0FHbbDH9Bv3JQRGkE4kS6vdVs
         /RFOAE5POH1+SfOcIRwxcwp6q/ydzNq2anfU1m6zc+NUC5vkjw6P2+DerFjUyQpgcqiP
         akL5T5m0N4jhDLLY+JTxQ2kqh8aP2iKPUfFDoeTZtyWUARzxzHiZiCwaW2DI2oDa6gFM
         HP2w==
X-Gm-Message-State: AOAM530ASVgbvyeysZjkywHIqZQgu9cIc+gNhBnLb6VkI5b51kdGWY3A
        Pi+JbntswFeNOEA+WknmbmXKPQ==
X-Google-Smtp-Source: ABdhPJyIVBrXhKOZzCBKXG3oK3wjH6BAd9s13vXvBJ+PpxlX5LInY9Q6iJqJZX6Jh5pq81lEvn0kug==
X-Received: by 2002:a17:90a:5a08:: with SMTP id b8mr11356642pjd.228.1624480786915;
        Wed, 23 Jun 2021 13:39:46 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u23sm9942pgk.38.2021.06.23.13.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:39:45 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        David Laight <David.Laight@ACULAB.COM>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        kernelci@groups.io, linux-kselftest@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 1/9] selftests/lkdtm: Avoid needing explicit sub-shell
Date:   Wed, 23 Jun 2021 13:39:28 -0700
Message-Id: <20210623203936.3151093-2-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623203936.3151093-1-keescook@chromium.org>
References: <20210623203936.3151093-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1841; h=from:subject; bh=AmOgu4HWdRZorYqBFRSjQNwNv37L2JYo/PWnXeJW7vY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBg05wFY5oavND7smh3PFgLH+LKjB2fUh5OHY6bWTIk eYMshS6JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYNOcBQAKCRCJcvTf3G3AJvtJD/ 9G+j8CKarzbS3nY6L6aaVmdftLkiLrU13NYZGNHPstjHi6Lx9CpHpJ+QwK8wc78agXMWUB/r+L8qLk s5gPPethiYZV3QumjnWFZ+gj2T/Xoz+EbjLOWntVMv9mjstH5+5/e/VcX9vi3N56IBFqOT/OAyrw6V piyzsjxVP6elfNaUtfASxPcXo5H7zZVums4Lnz/S7qok5qi+zmFuE9cxdfPi1g5YHAdw8uxX76SDgD hoV+UheZw8Vf76IBrTdkW9Jp46PrE+jfJrWT6bx2II9gX/ukVqaMFNd4OMh/CyptWTqAdlnB165u2o dy3BZ1goom8Vqgcw5HC4Xyvj6RHMejdsHAwvZi1eykN7tOV2Ad3VciAb5zpVW0aw6N6KFim54cJhF+ 6ZEq4G2peIhgqpOiJQeN3nNjM19grUPTa4eG/YYfxZxPmhW9BgnimjjelWxx2V2bEUMsU5WvOOOhKl 3av97w61teJaEc5UTni4zXrsFfROtUVxxWtGT6W++WLxeHaIFjxiNKPOUNqIF8xNIDbfy5mnHt7dp6 qzq+WOtPvEmqbCZQ/qsVUVxIbAaVUSoNjmrIU5nCypQyLphJMqKBzn/qDVtewgDbXOT8Np07K7fFns ceDGvDFjboNdC3WG7S0yN+Pj+kveweqXC8AKB5TUR06NIKYA8nA74XD1efAg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some environments do not set $SHELL when running tests. There's no
need to use $SHELL here anyway, since "cat" can be used to receive any
delivered signals from the kernel. Additionally avoid using bash-isms
in the command, and record stderr for posterity.

Suggested-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Fixes: 46d1a0f03d66 ("selftests/lkdtm: Add tests for LKDTM targets")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/lkdtm/run.sh | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/lkdtm/run.sh b/tools/testing/selftests/lkdtm/run.sh
index bb7a1775307b..e95e79bd3126 100755
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
-- 
2.30.2

