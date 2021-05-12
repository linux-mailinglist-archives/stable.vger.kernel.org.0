Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7962837CDE5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbhELQ7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:59:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243763AbhELQmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B2BB6192B;
        Wed, 12 May 2021 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835604;
        bh=2zWcmAgQ9bjXTUIYZLN/Gfg/0sz4RI2iBgchK/DDHbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIb/sC18oNyPSUWOcPMrENcW3qTCp3775dkiBgCSNDXviB3r82m41qUyE24UWI4ni
         /B2kDoTB8KV9TEDRntbpYDPrxT+92piTMWRPWBVMLmCsSYD9wkAvh2vuLnWI2ti5qL
         tsCVa2KJZ3wBS/zQqKWPTcseerYs/uC+j/KTnNiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 376/677] selftests: fix prepending $(OUTPUT) to $(TEST_PROGS)
Date:   Wed, 12 May 2021 16:47:02 +0200
Message-Id: <20210512144849.824914080@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit cb4969e6f9f5ee12521aec764fa3d4bbd91bc797 ]

Currently the following command produces an error message:

    linux# make kselftest TARGETS=bpf O=/mnt/linux-build
    # selftests: bpf: test_libbpf.sh
    # ./test_libbpf.sh: line 23: ./test_libbpf_open: No such file or directory
    # test_libbpf: failed at file test_l4lb.o
    # selftests: test_libbpf [FAILED]

The error message might not affect the return code of make, therefore
one needs to grep make output in order to detect it.

This is not the only instance of the same underlying problem; any test
with more than one element in $(TEST_PROGS) fails the same way. Another
example:

    linux# make O=/mnt/linux-build TARGETS=splice kselftest
    [...]
    # ./short_splice_read.sh: 15: ./splice_read: not found
    # FAIL: /sys/module/test_module/sections/.init.text 2
    not ok 2 selftests: splice: short_splice_read.sh # exit=1

The current logic prepends $(OUTPUT) only to the first member of
$(TEST_PROGS). After that, run_one() does

   cd `dirname $TEST`

For all tests except the first one, `dirname $TEST` is ., which means
they cannot access the files generated in $(OUTPUT).

Fix by using $(addprefix) to prepend $(OUTPUT)/ to each member of
$(TEST_PROGS).

Fixes: 1a940687e424 ("selftests: lib.mk: copy test scripts and test files for make O=dir run")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index a5ce26d548e4..be17462fe146 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -74,7 +74,8 @@ ifdef building_out_of_srctree
 		rsync -aq $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(OUTPUT); \
 	fi
 	@if [ "X$(TEST_PROGS)" != "X" ]; then \
-		$(call RUN_TESTS, $(TEST_GEN_PROGS) $(TEST_CUSTOM_PROGS) $(OUTPUT)/$(TEST_PROGS)) ; \
+		$(call RUN_TESTS, $(TEST_GEN_PROGS) $(TEST_CUSTOM_PROGS) \
+				  $(addprefix $(OUTPUT)/,$(TEST_PROGS))) ; \
 	else \
 		$(call RUN_TESTS, $(TEST_GEN_PROGS) $(TEST_CUSTOM_PROGS)); \
 	fi
-- 
2.30.2



