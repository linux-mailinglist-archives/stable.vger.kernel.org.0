Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBCE63DA9D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 17:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiK3Q3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 11:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiK3Q3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 11:29:46 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB74F84DD7
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 08:29:44 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ha10so42722262ejb.3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 08:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j66AM6yEw+h2e5Qpe0Paz47YsLXnYSCCs7ToLjEkFbE=;
        b=n0aRt/pdbaNOD5yGncwAgWDPkLo4jlUKxpzjr6sOKj98U8h4lH/BuCf4E3aibhIRBJ
         mgsFuYISxGomjVjanltzfkXr0OmE8zIMPNJVZmWtULUGeuvNnWRKvfo7UYAzQrT/XiKP
         pFNUvT7rXmw2LZ9GHzQ1Ro0ndCmzNOfulp4PU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j66AM6yEw+h2e5Qpe0Paz47YsLXnYSCCs7ToLjEkFbE=;
        b=FLcY60SnO7ci9NIFv1qvX8novzVSdBZZprU/XHnc+HGowuEKIj4qx5BwEyRsShTG7p
         hsiMISpu9Ar0p0z8z0Ft9sLLgVaf4WcuPuww8taTECuSikpvmAQKEcWT8u7ZR8jasyxv
         LSgauRRo5qNBw4zIkXn/tJyeDq+jRb9NKm0lSANbfT1pBHUMz0B67nTwAQRh0C891jbH
         jxe8zbZbX9kkVcxSvfvlIiIs7O8CapGKQsMgydReDquFAPv1JxetE7ZRAzrUby8Vs0NA
         YUoLlTPzV+cw/lv3Ky1XUi6v90MQwmsoCO8gBaKJnobcCwR9j0gIuPnbXLZIp8YW0SLC
         3uqA==
X-Gm-Message-State: ANoB5pmFSc5xMZRtn9pCfx24+DhPshb6b6D6dQzuIz1qihzcFRDDfhUw
        jWlRciHr6V6QzWUnu/6LtrX7Vw==
X-Google-Smtp-Source: AA0mqf5t+AxtPgn9XE9oAuO13iEBvxrVJRUaFve2VxlhVUExpKerWrweeRvgV18uCHkh3j71qtM0WA==
X-Received: by 2002:a17:906:d281:b0:782:7790:f132 with SMTP id ay1-20020a170906d28100b007827790f132mr36684458ejb.649.1669825783467;
        Wed, 30 Nov 2022 08:29:43 -0800 (PST)
Received: from alco.roam.corp.google.com (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id cz15-20020a0564021caf00b004589da5e5cesm786114edb.41.2022.11.30.08.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 08:29:43 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 30 Nov 2022 17:29:20 +0100
Subject: [PATCH v7 1/2] kexec: Introduce kexec_with_frozen_processes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221127-snd-freeze-v7-1-127c582f1ca4@chromium.org>
References: <20221127-snd-freeze-v7-0-127c582f1ca4@chromium.org>
In-Reply-To: <20221127-snd-freeze-v7-0-127c582f1ca4@chromium.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Chromeos Kdump <chromeos-kdump@google.com>,
        Mark Brown <broonie@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.com>
Cc:     alsa-devel@alsa-project.org, sound-open-firmware@alsa-project.org,
        kexec@lists.infradead.org, stable@vger.kernel.org,
        Ricardo Ribalda <ribalda@chromium.org>,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=1993; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=1Eimjbcycq7qNsawd2rnV+J25oc3+SKoshi04EAzFkY=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjh4Tx9PZMNMSbqgT4Zoi7Sgxh6fRc9tbmVbCyGYlc
 GC5OS5KJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY4eE8QAKCRDRN9E+zzrEiGYkD/
 92N9Y4V14IUNRrC8n+NTCv5nr0Wh9MTAk9THEm+4TIUCb3UqoCmq2H9bF+N8XEN7J+RjxcUMQ0l/xe
 eA1eVXygt0w07oYoesMwZ8P7LTlvhN2Jkm9ePDQAcWLVFjgGixsThZokKgDa52sWE+eccR9biUr/Mu
 C4mLr7I+i1qYzVsANymbClIuaNEJPCGeHNqRSGCBOocwyqSWkSZEqHGIifb6LBHiecliMPwC4p36F0
 yAhSh//F1oavhYQ/FQ2LMRG2/JMI6bTknYSGNyH/fTctVslP9foINRXJ3hAChrfxKlytpyG9mDWxfk
 UVN/LaV9JBwmwyJ2qwiqUB+l4s9LYU9QV+lwwOHZX15hcCfmZyB0AtcroP6Z48I6ERTbXa7Ng1Y5jJ
 V2A9QJAeZat9nfEwQsxpJxi1TLPsmQgBcjuTUZaYWxbjymLBC7u+4RWeJDjvSi0m29D8XhOgD+igKV
 aswBMZwtgA6SkzeIY/fP3el9EjPT8GQTYKoK2b//ArUC0pW5UCPiJ1OK4JzJkkF9E6P20/8dvtJk9h
 2hFLnUS8s8iJ7aTazJ2WGGRPmRzzaDaK/YPbNZOiz7fbHWMbEB+spCGEX25Dgajb/qft6Ed3s1Aphi
 Fw++kttBHt8qnh2ZGuWwVaNdTPJY6vGashuAdgbrvcW/Pj/Jis2FalTkK9qA==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drivers running .shutdown() might want to wait for userspace to complete
before exiting.

If userspace is frozen and we are running kexec they will stall the
computer.

Add a way for them to figure out if they should just skip waiting for
userspace.

Cc: stable@vger.kernel.org
Fixes: 83bfc7e793b5 ("ASoC: SOF: core: unregister clients and machine drivers in .shutdown")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 include/linux/kexec.h | 3 +++
 kernel/kexec_core.c   | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 41a686996aaa..c22711e0f7b5 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -426,6 +426,8 @@ extern int kexec_load_disabled;
 /* flag to track if kexec reboot is in progress */
 extern bool kexec_in_progress;
 
+bool kexec_with_frozen_processes(void);
+
 int crash_shrink_memory(unsigned long new_size);
 ssize_t crash_get_memory_size(void);
 
@@ -507,6 +509,7 @@ static inline void __crash_kexec(struct pt_regs *regs) { }
 static inline void crash_kexec(struct pt_regs *regs) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
 static inline int kexec_crash_loaded(void) { return 0; }
+static inline bool kexec_with_frozen_processes(void) { return false; }
 #define kexec_in_progress false
 #endif /* CONFIG_KEXEC_CORE */
 
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index ca2743f9c634..8bc8257ee7ca 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -54,6 +54,11 @@ note_buf_t __percpu *crash_notes;
 /* Flag to indicate we are going to kexec a new kernel */
 bool kexec_in_progress = false;
 
+bool kexec_with_frozen_processes(void)
+{
+	return kexec_in_progress && pm_freezing;
+}
+EXPORT_SYMBOL(kexec_with_frozen_processes);
 
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {

-- 
2.38.1.584.g0f3c55d4c2-goog-b4-0.11.0-dev-696ae
