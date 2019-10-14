Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66908D6BEB
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 01:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfJNXDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 19:03:13 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45143 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfJNXDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 19:03:13 -0400
Received: by mail-lj1-f195.google.com with SMTP id q64so18181620ljb.12
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 16:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HCusZAkrcZ4ZRCDa64eloCvPpn0C4UDSNHBdnBBFEmI=;
        b=OGNS1yJ2ZEKMc9LhJWOC4YbRhyYE3gk7jajs//SVrsomWsZogyfPDGEb+ELb3ey4IQ
         EJQaJ1XCSY0a0pqSyMl2i7rbeoy/GTuFnegBhneM8msS5dPfLhjGuhZ0dbn5RBVyVTcx
         njqu7lgSAn3R37n6MdeWYSSH+LdfbQ4eYXw92l7sJv2z5QKVKxD3mLx43Q0mTmJUcptM
         qVOLofFnSVQTH/1Jjp4AYH2JqiLUd/P/68YNy/D7oJ/mnLdJjwJmtIkG0Spuy/D+9SkJ
         TDNyvCD5Q3man1vhIw5YgLPSDqkXacSa7lTecVpmYFh1Lxi2Aiq8gqN9FdIrb0tEwHn7
         JtTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HCusZAkrcZ4ZRCDa64eloCvPpn0C4UDSNHBdnBBFEmI=;
        b=kMrLnfxolN3Hdl26Y0k5lrf0sY7YRP1uAYf9UFuAsnu1Jve8FcQ23IlE1kdeLaqnPC
         3BODCZSG/sIf3sFNg9eUjSk+m9/yTBUvhTK3RrcsgMji0AZOY2UuscA6GVkyQNK6fEIx
         koLESeuspTZGclXrsmVWJFJgOHhTcbkf3Kh9RLLEneOkuPQH0Dzd0nhSTPj/2zBWcXSv
         Gx1Ssxe0cnvlWv3k/r97lMaTxq/YAiLiLKctxxlULvlYLcdGfE1D/euO//tUF5gwccdQ
         GLqJZlb9BxTNVj7zZHPLi0oPXyjESi3IOBAOqK4/UqkpkWRHqKZt5fq+5mLiuJixNGOf
         FtvQ==
X-Gm-Message-State: APjAAAUHWCo4Ncqfhi7g1I4ZjRzR4j3tTUH7KkzkRxybU84v5Sd4bZNt
        Iqnaq6qzkZf4idyyULciZ1I=
X-Google-Smtp-Source: APXvYqyQwy5fFzQse1Ru/lbFy39DH1oVTqT2Hjvxyih4k53mCh1/BGbICIAg6XyHf0JRPxONEorpqA==
X-Received: by 2002:a2e:85cf:: with SMTP id h15mr20230406ljj.109.1571094191473;
        Mon, 14 Oct 2019 16:03:11 -0700 (PDT)
Received: from octofox.cadence.com (jcmvbkbc-1-pt.tunnel.tserv24.sto1.ipv6.he.net. [2001:470:27:1fa::2])
        by smtp.gmail.com with ESMTPSA id 25sm4727681lje.58.2019.10.14.16.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 16:03:10 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] xtensa: drop EXPORT_SYMBOL for outs*/ins*
Date:   Mon, 14 Oct 2019 16:02:59 -0700
Message-Id: <20191014230259.31618-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Custom outs*/ins* implementations are long gone from the xtensa port,
remove matching EXPORT_SYMBOLs.
This fixes the following build warnings issued by modpost since commit
15bfc2348d54 ("modpost: check for static EXPORT_SYMBOL* functions"):

  WARNING: "insb" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "insw" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "insl" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "outsb" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "outsw" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "outsl" [vmlinux] is a static EXPORT_SYMBOL

Cc: stable@vger.kernel.org
Fixes: d38efc1f150f ("xtensa: adopt generic io routines")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/xtensa_ksyms.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/xtensa/kernel/xtensa_ksyms.c b/arch/xtensa/kernel/xtensa_ksyms.c
index 04f19de46700..4092555828b1 100644
--- a/arch/xtensa/kernel/xtensa_ksyms.c
+++ b/arch/xtensa/kernel/xtensa_ksyms.c
@@ -119,13 +119,6 @@ EXPORT_SYMBOL(__invalidate_icache_range);
 // FIXME EXPORT_SYMBOL(screen_info);
 #endif
 
-EXPORT_SYMBOL(outsb);
-EXPORT_SYMBOL(outsw);
-EXPORT_SYMBOL(outsl);
-EXPORT_SYMBOL(insb);
-EXPORT_SYMBOL(insw);
-EXPORT_SYMBOL(insl);
-
 extern long common_exception_return;
 EXPORT_SYMBOL(common_exception_return);
 
-- 
2.20.1

