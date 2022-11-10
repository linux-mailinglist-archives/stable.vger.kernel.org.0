Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0EB623E15
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 09:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiKJI4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 03:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiKJI4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 03:56:43 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EEA5A40912;
        Thu, 10 Nov 2022 00:56:42 -0800 (PST)
Received: from neptune.. (ip5f592f1a.dynamic.kabel-deutschland.de [95.89.47.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5F1F520E67BB;
        Thu, 10 Nov 2022 00:56:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5F1F520E67BB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1668070602;
        bh=GmmcWRHXej2dQfvPtFxEWyzjKiiDadj2sFvtiycrCxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReyQjGm7vcTT5+EjufyZiuYxT3zEfu/hTGvQWVZ92UX8yY08quVAEEli7XHPUthHf
         oApL7sM0Xh/X4wP2quDfqW+lqR5FS6mamP608xvZ2/8K6VR2A289QbxueA23eoZPjZ
         RvasQusIguP7/J6k4RoRicSk4O9IuZAGqMhnBRqA=
From:   Alban Crequy <albancrequy@linux.microsoft.com>
To:     bpf@vger.kernel.org
Cc:     stable@vger.kernel.org, albancrequy@linux.microsoft.com,
        flaniel@linux.microsoft.com, akpm@linux-foundation.org,
        andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        haoluo@google.com, john.fastabend@gmail.com, jolsa@kernel.org,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
        martin.lau@linux.dev, mykolal@fb.com, sdf@google.com,
        shuah@kernel.org, song@kernel.org, yhs@fb.com
Subject: [PATCH bpf v2 1/2] maccess: fix writing offset in case of fault in strncpy_from_kernel_nofault()
Date:   Thu, 10 Nov 2022 09:56:13 +0100
Message-Id: <20221110085614.111213-2-albancrequy@linux.microsoft.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221110085614.111213-1-albancrequy@linux.microsoft.com>
References: <20221110085614.111213-1-albancrequy@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a page fault occurs while copying the first byte, this function resets one
byte before dst.
As a consequence, an address could be modified and leaded to kernel crashes if
case the modified address was accessed later.

Fixes: b58294ead14c ("maccess: allow architectures to provide kernel probing directly")
Cc: <stable@vger.kernel.org> [5.8]
Signed-off-by: Alban Crequy <albancrequy@linux.microsoft.com>
Tested-by: Francis Laniel <flaniel@linux.microsoft.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

---

Changes v1 to v2:
- add 'cc:stable', 'Fixes:' and review tag
- fix my email
- rebase on bpf tree and tag for bpf tree
---
 mm/maccess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/maccess.c b/mm/maccess.c
index 5f4d240f67ec..074f6b086671 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -97,7 +97,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 	return src - unsafe_addr;
 Efault:
 	pagefault_enable();
-	dst[-1] = '\0';
+	dst[0] = '\0';
 	return -EFAULT;
 }
 
-- 
2.36.1

