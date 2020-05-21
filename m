Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65261DD07B
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgEUOtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729542AbgEUOtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:49:15 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC8DC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:49:15 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g12so5722815wrw.1
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g3RvzqheJz5jZQITJdBjUZmZwB0LgD02DIK0RuGWOu8=;
        b=hrj+0X9897NBpBsdG620do7Oi6F5Oq/1Ki6qTpnlRN8RYebtYnTmBQ6K8xVMxA9xqV
         HqPTMuhzUi+UQzFqUc+V7xXhKql8FeDjYwnMgXjRGFLDzU0X9o6ymzywOGi+6YzBPlwV
         YBArfxIQReFDyNN6m+BJwKzoTeLhVHeG1gd8A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g3RvzqheJz5jZQITJdBjUZmZwB0LgD02DIK0RuGWOu8=;
        b=QlJ8ZVpq3t29rxQnAjuC1SUDDF0d1RsBMMxA0dhm/RPuxcJmAzdXLCPQ9KwXH9W2kT
         afyiBTqzj1O/16n5yOcD+OBXclcTHtp6GGCzk1KRn90Yx/Bd/xySQ1OGwl9NCI1UxUyw
         dhkyplbEa9smv7DfTVbaHoE7qgQGpmJwlZ7gR5288nehLKHbkiyHG75NEpqfvJgFexpP
         0RVTWuR6TpsNw6wpyuagN5LOhpwq97V/R9NdruSefvd/8ZVDHhzY5vdOj0XeKuKbsmRa
         i/+HSNEPViRnhspyKYxC+NqLrGeqzSsbqvb1Qn8L4ahhJy12AepCVFNvVMqtIqj2ebVJ
         at7w==
X-Gm-Message-State: AOAM530kgw1E1nw4xYVM8JD910YfGISXjAbsZQz8FcH829BVvaauFjFv
        LAShHfIyjz2o6ivWMsJgZibPFlS6wz30/g==
X-Google-Smtp-Source: ABdhPJwqpaNpx2eggxxAGm/qb3ataQMtYpl1v49hs2LbfE424brVRn28hwH7Bj4zWFKl74zEXvuhQg==
X-Received: by 2002:adf:dfcf:: with SMTP id q15mr8482669wrn.137.1590072553570;
        Thu, 21 May 2020 07:49:13 -0700 (PDT)
Received: from localhost.localdomain (1.e.1.e.a.a.1.2.4.f.7.0.3.e.c.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:8ce3:7f4:21aa:e1e1])
        by smtp.gmail.com with ESMTPSA id c16sm6481122wrv.62.2020.05.21.07.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 07:49:12 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     stable@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        kernel test robot <rong.a.chen@intel.com>
Subject: [PATCH 4.19.y] selftests: bpf: fix use of undeclared RET_IF macro
Date:   Thu, 21 May 2020 15:48:41 +0100
Message-Id: <20200521144841.7074-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 634efb750435 ("selftests: bpf: Reset global state between
reuseport test runs") uses a macro RET_IF which doesn't exist in
the v4.19 tree. It is defined as follows:

        #define RET_IF(condition, tag, format...) ({
                if (CHECK_FAIL(condition)) {
                        printf(tag " " format);
                        return;
                }
        })

CHECK_FAIL in turn is defined as:

        #define CHECK_FAIL(condition) ({
                int __ret = !!(condition);
                int __save_errno = errno;
                if (__ret) {
                        test__fail();
                        fprintf(stdout, "%s:FAIL:%d\n", __func__, __LINE__);
                }
                errno = __save_errno;
                __ret;
        })

Replace occurences of RET_IF with CHECK. This will abort the test binary
if clearing the intermediate state fails.

Fixes: 634efb750435 ("selftests: bpf: Reset global state between reuseport test runs")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/bpf/test_select_reuseport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_select_reuseport.c b/tools/testing/selftests/bpf/test_select_reuseport.c
index cdbbdab2725f..b14d25bfa830 100644
--- a/tools/testing/selftests/bpf/test_select_reuseport.c
+++ b/tools/testing/selftests/bpf/test_select_reuseport.c
@@ -616,13 +616,13 @@ static void cleanup_per_test(void)
 
 	for (i = 0; i < NR_RESULTS; i++) {
 		err = bpf_map_update_elem(result_map, &i, &zero, BPF_ANY);
-		RET_IF(err, "reset elem in result_map",
-		       "i:%u err:%d errno:%d\n", i, err, errno);
+		CHECK(err, "reset elem in result_map",
+		      "i:%u err:%d errno:%d\n", i, err, errno);
 	}
 
 	err = bpf_map_update_elem(linum_map, &zero, &zero, BPF_ANY);
-	RET_IF(err, "reset line number in linum_map", "err:%d errno:%d\n",
-	       err, errno);
+	CHECK(err, "reset line number in linum_map", "err:%d errno:%d\n",
+	      err, errno);
 
 	for (i = 0; i < REUSEPORT_ARRAY_SIZE; i++)
 		close(sk_fds[i]);
-- 
2.20.1

