Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FD217D245
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 08:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgCHHei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 03:34:38 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37394 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgCHHeh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 03:34:37 -0400
Received: by mail-ot1-f67.google.com with SMTP id b3so6617631otp.4;
        Sat, 07 Mar 2020 23:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kZXL8stbtWpHPkKS7EK+cyY0hozJba2aSAxakIiEy5g=;
        b=igl0JmZvPN2HJh0JviZsAzX2atyk0nTBX3LG0bNz6q5R9UhUR4cPYHRTut6zEdDy1W
         mfRwzP6Iu1v71DbKO5fR70giDePF7/9QeqPsAbR4e3KakOjRa6U8lmKlfVf6Dt4jnX+8
         4EZriKDQU3S15HWTmb/GvGASL08m//H4fcRfW1xyJHe1nJbAEX98WKkou1B55yoAKgxE
         e7XS5ICiWoWj3HKWPRP5lCMLE7OR5qkZjdHrKYn/ieTrjggDvI2hdf+s6+caVdSbWQ61
         Jxjias+4G/O8alolOCoLa90u2WVa7kIy8IPnd5jm0Y5x85kf+7MJqKO9jtjk5tMK3LYS
         pLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kZXL8stbtWpHPkKS7EK+cyY0hozJba2aSAxakIiEy5g=;
        b=RhLEM0CVfayZWG28dliRcTVsLwRocIFfSv0DsVnnboS3iVgg8MzWdoULr6wlMzBFIz
         XPwHlJAlwoewAMt72IZ7xoC0lbqN081GIy/XjNaVXadEzlpy2is44oBXexHbqJOwKJ2l
         lrPPM1pls0BPLyt1cXY0Teo51JWqDc+9oljdQvZbvxkrfZV535Yt8Jj2Dyn/x6AYiIfS
         ukDwP25T6U6xhdVjChCAFinv4lkogoA/eGlb76PIYdVirBMun9cQrk7bY/CykCGDMD7B
         up+4Sp21Q1pXHA8nl+/C0fMfJHJqnva9s7xdSxM5urB5V82Q7FT7wZ7bVJ4MrgJ2y8ih
         EQRQ==
X-Gm-Message-State: ANhLgQ1sxHUXzo3YuPw0b/MWfodGogJ51t9nboY6xU19gJbPeD+Mpzzt
        +2K++Ann8OvrOLAjZRqWv7I=
X-Google-Smtp-Source: ADFU+vtJBYaHte1ffc6z2hmE6RbIWqvLdUc+MID7snSN1qteU2OXj8z5Lcxn94yg2vhYLQ3dafiVlQ==
X-Received: by 2002:a05:6830:19:: with SMTP id c25mr8515454otp.349.1583652876964;
        Sat, 07 Mar 2020 23:34:36 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id 2sm12812677otj.41.2020.03.07.23.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 23:34:36 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>
Cc:     linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] kbuild: Disable -Wpointer-to-enum-cast
Date:   Sun,  8 Mar 2020 00:34:00 -0700
Message-Id: <20200308073400.23398-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clang's -Wpointer-to-int-cast deviates from GCC in that it warns when
casting to enums. The kernel does this in certain places, such as device
tree matches to set the version of the device being used, which allows
the kernel to avoid using a gigantic union.

https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L428
https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L402
https://elixir.bootlin.com/linux/v5.5.8/source/include/linux/mod_devicetable.h#L264

To avoid a ton of false positive warnings, disable this particular part
of the warning, which has been split off into a separate diagnostic so
that the entire warning does not need to be turned off for clang.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/887
Link: https://github.com/llvm/llvm-project/commit/2a41b31fcdfcb67ab7038fc2ffb606fd50b83a84
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 86035d866f2c..90e56d5657c9 100644
--- a/Makefile
+++ b/Makefile
@@ -748,6 +748,10 @@ KBUILD_CFLAGS += -Wno-tautological-compare
 # source of a reference will be _MergedGlobals and not on of the whitelisted names.
 # See modpost pattern 2
 KBUILD_CFLAGS += -mno-global-merge
+# clang's -Wpointer-to-int-cast warns when casting to enums, which does not match GCC.
+# Disable that part of the warning because it is very noisy across the kernel and does
+# not point out any real bugs.
+KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 else
 
 # These warnings generated too much noise in a regular build.
-- 
2.25.1

