Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD03763D9D0
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 16:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiK3Pr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 10:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiK3Pr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 10:47:56 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E9D218BD
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:47:46 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id b2so26059765eja.7
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PpwU6lO07Wd5+RTLzDaFrlMeJKtxn3n7JzQ4dKSGqkc=;
        b=f6hF3vFsxSnGCy9wCKWuHFT0WJZyRYdEltOsfQYOfxdVzNYA56H5+kI6SDsG8Jv8iP
         xpMthqB2d9L+tvEU+8mmi4lIjO4ZSwm3TkU6BjYGKxkfEgyV/Y1KWwmQJzZXLLRuOccr
         jLgTTdIqz4gsM+g+psj9xMSLrrxOY19iAPPkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PpwU6lO07Wd5+RTLzDaFrlMeJKtxn3n7JzQ4dKSGqkc=;
        b=nu749vesJ+CwukvDOE8TeechE6RpdtbA2z6kstUfuM6yGyiBP9ScSlvwbfusC1wwr7
         e6UOjge+Ly3V+CwQ0MqpGuOkS9Iwutl3VxR6FSbFUiCLzW8eIjjl0fRYDFJXO5vrj7Gm
         /7q27LytcxWAzYQZA0QwU6eW9Oja4vjVBiaRC+L0lQIn9/k3hwB5u8eRS0V6ewQFuYaA
         4aGa8Eypar+R6QDittqv5JbImN2xxqbPjpNZ1lXZhRvOE2XoLOO1tXin0N4AAvuJOqBq
         k2y56SWEhIGkXHzl0873cRBIsbvyyGyJVirl4f/GAE/twrcY3suRzOl7xRDr+u6+RC3u
         7e+Q==
X-Gm-Message-State: ANoB5pmTC+L52jzTjXmySTS1MiXl7vj8PR5u6c8QfUACABl76GKaSk+/
        wqLWFII0pSFMp0C6xxp5w3leJw==
X-Google-Smtp-Source: AA0mqf7DwqNEHgiWsouxEwORa56y6/ebKwumRyswcDnFFZOeUNCe+tAd3MtXuHm+kPXx5zdP5k9qsg==
X-Received: by 2002:a17:906:7d50:b0:79e:4880:dd83 with SMTP id l16-20020a1709067d5000b0079e4880dd83mr42393283ejp.166.1669823264990;
        Wed, 30 Nov 2022 07:47:44 -0800 (PST)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:5b33:e3f2:6a0b:dcdd])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090623e900b007bf24b8f80csm775075ejg.63.2022.11.30.07.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:47:44 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 30 Nov 2022 16:47:15 +0100
Subject: [PATCH v6 1/2] kexec: Introduce kexec_with_frozen_processes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221127-snd-freeze-v6-1-3e90553f64a5@chromium.org>
References: <20221127-snd-freeze-v6-0-3e90553f64a5@chromium.org>
In-Reply-To: <20221127-snd-freeze-v6-0-3e90553f64a5@chromium.org>
To:     Chromeos Kdump <chromeos-kdump@google.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        kexec@lists.infradead.org, sound-open-firmware@alsa-project.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=1871; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=8KNJHp4bIWX3457t5aVwfPrimmRsszM5ZU7XjdRn1bo=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjh3sY6zR75vurA7LbZ/y+DlMy3+LOHJvYsQBT5ZNe
 OrXrGryJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY4d7GAAKCRDRN9E+zzrEiGE7D/
 42IsMvDeI6JrkcVeMw7Hlfq60ybXBrbBYP6z6lfI2McsZDckIPRHulAy1YaBGvwleMujpo8QR/zGrv
 mQVQYgRmSc/2j1YZq+QAOeY3qRY0FBGqtTaoHMfhOUkHVWWxYzK1oltg2HO43+cIyylRYtSCfOLY5Y
 w53p26AsgVTDQ4fxK/O8jrjIkW13Jbt5WH3L37A+QIIs+kYAXvmpPtzhP9EHsAb6rSD641jnBqRWBN
 gbRcoyer/rWDxvP3MvKiV4I9ZNjo3aikeI+quK7XKCDXM1cQrDeDfqCfASH4iKEcwlNvutYUARz8Cn
 T6Cz2A8fhHfYiC2zgz9H7jkg6DbSnFtm2Qug08WDdUHpVlsEuv/RjNNNkVM3OZ2IucOUqqCnIgXyxv
 t0Q1FJf6kMOV7Ro0xS3QAYlKrKX/3qKHTvhHpzzJjTl3dGv+MDaTKiJ1gS2SEQlpTNiyMoZ9GPlHMK
 CQ/VXwvDyESv6ppBKX/2vD5RkxySkE9xFNbVCW8EhvZPTgBpROM1bBm0AMhea5nSN5WlHi43N35JXE
 JWQV0jbgACSFhMdc1LxqiQhXKKpZNV2M7draG29cUlIVxJ5ofMLzLBFWk4AykI+eXVMeXzrY515t8R
 5B0mNX5S0bm/nLJ9+PeTGx6CTZ2XUspcyg7KtBfwXj1O/SeVQeoo5rmGgVEg==
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
