Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8A1234CD6
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 23:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgGaVUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 17:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgGaVUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 17:20:13 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065F9C061574;
        Fri, 31 Jul 2020 14:20:12 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b186so4788421pfb.9;
        Fri, 31 Jul 2020 14:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2m8bxGCf+gpIPT9ul2HDHjNGeJCBm38FKDdWisVHgKI=;
        b=l5Earp68wcfJil4yyIni/DwT8pjkau0mElKuIw8rHR0DoIEBDXb06cnyTb0Yb3BvYT
         hJIU6w3yGx2SgUYizL0sTaUDvbKcMfARYDIOimjJYGFS+Zwhi1eyM/MDSXLBL2X72vDK
         ZyNxE+Y42Bk0LGLGn/xTDoUyYy5wR9QC0FlqAjB2616RnUNRjTs4wPQ5E+xxu4JtFLvE
         m9/Ut3Pt5UZK5dfxk3vDLrYLqYMhInXbpxHYrGiapI2MVPeOgh2r5oYQ4B0VC1/8ZHHv
         8t2jf6pTfIQKeDirT41isCr+pTNamOnKVQJmbVL7roOaXTeUcJKEqLQe3Syo5REPj50Q
         Pw1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2m8bxGCf+gpIPT9ul2HDHjNGeJCBm38FKDdWisVHgKI=;
        b=bNJO5jbRXF0HJ+6yg2TTEsiwkA9KePz+11Z/FwNLUGDejYNxUuED95KZ7ot6Duxl7P
         YETo0a0BIsrgLNN7CRbXF1FpgWMRWZCw0qDOEVBg+lC5lzAwmGhmHLZHEFY/kBfhmtva
         GCSLiRLMi57yRdix5ousuwmK+D3ellKVNMg7ZvK/YofiqwdIBCRCpcWhciPn+ISrf2DT
         9UJXDVYzAl/cBss3y/IytZWQ6P5UcqV9kOjBkOqKopIIjZ1fnRegS7wIJl0C+2/OKawh
         w+qWMUaycqxDRbAaKqZbFN0acpBEeYD1UtmRjSFX5Tp71qkhKT4kVNxuM+UcBjj7l9T2
         eyWw==
X-Gm-Message-State: AOAM530cljwv7zl4MwJ5pwzcPqkAzsZOppWelublxq4LMbQj44SXFWrO
        s3jLMpfu8DA2lA1DTuyZKB4=
X-Google-Smtp-Source: ABdhPJztbF7d7FxQwrIjj1SdW8MB0sElEnBNafOSNFVht7V8dcXYE8tZmv6k/D4EYLNo49zSBAnGHQ==
X-Received: by 2002:a62:1ccb:: with SMTP id c194mr5377357pfc.277.1596230411764;
        Fri, 31 Jul 2020 14:20:11 -0700 (PDT)
Received: from octofox.cadence.com ([2601:641:400:e00:19b7:f650:7bbe:a7fb])
        by smtp.gmail.com with ESMTPSA id s22sm5687449pfh.16.2020.07.31.14.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 14:20:11 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] xtensa: fix xtensa_pmu_setup prototype
Date:   Fri, 31 Jul 2020 14:19:52 -0700
Message-Id: <20200731211952.26802-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the following build error in configurations with
CONFIG_XTENSA_VARIANT_HAVE_PERF_EVENTS=y:

  arch/xtensa/kernel/perf_event.c:420:29: error: passing argument 3 of
  ‘cpuhp_setup_state’ from incompatible pointer type

Cc: stable@vger.kernel.org
Fixes: 25a77b55e74c ("xtensa/perf: Convert the hotplug notifier to state machine callbacks")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/kernel/perf_event.c b/arch/xtensa/kernel/perf_event.c
index 99fcd63ce597..a0d05c8598d0 100644
--- a/arch/xtensa/kernel/perf_event.c
+++ b/arch/xtensa/kernel/perf_event.c
@@ -399,7 +399,7 @@ static struct pmu xtensa_pmu = {
 	.read = xtensa_pmu_read,
 };
 
-static int xtensa_pmu_setup(int cpu)
+static int xtensa_pmu_setup(unsigned int cpu)
 {
 	unsigned i;
 
-- 
2.20.1

