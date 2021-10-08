Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA3F426999
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241511AbhJHLje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241301AbhJHLgR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:36:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCB5261353;
        Fri,  8 Oct 2021 11:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692743;
        bh=+x5DM1+xm3njE8PIoyCw1m19Ri0dQg1tG4CzgXS8NxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2l/euGH59RswWdHNT4yPmEPRNQGaH4DHWEADCIpGkAlmgPtc+J9vPxvkh8hiMiOAX
         qnszLBn4xQtasW8oN4/rs73brHAWYOj7r2Y7rIp9+yeJN4f+Jejfh792aZ4k79gCHv
         0dOaYppEMtFerKFrSGj//eXcWnW7PbXBokF8x3Ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 24/48] selftests:kvm: fix get_trans_hugepagesz() ignoring fscanf() return warn
Date:   Fri,  8 Oct 2021 13:28:00 +0200
Message-Id: <20211008112720.822788168@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



