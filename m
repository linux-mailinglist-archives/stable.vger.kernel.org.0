Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9DE5179A
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 17:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbfFXPt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 11:49:27 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:47048 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730679AbfFXPt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 11:49:27 -0400
Received: by mail-io1-f65.google.com with SMTP id i10so1142808iol.13
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 08:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/CTIq1HdIxzxdpehMHCyy5IUFBPpAMudQ6zK1OgHCE8=;
        b=mKbcgRcwaHfrmZlxeA0cp7rLPXj7KAz0taPq2RCAEY9dTbYu+m7Bqlcnjx0x2wxzO1
         hQFRn2R0epb3WFRFm9pBlFnV7SDgroUwVwrH7t2MiJY5+rPplaQ1I+cyIt+jiMpnEl0b
         hpn+m+KDi++MTk8bCIhDdWp7IpwKwoJtC4kw4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/CTIq1HdIxzxdpehMHCyy5IUFBPpAMudQ6zK1OgHCE8=;
        b=t1qTzxGG+XfWlSK4ICbWTyhat4mQg777E8VYqPzfiG4g+ptBeIl2Md2oAu3IuETTAK
         CfcAbDtcFfcqjUlM1Hn6uDdImtXScuQlTmXg0YVPSYXAddVnSsa8ly1VdDCvz77dQYKq
         S2Q/lPLdUoTpQc2zGlD74rVcDAX9AETX5n28VOnKJb4cqOoj0wPh6+hoXnzyIyoHGN0H
         EoDQCMBHwWKyUCfemWOXBI/bDPl6Vbs3DQrU9ZvcvrvCJ7YxIlne+8F5sqI11nPT9vx6
         +GqUxPdwhAMfDNE9anB6b6xjSN32Ek5Ijd4pxE46fXhsHipsIENLgif0z+J/b58IUBjd
         +6NQ==
X-Gm-Message-State: APjAAAUdmmvvMdRsKYs3DYOyeXE02HGtTOZtot7KuiACWvVzmfXp8jCu
        JaeIvr/oJSDEPQZWwlC9p/COcw==
X-Google-Smtp-Source: APXvYqyj2BYPx36CSXPCjdMUcwuByrZDPIhDJZ4u3mAYSUH4vCpEfQWiZiLMm6TnQhUkJpCR8ANa1Q==
X-Received: by 2002:a6b:6f0e:: with SMTP id k14mr3667985ioc.257.1561391367034;
        Mon, 24 Jun 2019 08:49:27 -0700 (PDT)
Received: from ddavenport4.bld.corp.google.com ([2620:15c:183:0:92f:a80a:519d:f777])
        by smtp.gmail.com with ESMTPSA id y20sm9740693ion.77.2019.06.24.08.49.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Jun 2019 08:49:26 -0700 (PDT)
From:   Drew Davenport <ddavenport@chromium.org>
To:     akpm@linux-foundation.org
Cc:     keescook@chromium.org, linux-kernel@vger.kernel.org,
        Drew Davenport <ddavenport@chromium.org>,
        stable@vger.kernel.org
Subject: [PATCH] bug: Fix "cut here" for WARN_ON for __WARN_TAINT architectures
Date:   Mon, 24 Jun 2019 09:48:31 -0600
Message-Id: <20190624154831.163888-1-ddavenport@chromium.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For architectures using __WARN_TAINT, the WARN_ON macro did not
print out the "cut here" string. The other WARN_XXX macros would
print "cut here" inside __warn_printk, which is not called for
WARN_ON since it doesn't have a message to print.

Fixes: a7bed27af194 ("bug: fix "cut here" location for __WARN_TAINT architectures")
Cc: stable@vger.kernel.org

Signed-off-by: Drew Davenport <ddavenport@chromium.org>
---
 include/asm-generic/bug.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index c21ff2712803..79feb1a3081b 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -94,8 +94,10 @@ extern void warn_slowpath_null(const char *file, const int line);
 	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
 #else
 extern __printf(1, 2) void __warn_printk(const char *fmt, ...);
-#define __WARN()		__WARN_TAINT(TAINT_WARN)
-#define __WARN_printf(arg...)	do { __warn_printk(arg); __WARN(); } while (0)
+#define __WARN() do { \
+	printk(KERN_WARNING CUT_HERE); __WARN_TAINT(TAINT_WARN); \
+} while (0)
+#define __WARN_printf(arg...)	__WARN_printf_taint(TAINT_WARN, arg)
 #define __WARN_printf_taint(taint, arg...)				\
 	do { __warn_printk(arg); __WARN_TAINT(taint); } while (0)
 #endif
-- 
2.20.1

