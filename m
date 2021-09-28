Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8403E41A79E
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbhI1F6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238933AbhI1F6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3E01611CC;
        Tue, 28 Sep 2021 05:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808575;
        bh=wFYGAkwb4/WUJWCk1IRMUqwJzEIWLJ7Jffepp7pbjqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L120YetYLs24qbfuMm9QEpWNqfOt6S+lSPxOXRMudcxGu59qB9QStzpKXicTrnxkT
         j2rTnMoNt7EGwMUNwvkRhb4abGXxVTo5SH3mMu6WyNt9BvXO94yWksmTvAy0p+4ujF
         AXGePGUglt/x6UB0roKz6841fHBlISvVVM3hAFDiGVZst6kGXQXXr+GtWQkvaPgVH2
         cWv9PKmtnaZRMkcar8CiFklY+jQbyxG5MaZ0j5TMtuU98PlgWfdMP41AbX14D8Ngx5
         /xXzucURXKT1HyHs6KBNNe4OFUPY5Pv7u9oIoku31M1CVbDMcVWGmYEdLvGNq3YmKV
         nFbjOhRMR/GfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 24/40] selftests:kvm: fix get_warnings_count() ignoring fscanf() return warn
Date:   Tue, 28 Sep 2021 01:55:08 -0400
Message-Id: <20210928055524.172051-24-sashal@kernel.org>
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

[ Upstream commit 39a71f712d8a13728febd8f3cb3f6db7e1fa7221 ]

Fix get_warnings_count() to check fscanf() return value to get rid
of the following warning:

x86_64/mmio_warning_test.c: In function ‘get_warnings_count’:
x86_64/mmio_warning_test.c:85:2: warning: ignoring return value of ‘fscanf’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
   85 |  fscanf(f, "%d", &warnings);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
index e6480fd5c4bd..8039e1eff938 100644
--- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
@@ -82,7 +82,8 @@ int get_warnings_count(void)
 	FILE *f;
 
 	f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
-	fscanf(f, "%d", &warnings);
+	if (fscanf(f, "%d", &warnings) < 1)
+		warnings = 0;
 	fclose(f);
 
 	return warnings;
-- 
2.33.0

