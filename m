Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F196CA898
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 17:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjC0PHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 11:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjC0PHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 11:07:11 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86591BFE
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:07:09 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y4so37604960edo.2
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679929628;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4F21eaCjPlHPX0mt5BYCkFL5YU30FB5WE06H9+TgyGM=;
        b=Nk8teTJSKpMvzOa2aMHyMoIsxBKdK0bqysKUKWgePW4/z76CuPzpsa2b9Svg7JXOua
         ls6++OZGzpLGm2yBZC1w3G/FdDMXQutiA7p/DqRBiiqQ/NHmLhrQa/wjG/GOZFyjuTWP
         eSkjeOLKdDPKy5v835waRLRiQO7MXqQqFQSfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679929628;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4F21eaCjPlHPX0mt5BYCkFL5YU30FB5WE06H9+TgyGM=;
        b=Kr46WHySwFFoitnYOGubQ1rV681eizpxl2TQgFKLvKlzoFac9285E1uW3Mmk72Hzdu
         CcDat/FqQdnsCnriY7ReL2qFWcpR7Es0lLc0KCY4EBwOq+EB6szuzvjhl2LrDwl7QqWT
         hoBGE+M8+jmn+pJpNCkdMP0c8xA3CBhecMZXIfkXOGKmo5tmZFKLa8M/dP2padUCfc7a
         td6c76CPgeapMgN98ateRq6FsSFLqnFnfniXFluRjo/xOkAgJ7+pdDyXoTgiMC1VedGe
         RqHQMulqiJ50KRcHJHG7qXAxs/OB9eAa2xx6N65ZLfDt3YIkavGs6WPav3zttJMcLXRe
         Mmqg==
X-Gm-Message-State: AAQBX9cYtEZ9YQ9GJNLMHCLewZ5sAAWjVHb/V5N5MZ0zf2gLHZMWlaTd
        SQqkvP056VU/e/dohTcTo8yuEA==
X-Google-Smtp-Source: AKy350ZZZL8pphDOUectQe/OR6qxHzSfDr7AGLq5vY5gioai9U/NBlK35cUThEdpgdEqCtzjJsZJCA==
X-Received: by 2002:a05:6402:d3:b0:4fa:e1fd:5a30 with SMTP id i19-20020a05640200d300b004fae1fd5a30mr12303438edu.19.1679929628405;
        Mon, 27 Mar 2023 08:07:08 -0700 (PDT)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:ed3c:5e9e:b8e4:8695])
        by smtp.gmail.com with ESMTPSA id t9-20020a50c249000000b005021d1ae6adsm5312428edf.28.2023.03.27.08.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 08:07:08 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 27 Mar 2023 17:06:54 +0200
Subject: [PATCH v4 2/2] x86/purgatory: Add linker script
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230321-kexec_clang16-v4-2-1340518f98e9@chromium.org>
References: <20230321-kexec_clang16-v4-0-1340518f98e9@chromium.org>
In-Reply-To: <20230321-kexec_clang16-v4-0-1340518f98e9@chromium.org>
To:     Eric Biederman <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Philipp Rudo <prudo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, kexec@lists.infradead.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=4062; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=qY09zbcWDi4omI4cAAqSkSf1QXILb3VpDDT9kkUrd8k=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBkIbEXTTl0yvDRVdkTXHHm+0bOTv2j/hTT7auw+OrA
 crD/BLWJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCZCGxFwAKCRDRN9E+zzrEiAsbD/
 0UsWhT4KOuvSbykGED1lnG/+pTSa3Xp9DDzRODKaqq2yNEiujiz6N8UcEW7t5GEA1++UUUAZPD8MBd
 bqegVfBE1QvTudCz7SYGQ34tYg0NRZfYEJRi4GjJ8LWSH3aBVjTdRTOHVf3Ixv5iZXjA5CnD7gij80
 CVs0m7tTmWtk/mISLzsXIYvDVvIumbQD9tevfwTFP1gk8TqZk7nE/LFzTyuiDwBzGWQuRFKeBJM7qQ
 lhCoPJcFrLahBfcmEKsbhcznykvHmhTRHFf5s0uRr7qVWANQd4l+a/2+XOSgEwwheY87nL5H2Z6fXY
 oc02JXg7tJtKn7W5uqnoyUfJWj5W7QiYwN9KDAdfVBUGaVYwEX75y8EMjdN4vhdgmCuHcMxoC/BQz8
 fDl/PO8eCnDXEsg5z+is1bdMXSJ20JCU1GPgldC9eG2QR7kFXgOF5NOLg2ndjXwd5cVDB0aAuzxfAe
 FTJDe/5ecHdkjIrCSECROJSIAlKKu/5zGsJ0yaTs1aIr02aiU0y2UZQ9HCLdcXHf4erZBypIYNy+QE
 fOoXFDdNjXCWkQlhBsEsrgIhrSZWbvMjM3KJ9Vvb8q1Er0jFnuvOqclpT0mwW5gLbsvQv2+gPHPHdq
 M+FO5RVET3Muy4/a+4eTLUi8jn0UyioYEI4LV5esDnAGuRelODSlNgdM6ohQ==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure that the .text section is not divided in multiple overlapping
sections. This is not supported by kexec_file.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 arch/x86/purgatory/.gitignore        |  2 ++
 arch/x86/purgatory/Makefile          | 20 +++++++++----
 arch/x86/purgatory/kexec-purgatory.S |  2 +-
 arch/x86/purgatory/purgatory.lds.S   | 57 ++++++++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 7 deletions(-)

diff --git a/arch/x86/purgatory/.gitignore b/arch/x86/purgatory/.gitignore
index d2be1500671d..1fe71fe5945d 100644
--- a/arch/x86/purgatory/.gitignore
+++ b/arch/x86/purgatory/.gitignore
@@ -1 +1,3 @@
 purgatory.chk
+purgatory.lds
+purgatory
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 17f09dc26381..4dc96d409bec 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -16,10 +16,11 @@ CFLAGS_sha256.o := -D__DISABLE_EXPORTS
 
 # When linking purgatory.ro with -r unresolved symbols are not checked,
 # also link a purgatory.chk binary without -r to check for unresolved symbols.
-PURGATORY_LDFLAGS := -e purgatory_start -z nodefaultlib
-LDFLAGS_purgatory.ro := -r $(PURGATORY_LDFLAGS)
-LDFLAGS_purgatory.chk := $(PURGATORY_LDFLAGS)
-targets += purgatory.ro purgatory.chk
+PURGATORY_LDFLAGS := -nostdlib -z nodefaultlib
+LDFLAGS_purgatory := -r $(PURGATORY_LDFLAGS) -T
+LDFLAGS_purgatory.chk := -e purgatory_start $(PURGATORY_LDFLAGS)
+
+targets += purgatory.lds purgatory.ro purgatory.chk
 
 # Sanitizer, etc. runtimes are unavailable and cannot be linked here.
 GCOV_PROFILE	:= n
@@ -72,10 +73,17 @@ CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
 AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
 
-$(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
+OBJCOPYFLAGS_purgatory.ro := -O elf64-x86-64
+OBJCOPYFLAGS_purgatory.ro += --remove-section='*debug*'
+OBJCOPYFLAGS_purgatory.ro += --remove-section='.comment'
+OBJCOPYFLAGS_purgatory.ro += --remove-section='.note.*'
+$(obj)/purgatory.ro: $(obj)/purgatory FORCE
+		$(call if_changed,objcopy)
+
+$(obj)/purgatory.chk: $(obj)/purgatory FORCE
 		$(call if_changed,ld)
 
-$(obj)/purgatory.chk: $(obj)/purgatory.ro FORCE
+$(obj)/purgatory: $(obj)/purgatory.lds $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
 
 $(obj)/kexec-purgatory.o: $(obj)/purgatory.ro $(obj)/purgatory.chk
diff --git a/arch/x86/purgatory/kexec-purgatory.S b/arch/x86/purgatory/kexec-purgatory.S
index 8530fe93b718..54b0d0b4dc42 100644
--- a/arch/x86/purgatory/kexec-purgatory.S
+++ b/arch/x86/purgatory/kexec-purgatory.S
@@ -5,7 +5,7 @@
 	.align	8
 kexec_purgatory:
 	.globl	kexec_purgatory
-	.incbin	"arch/x86/purgatory/purgatory.ro"
+	.incbin	"arch/x86/purgatory/purgatory"
 .Lkexec_purgatory_end:
 
 	.align	8
diff --git a/arch/x86/purgatory/purgatory.lds.S b/arch/x86/purgatory/purgatory.lds.S
new file mode 100644
index 000000000000..610da88aafa0
--- /dev/null
+++ b/arch/x86/purgatory/purgatory.lds.S
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <asm-generic/vmlinux.lds.h>
+
+OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT)
+
+#undef i386
+
+#include <asm/cache.h>
+#include <asm/page_types.h>
+
+ENTRY(purgatory_start)
+
+SECTIONS
+{
+	. = 0;
+	.head.text : {
+		_head = . ;
+		HEAD_TEXT
+		_ehead = . ;
+	}
+	.rodata : {
+		_rodata = . ;
+		*(.rodata)	 /* read-only data */
+		*(.rodata.*)
+		_erodata = . ;
+	}
+	.text :	{
+		_text = .; 	/* Text */
+		*(.text)
+		*(.text.*)
+		*(.noinstr.text)
+		_etext = . ;
+	}
+	.data :	{
+		_data = . ;
+		*(.data)
+		*(.data.*)
+		*(.bss.efistub)
+		_edata = . ;
+	}
+	. = ALIGN(L1_CACHE_BYTES);
+	.bss : {
+		_bss = . ;
+		*(.bss)
+		*(.bss.*)
+		*(COMMON)
+		. = ALIGN(8);	/* For convenience during zeroing */
+		_ebss = .;
+	}
+
+	/* Sections to be discarded */
+	/DISCARD/ : {
+		*(.eh_frame)
+		*(*__ksymtab*)
+		*(___kcrctab*)
+	}
+}

-- 
2.40.0.348.gf938b09366-goog-b4-0.11.0-dev-696ae
