Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49841A7A1
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239212AbhI1F6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239215AbhI1F6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF0E0611CB;
        Tue, 28 Sep 2021 05:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808578;
        bh=+x5DM1+xm3njE8PIoyCw1m19Ri0dQg1tG4CzgXS8NxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k36MSbF11X0do/ooyn6Bn4MluLDACzWTWcNcbhtz23Zses9dOdozLbXzQ7F1rmQMk
         dAJXzQ6hpx+V2X8pPKMENjwpd/7wZj77fNjmm5DEVglFOV8oASF5gk02k5AlQtLPwr
         liSf03M7O1SZxA8/OzfEIUOfCHi1vcN6lnapehPZxrBsVDZq+X8mAfPQImJc0AkkxA
         z3KRErshnzyBaip7TKqODXEevGGFFI1kXfI8vzfxsF6LMN5Du8lUlGI+cVEve3oeow
         VFtaSyefxZS8veURWCmnCDjTfFFC8Ce8Pl72aE0PcrU4pz/V8DYlO3ru/9H4T7dnbp
         6CV6pbVxwktgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        bgardon@google.com, wangyanan55@huawei.com,
        axelrasmussen@google.com, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 25/40] selftests:kvm: fix get_trans_hugepagesz() ignoring fscanf() return warn
Date:   Tue, 28 Sep 2021 01:55:09 -0400
Message-Id: <20210928055524.172051-25-sashal@kernel.org>
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

[ Upstream commit 3a4f0cc693cd3d80e66a255f0bff0e2c0461eef1 ]

Fix get_trans_hugepagesz() to check fscanf() return value to get rid
of the following warning:

lib/test_util.c: In function ‘get_trans_hugepagesz’:
lib/test_util.c:138:2: warning: ignoring return value of ‘fscanf’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
  138 |  fscanf(f, "%ld", &size);
      |  ^~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/test_util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index af1031fed97f..938cd423643e 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -129,13 +129,16 @@ size_t get_trans_hugepagesz(void)
 {
 	size_t size;
 	FILE *f;
+	int ret;
 
 	TEST_ASSERT(thp_configured(), "THP is not configured in host kernel");
 
 	f = fopen("/sys/kernel/mm/transparent_hugepage/hpage_pmd_size", "r");
 	TEST_ASSERT(f != NULL, "Error in opening transparent_hugepage/hpage_pmd_size");
 
-	fscanf(f, "%ld", &size);
+	ret = fscanf(f, "%ld", &size);
+	ret = fscanf(f, "%ld", &size);
+	TEST_ASSERT(ret < 1, "Error reading transparent_hugepage/hpage_pmd_size");
 	fclose(f);
 
 	return size;
-- 
2.33.0

