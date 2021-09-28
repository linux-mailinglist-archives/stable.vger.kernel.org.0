Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C6041A801
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239640AbhI1GAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238978AbhI1F7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 301A261353;
        Tue, 28 Sep 2021 05:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808618;
        bh=wFYGAkwb4/WUJWCk1IRMUqwJzEIWLJ7Jffepp7pbjqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Les5pIBIiXmeptNewofLvTvRlsNuIF1akK9KdfjU4H63smOFDU/ijYmjCz0lJP3wf
         LMqvgYa6N9INH9jtyHrsDxqMjy4539czIp5Dk36xX6rR1ocscATaksbu5Ndku7ilj9
         yHQU7MD01Wx1UzNMV3tw0/79P0fWFmFWvnpe0GHPQz3aEUvkT5V+05RVt5KwhuT0rC
         UvWrQE9pfqMz1soKC5UgtLr5dCJZC5idWuOZYe/Fd4AnuJ8xNu8OeWMfkW1+uUWLBj
         vwOs5iMZgtcigolj6ZiAzMzk4Y54yBC0M5V9oabgTyOEtlYO8zK4cALWzCYkEQOEwu
         xU403oXZ17vjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/23] selftests:kvm: fix get_warnings_count() ignoring fscanf() return warn
Date:   Tue, 28 Sep 2021 01:56:37 -0400
Message-Id: <20210928055645.172544-16-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055645.172544-1-sashal@kernel.org>
References: <20210928055645.172544-1-sashal@kernel.org>
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

