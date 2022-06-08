Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6199542412
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbiFHFLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 01:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiFHFLK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 01:11:10 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09FB182BB5;
        Tue,  7 Jun 2022 19:13:07 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h1so16368282plf.11;
        Tue, 07 Jun 2022 19:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aOhxeGinTiqFY3sUnjKmPhDdExpM8Y03nOU4Qw10yiE=;
        b=Li31Gb4SobqbS4ApZbx4EUHpxHobSXV/5wd2xwHT1FtrUuNMpOzZHY3cA8mChO6RoG
         rcthPK3+5CtfBR9QSF3BwVnu17M3NfnQFFOM75X5XsXNykpR0Hs9JRRTz0AF4BzcobJc
         tDDtldyzWMKkZdL848+hhRPDkUgBEh+K11/8UNaZh15l8Mkf+aqcOWQX3X4XIV6rEF1Q
         oa+w/Me4w4IJqTBVHzNQGVEk0pfR/2zGmnFurTy7Lo092yA3AUBPVECxlG6pE3OI3zOT
         9qEtsMIZzgy12KUc8PvRRkIAhhluW9VELyaM2O57zM6cgGTzzqSJ3RA3Ww/Kn57QnYLR
         UPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aOhxeGinTiqFY3sUnjKmPhDdExpM8Y03nOU4Qw10yiE=;
        b=pARbE4S7c5v0nBz07iTpFMwv/xdTBMamCv94Qhux3UnszJNpZuQet9oHOyrtqoG4Td
         0MYDIUMFzrGMCk1+tIanrbMgP/KzoZO+Sd47uHZqmbP8vn+Wk05zqOk3k1L1S0uMOdvy
         Nf4OTD+C2dozgcO9wVOeCRnbJF6D1soBkgzh7AonDaDWSW6h/mCSomDiK9uSkbJl+YER
         meTiIGbwx4tWm+uOpzOCoQbKeFgcGdQt+CfBuIIzlUSiJknRPSbjvGYxFkJaV2ULCf8e
         +9CvBb6mEcabIRPdxaHEixGIYkXid132Qo3i1Jh2qL3byrAl+FXiejxKjOeUAXehnL5Q
         jglQ==
X-Gm-Message-State: AOAM531WNS1vtdDGGK6jLiUAKctFjsvLMbkX5tcPt158u/P4BQ6xx6ze
        53p4fgx+OIhITXT80g21td4=
X-Google-Smtp-Source: ABdhPJw8hMfR0tua4m0SEy1S1OgXeIbF4V5PkGrQfPsgWsUMmhqUCsQ6BqkO13wWMhARAgs9aXN46w==
X-Received: by 2002:a17:902:d504:b0:167:756a:f992 with SMTP id b4-20020a170902d50400b00167756af992mr15834566plg.160.1654654386690;
        Tue, 07 Jun 2022 19:13:06 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id s22-20020a170902a51600b001677841e9c2sm5335063plq.119.2022.06.07.19.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 19:13:06 -0700 (PDT)
From:   Chuang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>, stable@vger.kernel.org,
        Jingren Zhou <zhoujingren@didiglobal.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] kprobes: Rollback kprobe flags on failed arm_kprobe
Date:   Wed,  8 Jun 2022 10:12:45 +0800
Message-Id: <20220608021245.33575-1-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuang Wang <nashuiliang@gmail.com>

In aggrprobe scenes, if arm_kprobe() returns an error(e.g. livepatch and
kprobe are using the same function X), kprobe flags, while has been
modified to ~KPROBE_FLAG_DISABLED, is not rollled back.

Then, __disable_kprobe() will be failed in __unregister_kprobe_top(),
the kprobe list will be not removed from aggrprobe, memory leaks or
illegal pointers will be caused.

WARN disarm_kprobe:
 Failed to disarm kprobe-ftrace at 00000000c729fdbc (-2)
 RIP: 0010:disarm_kprobe+0xcc/0x110
 Call Trace:
  __disable_kprobe+0x78/0x90
  __unregister_kprobe_top+0x13/0x1b0
  ? _cond_resched+0x15/0x30
  unregister_kprobes+0x32/0x80
  unregister_kprobe+0x1a/0x20

Illegal Pointers:
 BUG: unable to handle kernel paging request at 0000000000656369
 RIP: 0010:__get_valid_kprobe+0x69/0x90
 Call Trace:
  register_kprobe+0x30/0x60
  __register_trace_kprobe.part.7+0x8b/0xc0
  create_local_trace_kprobe+0xd2/0x130
  perf_kprobe_init+0x83/0xd0

Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
Cc: stable@vger.kernel.org
Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
Signed-off-by: Chuang Wang <nashuiliang@gmail.com>

---
v1->v2:
- Supplement commit information: fixline, Cc stable

 kernel/kprobes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index f214f8c088ed..c11c79e05a4c 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2422,8 +2422,11 @@ int enable_kprobe(struct kprobe *kp)
 	if (!kprobes_all_disarmed && kprobe_disabled(p)) {
 		p->flags &= ~KPROBE_FLAG_DISABLED;
 		ret = arm_kprobe(p);
-		if (ret)
+		if (ret) {
 			p->flags |= KPROBE_FLAG_DISABLED;
+			if (p != kp)
+				kp->flags |= KPROBE_FLAG_DISABLED;
+		}
 	}
 out:
 	mutex_unlock(&kprobe_mutex);
-- 
2.34.1

