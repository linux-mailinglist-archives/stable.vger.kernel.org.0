Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC406EB34B
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 23:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbjDUVF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 17:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbjDUVF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 17:05:58 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553FA2106;
        Fri, 21 Apr 2023 14:05:51 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-956ff2399c9so285412566b.3;
        Fri, 21 Apr 2023 14:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682111150; x=1684703150;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=BHJwicqGedpG3F45WxlpSv7ibTlnrQxRCpEjPy9k+UY=;
        b=EiPNTj7FOsR9jYvy+BFpZTnvmGPO4T7ZLWayDyxqY16yij1n9HDhbp88L7y06tCI5b
         nUd4P1R/bgRrFPMtRRI0HMglmnN3cPH2rFPbJJydzo8th11izdn/GyVshi500Y4aw6Kp
         CywzdQpkjiiMexX7RzdouqPOKnfS99OvR+0SdR0QaIt3eHslE5BveF7ox9fBSn+pCZbP
         afohXYrnB0Yw3Jp5sDDPUtMfoaaYsyEeqhTft61E30KTrTz1Q0RzGDqIitULtMHIJzGL
         vEEMTvc5y8h/mfByQg3zcFZpRrnLE7H6rluQ+b2uuiURpDXVCIJvk1K5Ofpf0NDE2nZ5
         xv1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682111150; x=1684703150;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHJwicqGedpG3F45WxlpSv7ibTlnrQxRCpEjPy9k+UY=;
        b=em1Ze3MEfhQkuLKcN8RALlcO/N3L/qIJYxs6FR4mDj0RSjj5ltT5cYUS6+5afC6z88
         9ybdVvd1REsp3AbT/RjT3qaOYHUmhldewT4q+9AwUT6if0XkZ3KLgN5MndyDOKAklt8y
         +4CnJODY14/3A9wqI//3kO6YAu5iVSKtNxljz9T1HdGPunlyEu+1CX4hE6Ds9YLCX/BV
         e2pguUGURQKBYFylqzWNkFm1G9pfGcKMqu0imPIAh8qAG9WlIuIYq8mP2GfUaipJlCOp
         kSO5HxiwvRNYexJUyyAVWw/5+AH/sJnztorqlAmG+CJv9F9Ys+v8dQpTBhvEEUw1o5Tz
         uZYQ==
X-Gm-Message-State: AAQBX9cjgJpdW6oHdf+W9O8ffn0d7K7EBfBT0Im7k1tdCoV7sulpTejF
        TbOz8NnQc312feXBQH0Q+r+mIyoJ/Pxb2g==
X-Google-Smtp-Source: AKy350anXib8Ph/A8pReLEBo7X/Uzp+usxKrbTsnYo4I6jmCBLdfVNd29+URbjAWOlmML79yWrzykQ==
X-Received: by 2002:a17:906:e090:b0:94f:5a9:9fdb with SMTP id gh16-20020a170906e09000b0094f05a99fdbmr3415173ejb.67.1682111149740;
        Fri, 21 Apr 2023 14:05:49 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id lh21-20020a170906f8d500b0094eeab34ad5sm2460104ejb.124.2023.04.21.14.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 14:05:48 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 4F7C2BE2DE0; Fri, 21 Apr 2023 23:05:47 +0200 (CEST)
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH] docs: futex: Fix kernel-doc references after code split-up preparation
Date:   Fri, 21 Apr 2023 23:05:31 +0200
Message-Id: <20230421210531.1816665-1-carnil@debian.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In upstream commit 77e52ae35463 ("futex: Move to kernel/futex/") the
futex code from kernel/futex.c was moved into kernel/futex/core in
preparation of the split-up of the implementation in various files.

Point kernel-doc references to the new files as otherwise the
documentation shows errors on build:

[...]
Error: Cannot open file ./kernel/futex.c
Error: Cannot open file ./kernel/futex.c
[...]
WARNING: kernel-doc './scripts/kernel-doc -rst -enable-lineno -sphinx-version 3.4.3 -internal ./kernel/futex.c' failed with return code 2

There is no direct upstream commit for this change. It is made in
analogy to commit bc67f1c454fb ("docs: futex: Fix kernel-doc
references") applied as consequence of the restructuring of the futex
code.

Fixes: 77e52ae35463 ("futex: Move to kernel/futex/")
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 Documentation/kernel-hacking/locking.rst                    | 2 +-
 Documentation/translations/it_IT/kernel-hacking/locking.rst | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-hacking/locking.rst b/Documentation/kernel-hacking/locking.rst
index 6ed806e6061b..a6d89efede79 100644
--- a/Documentation/kernel-hacking/locking.rst
+++ b/Documentation/kernel-hacking/locking.rst
@@ -1358,7 +1358,7 @@ Mutex API reference
 Futex API reference
 ===================
 
-.. kernel-doc:: kernel/futex.c
+.. kernel-doc:: kernel/futex/core.c
    :internal:
 
 Further reading
diff --git a/Documentation/translations/it_IT/kernel-hacking/locking.rst b/Documentation/translations/it_IT/kernel-hacking/locking.rst
index bf1acd6204ef..192ab8e28125 100644
--- a/Documentation/translations/it_IT/kernel-hacking/locking.rst
+++ b/Documentation/translations/it_IT/kernel-hacking/locking.rst
@@ -1400,7 +1400,7 @@ Riferimento per l'API dei Mutex
 Riferimento per l'API dei Futex
 ===============================
 
-.. kernel-doc:: kernel/futex.c
+.. kernel-doc:: kernel/futex/core.c
    :internal:
 
 Approfondimenti
-- 
2.40.0

