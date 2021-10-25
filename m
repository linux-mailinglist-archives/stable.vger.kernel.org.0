Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAF5439B30
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 18:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhJYQJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 12:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbhJYQJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 12:09:17 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73134C061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 09:06:54 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d10so9671136wrb.1
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 09:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yFe5GGaeJFu2GKxSPemiy1bz7gdW4h8FhVeuz6UJ2DM=;
        b=Vr3A3hTsH7C0M962KAv1PU6N+TfxR3vg4wlw8M92HOmJnOFfsGOPXH4FFyYmwQ3sR3
         3hA6o5gvthxNBTRACl/0bn3U7R6obcvmVxE1t16R0H+aaWdsXHyPztvhRPfhwSePVUMw
         PmO9b8f2QACRVsy2ftvYsCPq5z3U5979LeT/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yFe5GGaeJFu2GKxSPemiy1bz7gdW4h8FhVeuz6UJ2DM=;
        b=jUW7TY9zH7si/Zc1ERK4YuMOLTsOOfLNFNjte7G8ygQbsRROfyg5UwVuS25R6C8UsZ
         M+PVN42iWRz3CPuLtjPsC7Z5LqOH+Hcu6IHStU6e3BcK9VR9c8R9ivNRzt2zfX8FvS9I
         5uBIh0JbFEwLNCSrvCerLRTiK+LYU61SShSV97TKGaSSK6+FlrsRV6GvF+KOGc1M0QD9
         mgWn2nmhlEGYCNcNi1RUxuM/8Vzs6CJbls4MhfPGV0Gt+rINLPuzf5sD6L7c8bXiBoUR
         RgHxp7ee/H5cZP6wO24B186kuC9KR2tOPm2Auz9Rmzti92O5OAmQMRxedW4g3680TjOV
         vbUw==
X-Gm-Message-State: AOAM530m9GW8LeiifesuegXAJQl4hGiPqrNgZVjHRXeZFRYEjJXU7qFI
        xLlfvs2k09Qu6gTq68DRQj6aHqsFTFZl9g==
X-Google-Smtp-Source: ABdhPJzmBhKlBtOunaxydAeU3Dx0lvh/Rh7h8RPj8kVvP4xjyRBE7ojd7H/6i0KAPqbHoRjZah2vJQ==
X-Received: by 2002:a05:6000:15c8:: with SMTP id y8mr8496350wry.377.1635178013060;
        Mon, 25 Oct 2021 09:06:53 -0700 (PDT)
Received: from altair.lan (9.9.9.b.d.0.e.9.6.1.4.a.3.5.6.6.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:6653:a416:9e0d:b999])
        by smtp.googlemail.com with ESMTPSA id k17sm21454258wmj.0.2021.10.25.09.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:06:52 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     gregkh@linuxfoundation.org, andrii@kernel.org
Cc:     stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 5.10] selftests: bpf: fix backported ASSERT_FALSE
Date:   Mon, 25 Oct 2021 17:06:19 +0100
Message-Id: <20211025160619.501058-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 183d9ebd449c ("selftests/bpf: Fix core_reloc test runner") causes
builds of selftests/bpf to fail on 5.10.y since the branch doesn't have the
ASSERT_FALSE macro yet. Replace ASSERT_FALSE with ASSERT_EQ.

Fixes: 183d9ebd449c ("selftests/bpf: Fix core_reloc test runner")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/bpf/prog_tests/core_reloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 8b641c306f26..5b52985cb60e 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -857,7 +857,7 @@ void test_core_reloc(void)
 			goto cleanup;
 		}
 
-		if (!ASSERT_FALSE(test_case->fails, "obj_load_should_fail"))
+		if (!ASSERT_EQ(test_case->fails, false, "obj_load_should_fail"))
 			goto cleanup;
 
 		equal = memcmp(data->out, test_case->output,
-- 
2.32.0

