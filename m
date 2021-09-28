Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6F841A834
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbhI1GCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239086AbhI1GAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:00:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8E6761378;
        Tue, 28 Sep 2021 05:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808634;
        bh=xVsdVb9zL63spLoYUIih1YQ/ViuFczmdjpKNj5k36q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pul9ExTpvGqfDQoOkZx/2tNXAjwFYfOG08Uy1KNnXGIAmg2U3NJL4wvdqy1SmJRyC
         Pt/vfHV43S7Jo2ZfbBPJVTxm1LEOWlJwd6MoYC0O+DyStF4cHlGe9xB7pghsp2WO0r
         AbWhNwZJ8n2CaDkV8F4IOA/aOXF7t5TI/fHQXcViXzM59aXcB2/415NjhqBq6bKg1k
         FeIsZHm+A4ldP1V+Yzu82V39L8mWObN1vYfPruDtvassfZj2U2uroubdLDxrtI6ZPv
         i/Jny1pTVIQOEJ413mK5IYI/skgWZ/d62VJPhKhb+qNE5djcEWMm5g67iP46iggWVC
         b0wbXsffkH29A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/11] selftests:kvm: fix get_warnings_count() ignoring fscanf() return warn
Date:   Tue, 28 Sep 2021 01:57:02 -0400
Message-Id: <20210928055704.172814-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055704.172814-1-sashal@kernel.org>
References: <20210928055704.172814-1-sashal@kernel.org>
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
index 00bb97d76000..2cbc09aad7f6 100644
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

