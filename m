Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F881D441B
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 05:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgEODi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 23:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726176AbgEODi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 23:38:27 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA2AC061A0C;
        Thu, 14 May 2020 20:38:26 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id fu13so377187pjb.5;
        Thu, 14 May 2020 20:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=semwFQKbUumCsuPBbqSdVLlwqa542y7E1U+Mdc3K92E=;
        b=WypUw6qdOo65YLISnXVforHKpFkozUe/ijcZyTJzt0FmAWDGTjJ4rqrGug588F36k0
         44S8bI9AFKtQBQHPErsXa1VE0z00X48q85tkDWHU4z4dPaFPdR15wGLY7knR6xXE7ywd
         KAipCb1rHuTdj1IWB+04y5MmZOOpm9SJCyP9S+bP+GU4PxdJFceEki44iU8ZtucJZlQp
         mKuQqrAkcmTfDVWQxYjZRIaYv4C1rGhsX15OOFEuKZWLKx4FZ8c0mgj10nHOl0fKjNAQ
         E0iY8ES6AlJEU+uUx3NWrsvL2at5YpOa1N2y1GraTdz1kYgagj2lYbzLHKyHVeLOnByv
         c3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=semwFQKbUumCsuPBbqSdVLlwqa542y7E1U+Mdc3K92E=;
        b=QNh5oeFbYq7vUzZsitfDPcH2t1l6k7Nx0/nZ9Zn5e25ar57oN0cHuLU6W0V9wYIOwB
         Z9BiN5PCPGjDBbrp+/jPhiyEiDTf3GVle+Bwr2nROx0bOS/eApSqXTwuD3QQhKSyT+Pm
         i4btt3TgfgTMAql0MTg1ExhRZ5jM2OKLLuTWoM9wJIeuBFU/zq7Mt+3hiEGCG7On6fND
         byubRSdCZowgyiItq0FCEGmgx1/x6xQP+1j0H4cXQKSf8yieulrvdixuizSacQTi8ZJq
         AmrLYCSLA9J8XvY+OIYbfVOG/ZWgR46Y8/T/Gy5+WfaqLx1SrCy/8Ki17x7FtJQPfJbU
         KhNw==
X-Gm-Message-State: AOAM533oEhLr+2utGv/PCIAt9P+2DkHATzigo+aUHHDC1NbqeEYqYi9R
        nTHR2u1G40+qWAtkV0b9I2FOsIC+CFy0fw==
X-Google-Smtp-Source: ABdhPJzCMbrxc40SVrl5ucEdZxkKiSALPad6VLa4KrRDgvjs1AqMp0TeLFfCR2KvAnZ2GLBEAE+5aA==
X-Received: by 2002:a17:90a:950a:: with SMTP id t10mr1243853pjo.193.1589513903969;
        Thu, 14 May 2020 20:38:23 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b75sm371172pjc.23.2020.05.14.20.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 20:38:23 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        kernel test robot <rong.a.chen@intel.com>
Subject: [PATCH 5.4] selftests/bpf: fix goto cleanup label not defined
Date:   Fri, 15 May 2020 11:38:05 +0800
Message-Id: <20200515033805.2172595-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kernel test robot found a warning when build bpf selftest for 5.4.y stable
tree:

prog_tests/stacktrace_build_id_nmi.c:55:3: error: label ‘cleanup’ used but not defined
   goto cleanup;
   ^~~~

This is because we are lacking upstream commit dde53c1b763b
("selftests/bpf: Convert few more selftest to skeletons"). But this
commit is too large and need more backports. To fix it, the
easiest way is just use the current goto label 'close_prog'.

Reported-by: kernel test robot <rong.a.chen@intel.com>
Fixes: da43712a7262 ("selftests/bpf: Skip perf hw events test if the setup disabled it")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index 1735faf17536..437cb93e72ac 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -52,7 +52,7 @@ void test_stacktrace_build_id_nmi(void)
 	if (pmu_fd < 0 && errno == ENOENT) {
 		printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
 		test__skip();
-		goto cleanup;
+		goto close_prog;
 	}
 	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n",
 		  pmu_fd, errno))
-- 
2.25.4

