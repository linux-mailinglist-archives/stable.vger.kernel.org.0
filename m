Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2A76599B8
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 16:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiL3Pch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 10:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiL3Pcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 10:32:36 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD38B841
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 07:32:34 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-48641a481dfso127852757b3.11
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 07:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E2R+Iw0I7AIBMP3oD3VCJ7gCAV7aVBjAMojy2VXR83o=;
        b=RgDOQYadLakjt2UroFuF0tXcma+aN76Jzl2OltZHMzHe9OryL505SwviDv1HAzdCp5
         gU2sJZpqvJX2oy5gRodKdxEw2E/f+cQ7ZH0R91pE8Wx0ILoJG2rqtSOLXup0mvyq/Cs9
         gujP/YqUVaGlY5hDUB5clieTyr+0sgoQW5Cgc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E2R+Iw0I7AIBMP3oD3VCJ7gCAV7aVBjAMojy2VXR83o=;
        b=X/CzJfMvMsOdTtLyqKrg4sPsqmUoGEap/k6yW4CSjX0daZaw+8KqeDzQeL+oOlF91w
         qd0A+/SdDvnfCTy3coZoqYqMv8f8EnLHSgMbVR9lZndYw1WPvp5qY/VJZtT6s8WQYsXL
         LtrmQW0qEaNSczh7tbnSpZneG+LzV+sZ5ry14S+UGMO5dKC8pk6erRv0fs3Z0aKcB4Lu
         1DN6371CkywIoug3bhwKQqrnNLGsdPQlf9YA5ZyrzrXBb0B0nO0JoJZ50vwW4oEEDCX7
         K2fvnX9EWdix1WQmyRJbvoQQ6Yq/5Q6zkrohgox7yapDtxleNHFx1w9Ye/zve68AVHMR
         2w+Q==
X-Gm-Message-State: AFqh2kqt+nqW1XuKV6GGruQEV+RIOWMtbHEMKdI2h+5ZxSegis2GzH+O
        1EpjVF8bkIgHILVPB40Pr/8cASKyJ8owjbhXpKc=
X-Google-Smtp-Source: AMrXdXuXL80qaggUZG978MbRGe5sIWFU5CYxiAVW0/oxTG+QizD2dKUps7v/a9uE0beg0qKrID6DQQ==
X-Received: by 2002:a05:7500:6601:b0:ef:bb1c:c01e with SMTP id ix1-20020a057500660100b000efbb1cc01emr916989gab.26.1672414353045;
        Fri, 30 Dec 2022 07:32:33 -0800 (PST)
Received: from joelboxx.c.googlers.com.com (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id w29-20020a05620a0e9d00b006ec62032d3dsm15177813qkm.30.2022.12.30.07.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 07:32:32 -0800 (PST)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org
Subject: [PATCH v5.10 1/2] torture: Exclude "NOHZ tick-stop error" from fatal errors
Date:   Fri, 30 Dec 2022 15:32:13 +0000
Message-Id: <20221230153215.1333921-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

commit 8d68e68a781db80606c8e8f3e4383be6974878fd upstream.

The "NOHZ tick-stop error: Non-RCU local softirq work is pending"
warning happens frequently and appears to be irrelevant to the various
torture tests.  This commit therefore filters it out.

If there proves to be a need to pay attention to it a later commit will
add an "advice" category to allow the user to immediately see that
although something happened, it was not an indictment of the system
being tortured.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 tools/testing/selftests/rcutorture/bin/console-badness.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/console-badness.sh b/tools/testing/selftests/rcutorture/bin/console-badness.sh
index 0e4c0b2eb7f0..80ae7f08b363 100755
--- a/tools/testing/selftests/rcutorture/bin/console-badness.sh
+++ b/tools/testing/selftests/rcutorture/bin/console-badness.sh
@@ -13,4 +13,5 @@
 egrep 'Badness|WARNING:|Warn|BUG|===========|Call Trace:|Oops:|detected stalls on CPUs/tasks:|self-detected stall on CPU|Stall ended before state dump start|\?\?\? Writer stall state|rcu_.*kthread starved for|!!!' |
 grep -v 'ODEBUG: ' |
 grep -v 'This means that this is a DEBUG kernel and it is' |
-grep -v 'Warning: unable to open an initial console'
+grep -v 'Warning: unable to open an initial console' |
+grep -v 'NOHZ tick-stop error: Non-RCU local softirq work is pending, handler'
-- 
2.39.0.314.g84b9a713c41-goog

