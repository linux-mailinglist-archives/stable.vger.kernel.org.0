Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455FF5B3585
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 12:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiIIKtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 06:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiIIKs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 06:48:58 -0400
X-Greylist: delayed 543 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Sep 2022 03:48:07 PDT
Received: from smtp-8fa9.mail.infomaniak.ch (smtp-8fa9.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fa9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44695760CA
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 03:48:07 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MPCCW0221zMqPkF;
        Fri,  9 Sep 2022 12:39:03 +0200 (CEST)
Received: from localhost (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4MPCCV5brKzMpnPq;
        Fri,  9 Sep 2022 12:39:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1662719942;
        bh=mUrd1lhQRsT39GMuGMdM54M7Mdt2k87ApjcidD8sFRU=;
        h=From:To:Cc:Subject:Date:From;
        b=vDpXl5FXOhCUQO7zEhdG8UTfzKKWbyFQdS0cawFUn6q+SWPjwTwrqUz9hx6/mgucD
         nXr+lRW1kgMWROfpW2NUZuCCCgfTJBZ3EY9ZHqWbADbOCGheTpqVMowmazetLIsmdT
         O0DaqQHba3PgDl0RzR0XfUwlpGUgdLP8s4zBM6Ys=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Anders Roxell <anders.roxell@linaro.org>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v1] selftests: Use optional USERCFLAGS and USERLDFLAGS
Date:   Fri,  9 Sep 2022 12:39:01 +0200
Message-Id: <20220909103901.1503436-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This change enables to extend CFLAGS and LDFLAGS from command line, e.g.
to extend compiler checks: make USERCFLAGS=-Werror USERLDFLAGS=-static

USERCFLAGS and USERLDFLAGS are documented in
Documentation/kbuild/makefiles.rst and Documentation/kbuild/kbuild.rst

This should be backported (down to 5.10) to improve previous kernel
versions testing as well.

Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20220909103901.1503436-1-mic@digikod.net
---
 tools/testing/selftests/lib.mk | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index d44c72b3abe3..da47a0257165 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -119,6 +119,11 @@ endef
 clean:
 	$(CLEAN)
 
+# Enables to extend CFLAGS and LDFLAGS from command line, e.g.
+# make USERCFLAGS=-Werror USERLDFLAGS=-static
+CFLAGS += $(USERCFLAGS)
+LDFLAGS += $(USERLDFLAGS)
+
 # When make O= with kselftest target from main level
 # the following aren't defined.
 #

base-commit: 7e18e42e4b280c85b76967a9106a13ca61c16179
-- 
2.37.2

