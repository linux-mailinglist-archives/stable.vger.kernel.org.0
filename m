Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76002EE94C
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 23:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbhAGWx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 17:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbhAGWxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 17:53:22 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB96CC0612F5;
        Thu,  7 Jan 2021 14:52:41 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id p18so6303792pgm.11;
        Thu, 07 Jan 2021 14:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q4EKfM/UykAzpJGwavvmFKVMSq591R3UWoZHA7HF3eo=;
        b=Z3DwANhR/EydQ/pT8/9aBcSh6GI0g0LS9rE/IkN+7em5cd7vpgcEklo0g4tfV0n7Jw
         fVBfxxQgkeGzIwb4RUDt6MjtVaAftHMa61yIySRheNYNQ+ZDrp91QgDqZ+bk2T00mFwE
         WWVTeZopWwGJhjwvIqjEwXK1dewIG8rnXEG9wdSwEpeDxpFpC6SF3BoABj70eqT2UDem
         tqkhPwBsmA2V7+WzW1jit9Wmmx6ImpR3oRAhzO7s5FsyfwmixO1qJmo1srnwHIPDo5ke
         NEMTnXN5pTPUEpzrqHoBouj8O9AnX93Z/m+1cAc1HzO2mOJfXxDI9uJZXmYfaoYqLZ58
         pufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q4EKfM/UykAzpJGwavvmFKVMSq591R3UWoZHA7HF3eo=;
        b=Els76OejHSwol3IAJrVWWfOPyzhu60VOM6Se38uBcoxY7e5TW6TX8smjHcrqezK1mV
         VanGhXChvMczmSRWOvxBOrZXzZlatdmFGxOa5qo6k5XlVMebO65JL7pfgRk2cRsCounB
         VdgPk8dUsi0pRuySsAIUQQI+5yBrZZ3fro434zt/R1R9hxNbuUpUK7KMFoO+4tM3XhJ4
         UKde095duqO4G8O0vXu8zbjhW7e1Ep7kMriDGYjAzZ737HPZmoUlKPppyTGF5T0zATuQ
         AK8+YQ61n4ny2+uXdA8YwyapL7hdcC7SzMBdwHhNy1erQ/nvJ19unN9c2Wca6IrQ9A+D
         CkSA==
X-Gm-Message-State: AOAM530I+nunZeeB61sR+asQeY5d4WTuQHIjOqy+Uawi4CquVmNqdBPy
        qGF/dwBjY6ju69W0MMnCQB/o9shoyr4=
X-Google-Smtp-Source: ABdhPJz8qjQLbY+x7sWjO9oB3B7vCcgf8+Ul70rcroTlofsq9c7bQOdUhjbzC9Pk3eL2yO5PBqKKtA==
X-Received: by 2002:a62:19cb:0:b029:19e:75c2:61ec with SMTP id 194-20020a6219cb0000b029019e75c261ecmr712266pfz.19.1610059960956;
        Thu, 07 Jan 2021 14:52:40 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a10sm6510603pfi.168.2021.01.07.14.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:52:40 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Andr=C3=A9=20Draszik?= <git@andred.net>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Du Changbin <changbin.du@gmail.com>
Subject: [stable 4.9.y 1/4] scripts/gdb: make lx-dmesg command work (reliably)
Date:   Thu,  7 Jan 2021 14:52:26 -0800
Message-Id: <20210107225229.1502459-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107225229.1502459-1-f.fainelli@gmail.com>
References: <20210107225229.1502459-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: André Draszik <git@andred.net>

commit d6c9708737c2107c38bd75f133d14d5801b8d6d5 upstream

lx-dmesg needs access to the log_buf symbol from printk.c.
Unfortunately, the symbol log_buf also exists in BPF's verifier.c and
hence gdb can pick one or the other.  If it happens to pick BPF's
log_buf, lx-dmesg doesn't work:

  (gdb) lx-dmesg
  Python Exception <class 'gdb.MemoryError'> Cannot access memory at address 0x0:
  Error occurred in Python command: Cannot access memory at address 0x0
  (gdb) p log_buf
  $15 = 0x0

Luckily, GDB has a way to deal with this, see
  https://sourceware.org/gdb/onlinedocs/gdb/Symbols.html

  (gdb) info variables ^log_buf$
  All variables matching regular expression "^log_buf$":

  File <linux.git>/kernel/bpf/verifier.c:
  static char *log_buf;

  File <linux.git>/kernel/printk/printk.c:
  static char *log_buf;
  (gdb) p 'verifier.c'::log_buf
  $1 = 0x0
  (gdb) p 'printk.c'::log_buf
  $2 = 0x811a6aa0 <__log_buf> ""
  (gdb) p &log_buf
  $3 = (char **) 0x8120fe40 <log_buf>
  (gdb) p &'verifier.c'::log_buf
  $4 = (char **) 0x8120fe40 <log_buf>
  (gdb) p &'printk.c'::log_buf
  $5 = (char **) 0x8048b7d0 <log_buf>

By being explicit about the location of the symbol, we can make lx-dmesg
work again.  While at it, do the same for the other symbols we need from
printk.c

Link: http://lkml.kernel.org/r/20170526112222.3414-1-git@andred.net
Signed-off-by: André Draszik <git@andred.net>
Tested-by: Kieran Bingham <kieran@bingham.xyz>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 scripts/gdb/linux/dmesg.py | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/gdb/linux/dmesg.py b/scripts/gdb/linux/dmesg.py
index f9b92ece7834..5afd1098e33a 100644
--- a/scripts/gdb/linux/dmesg.py
+++ b/scripts/gdb/linux/dmesg.py
@@ -23,10 +23,11 @@ class LxDmesg(gdb.Command):
         super(LxDmesg, self).__init__("lx-dmesg", gdb.COMMAND_DATA)
 
     def invoke(self, arg, from_tty):
-        log_buf_addr = int(str(gdb.parse_and_eval("log_buf")).split()[0], 16)
-        log_first_idx = int(gdb.parse_and_eval("log_first_idx"))
-        log_next_idx = int(gdb.parse_and_eval("log_next_idx"))
-        log_buf_len = int(gdb.parse_and_eval("log_buf_len"))
+        log_buf_addr = int(str(gdb.parse_and_eval(
+            "'printk.c'::log_buf")).split()[0], 16)
+        log_first_idx = int(gdb.parse_and_eval("'printk.c'::log_first_idx"))
+        log_next_idx = int(gdb.parse_and_eval("'printk.c'::log_next_idx"))
+        log_buf_len = int(gdb.parse_and_eval("'printk.c'::log_buf_len"))
 
         inf = gdb.inferiors()[0]
         start = log_buf_addr + log_first_idx
-- 
2.25.1

