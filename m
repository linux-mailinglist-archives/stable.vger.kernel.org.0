Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4071E7BC
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 06:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfEOExX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 00:53:23 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45877 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfEOExX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 00:53:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id i21so693120pgi.12;
        Tue, 14 May 2019 21:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P/nPH78rMZi+N42kFDUtjB2yFcI3lwn1M6vMbllJuVg=;
        b=k9cSPMsLXKJRS3JccoESqEluJdmibEefjgOjob0u2Go+/fMrse21E1o+Dorl8uf/ze
         Mu1XlT85aiOUX+BzfHAHvmA5TP/3eWnd8pa8fPGMGfQjFxKMhaRTnmww7Qz+Qx6EnRoC
         RCNrhqO2SX1ZCV0b2a2u2v+BiyMqX87Eb0Sczd/bHeqwO52vqofl03dmnhp/aqMjVaDA
         93ngqjvzhuBbDS7zGuSNy+1aOM/Te1hQaHHPEBIuNgpEfEpUzThNr8hv9NEwG1mJV11L
         3rbK514Wv0owmyRA5K2oyE2xW079xCt7yHT1lLPkJpyr21h9sawi2hhac4P4+0fRIwdT
         t5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=P/nPH78rMZi+N42kFDUtjB2yFcI3lwn1M6vMbllJuVg=;
        b=o9FQnRSr+EaN+VAoMI41rKL/2X7M1QYN9gJqoxhagxOE5lqd5PBz+YQEaTGQOj8C+j
         1s21nqQckg8oM6dYSlLmsfJHOQTrGTIYyGPySy7IaMpaW2n9tkrZrBjY1eaGd3BT8TDa
         hjmn7aw8novo13uT3hGj27OCR++EnKC1dJa54//ROywXXKsBzs6Zc6ryi9xXYOIi4P/x
         AHUgVdOmgWJ54gmX0/C153vemiWzlMiL8GiBKsZr8tU//eM/M1QycI0RBk0815XuoLkl
         UhZLDwNnm+soThBf5wh4BH12wMuPtf4hUeIlerWdByoITnZV0QD0eDp2/8P3aSlKiKQd
         1x2w==
X-Gm-Message-State: APjAAAVMZ6MGETwKW4XqtYtJgZ0yeKdU5iNQuY5ZgvKBPSaU5YWva3mi
        m7uOpmunM1rwXk3OQghQD4U=
X-Google-Smtp-Source: APXvYqwfckTGIbynQBCAqX7EmODSFULXGqw2TQrQAdQutgLvuNuKnB2EA6YgNm1nFV6iR6fVjRB5cA==
X-Received: by 2002:aa7:8e46:: with SMTP id d6mr16566727pfr.91.1557896002038;
        Tue, 14 May 2019 21:53:22 -0700 (PDT)
Received: from voyager.jms.id.au ([36.255.48.244])
        by smtp.gmail.com with ESMTPSA id f29sm1296247pfq.11.2019.05.14.21.53.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 21:53:20 -0700 (PDT)
Received: by voyager.jms.id.au (sSMTP sendmail emulation); Wed, 15 May 2019 14:23:14 +0930
From:   Joel Stanley <joel@jms.id.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc/security: Fix build break
Date:   Wed, 15 May 2019 14:22:06 +0930
Message-Id: <20190515045206.10610-1-joel@jms.id.au>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a build break introduced in with the recent round of CPU
bug patches.

  arch/powerpc/kernel/security.c: In function ‘setup_barrier_nospec’:
  arch/powerpc/kernel/security.c:59:21: error: implicit declaration of
  function ‘cpu_mitigations_off’ [-Werror=implicit-function-declaration]
    if (!no_nospec && !cpu_mitigations_off())
                       ^~~~~~~~~~~~~~~~~~~

Fixes: 782e69efb3df ("powerpc/speculation: Support 'mitigations=' cmdline option")
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
This should be applied to the 4.14 and 4.19 trees. There is no issue
with 5.1. The commit message contains a fixes line for the commit in
Linus tree.
---
 arch/powerpc/kernel/security.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/security.c b/arch/powerpc/kernel/security.c
index e9af5d9badf2..68d4ec373cfc 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -4,6 +4,7 @@
 //
 // Copyright 2018, Michael Ellerman, IBM Corporation.
 
+#include <linux/cpu.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/seq_buf.h>
-- 
2.20.1

