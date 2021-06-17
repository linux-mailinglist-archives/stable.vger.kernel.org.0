Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EB33ABF34
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 01:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhFQXMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 19:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhFQXMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 19:12:43 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F469C061760
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 16:10:34 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h16so4673631pjv.2
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 16:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G4dcuAAGqmXJT5DuFgw0YP7swJ10pImvUBqsUnV4SwU=;
        b=Y7gSkuOjUL/6g0t+i6jhPnEHNt13bGmhUPEELQyLifTb3rYdP15UECINaxIcsHLQOy
         9AY4SI70jKpGqcC3G9CkNMpamAo9ytBwFG8G2aA+wVUOfMGZAUYfmUXpJc6RN8l7+vrs
         Vel14aCsvD5ZggKT0ijGN7v+Aq8xEBhEb9q74=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G4dcuAAGqmXJT5DuFgw0YP7swJ10pImvUBqsUnV4SwU=;
        b=tFMt763q74PUk7EP5iGt5Won2639g/1J7Y3Pux9iTQifdIb6IWr3MP/Jpg3FpKzUcF
         QVHCKh/QqYAgYFh69gQPgItXXyziTVScqlYosyDFv/g0sJ/I2iVQ4calZx9Uts4itUnY
         tM13H2eIeJEGlE+cS6fuVxYHZPG6hkZDHOPXzfDQB0pR3b6AR+TDIC3IMb0sNjeFO+PP
         QSXIpr/tPcDyztlvuMFc27wiq9x88IIqvJ9bbJQCPTGylF1PJ8qQ+rdYfxTBVnRj0xKq
         JgdShptddgK6kC2tjvOnTeLZCjxEXaTI8FUPQDpp/tFMj08GSlFPqh1GNbk0djmdye1J
         ugpw==
X-Gm-Message-State: AOAM531GewTJmj2MJMdDIgqrOjVIL/bAb575Pokn2v7UGPZBTJbiI5QD
        ty+IdbTnwUfAc3V0SYD4v5Z7Mw==
X-Google-Smtp-Source: ABdhPJxiErX5m9clXwxzFwFc/Fm1wBAuYiteEGTQC5kS4kF1Sr+7FSaVLhgm3DYF1VwaarlXzB0iSQ==
X-Received: by 2002:a17:90a:46c8:: with SMTP id x8mr19225624pjg.216.1623971434053;
        Thu, 17 Jun 2021 16:10:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n17sm5882819pfv.125.2021.06.17.16.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 16:10:33 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Shuah Khan <shuah@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/lkdtm: Use /bin/sh not $SHELL
Date:   Thu, 17 Jun 2021 16:10:27 -0700
Message-Id: <20210617231027.3908585-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=0ca552e2a18e1ba1dde7ae32c796988c0c6cd64c; i=lfnT3xbl3M4bSoo3fY1JvS2JIxARVoZVIzxV1pBNVzw=; m=tr/oXMpsj/GZG/QCgR+VpXKeGRmUnEu0qybVzfQX7mM=; p=RhCkpoFJvGHGfnnLBQ9fmzwicmX3HukxRspK8EAoIHY=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDL1mIACgkQiXL039xtwCZztw/+NVn v2mbVjKtpS3XGzGAX+kkH4H+LhNd3BRQ5LSXYugv1a2DlD8mXybYmVnRR8Vp9HhXbim2R5ZIyPBFQ m05CYeTKTrgTQPcViD9UFZ+sf8dHCnV0hNjPyi0TU7d24+BRKw5yxM/fvX3+izjYdgnCAstNgB5dO eW5aL5dcVGdfmUOBR1FLLjmxOVm8Supd2C7y+at5rhA+AWKqvyprSE3RGlhSOKpoqOXPrSHtYlSDS wMQ0rFAd4wrgPwyAv2h1QTRIyYvk8TGELEpkW+0etL6k/c2EtqgPMCKYFp7aaitM5scEJFjUtxW0g xqLQupiieEwrnBzdJcqK/OP2l0L72vpp3oE39wLEVr6iamaYSGI2baDu4RtYvt9zy2h2Q/ViOML0m 4LtWG+b0/a2R3WRqbtPnrwK5HIXIfXfeD77vQGq2kb98iTEJJfWCfqoJOVNLs6Co3BiiDOf8cPxt0 Y2KqZzP1rJ+CpgwQrgaAWB+ojrN74VKbK5Z2jncyG/po+0ebPsRalMzEPpVrL2zaFx1n40PFCPkBM j5QMzZiyZrbU/z65tHQtQv7KpTLj9KiG5J5QyXRxlQzExrJSMWn+yRJvU+XOUR/758/tr3oo7vtsC fBGS61ozPQKnbNiifKjIuvxBWrongX3JyN3EP6zxZTmOLZ9n84CTS7h/u60uIylU=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some environments (e.g. kerneci.org) do not set $SHELL for their test
environment. There's no need to use $SHELL here anyway, so just replace
it with hard-coded /bin/sh instead. Without this, the LKDTM tests would
never actually run on kerneci.org.

Fixes: 46d1a0f03d66 ("selftests/lkdtm: Add tests for LKDTM targets")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/lkdtm/run.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/lkdtm/run.sh b/tools/testing/selftests/lkdtm/run.sh
index bb7a1775307b..968ff3cf5667 100755
--- a/tools/testing/selftests/lkdtm/run.sh
+++ b/tools/testing/selftests/lkdtm/run.sh
@@ -79,7 +79,7 @@ dmesg > "$DMESG"
 # Most shells yell about signals and we're expecting the "cat" process
 # to usually be killed by the kernel. So we have to run it in a sub-shell
 # and silence errors.
-($SHELL -c 'cat <(echo '"$test"') >'"$TRIGGER" 2>/dev/null) || true
+(/bin/sh -c 'cat <(echo '"$test"') >'"$TRIGGER" 2>/dev/null) || true
 
 # Record and dump the results
 dmesg | comm --nocheck-order -13 "$DMESG" - > "$LOG" || true
-- 
2.25.1

