Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B743041A7A5
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239217AbhI1F6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239123AbhI1F6K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F684611C7;
        Tue, 28 Sep 2021 05:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808591;
        bh=Xaf80vQCf6Z2EysDRr0wcPFN4faFcp6DJPtAaB5DD8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNm/TkAvtC27dfnr69HAD35qBTCRyMkUFa/7w3IwO0o4XL14ukK3b/NSdyLdL7PBA
         pgtBrl8LPVq7QbOmdGuaBYF71PUwImFzQwcE8pAxYKL7CGyvLWVTYGejKh8IeAOXoy
         rgygs27hhwJm8GUNPpuztTM84aAUISlJU9SSSoAvA2/1IxoipOXYQr3yB5Qb8bfsyt
         RGhVcEeRoG0ixDt2yqO33DPYZDXOXScuWnza77A87ADdAjjjNKIqof8FC/UAFh786R
         jyFCppgatKNOnrhHK4Flac1QTjuzFsyZYO0QgP5luOM1DnF5YUUuaN/W6fhp5PtVFX
         s241LCpSLElIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        bgardon@google.com, drjones@redhat.com, wangyanan55@huawei.com,
        axelrasmussen@google.com, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 27/40] selftests: kvm: fix get_run_delay() ignoring fscanf() return warn
Date:   Tue, 28 Sep 2021 01:55:11 -0400
Message-Id: <20210928055524.172051-27-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit f5013d412a43662b63f3d5f3a804d63213acd471 ]

Fix get_run_delay() to check fscanf() return value to get rid of the
following warning. When fscanf() fails return MIN_RUN_DELAY_NS from
get_run_delay(). Move MIN_RUN_DELAY_NS from steal_time.c to test_util.h
so get_run_delay() and steal_time.c can use it.

lib/test_util.c: In function ‘get_run_delay’:
lib/test_util.c:316:2: warning: ignoring return value of ‘fscanf’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
  316 |  fscanf(fp, "%ld %ld ", &val[0], &val[1]);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/include/test_util.h | 2 ++
 tools/testing/selftests/kvm/lib/test_util.c     | 4 +++-
 tools/testing/selftests/kvm/steal_time.c        | 1 -
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index c7409b9b4e5b..451fed5ce8e7 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -95,6 +95,8 @@ struct vm_mem_backing_src_alias {
 	uint32_t flag;
 };
 
+#define MIN_RUN_DELAY_NS	200000UL
+
 bool thp_configured(void);
 size_t get_trans_hugepagesz(void);
 size_t get_def_hugetlb_pagesz(void);
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index f80dd38a38b2..a9107bfae402 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -313,7 +313,9 @@ long get_run_delay(void)
 
 	sprintf(path, "/proc/%ld/schedstat", syscall(SYS_gettid));
 	fp = fopen(path, "r");
-	fscanf(fp, "%ld %ld ", &val[0], &val[1]);
+	/* Return MIN_RUN_DELAY_NS upon failure just to be safe */
+	if (fscanf(fp, "%ld %ld ", &val[0], &val[1]) < 2)
+		val[1] = MIN_RUN_DELAY_NS;
 	fclose(fp);
 
 	return val[1];
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 51fe95a5c36a..2172d65b85e4 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -19,7 +19,6 @@
 
 #define NR_VCPUS		4
 #define ST_GPA_BASE		(1 << 30)
-#define MIN_RUN_DELAY_NS	200000UL
 
 static void *st_gva[NR_VCPUS];
 static uint64_t guest_stolen_time[NR_VCPUS];
-- 
2.33.0

