Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B730E6861
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731409AbfJ0VTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731405AbfJ0VTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:10 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B574B214E0;
        Sun, 27 Oct 2019 21:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211149;
        bh=/z6edR+ar5qJn0sKLgrkE9Pv/uynN4goHo7mQYZ8Wyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BrJCkwmQ8bwCNoMaQW6Mn+nVdY7qdqB+Ur8dS2T5WD+g39kWaC1V+4qSM5gWKI0uJ
         Uxc006iLfT4E94jh3tY67fEE6vJdLme2lvMwxqtRROTUoPw2N7Ie2imhb20WnNOxJT
         T4ZVwtjpglLCVORiFlwdqvJPuuqZDId2cn3C3soo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 050/197] selftests: kvm: Fix libkvm build error
Date:   Sun, 27 Oct 2019 21:59:28 +0100
Message-Id: <20191027203354.391657340@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 6e06983dde969c15eb4fdab77f0eda8b18ea28e6 ]

Fix the following build error from "make TARGETS=kvm kselftest":

libkvm.a(assert.o): relocation R_X86_64_32 against `.rodata.str1.1' can not be used when making a PIE object; recompile with -fPIC

This error is seen when build is done from the main Makefile using
kselftest target. In this case KBUILD_CPPFLAGS and CC_OPTION_CFLAGS
are defined.

When build is invoked using:

"make -C tools/testing/selftests/kvm" KBUILD_CPPFLAGS and CC_OPTION_CFLAGS
aren't defined.

There is no need to pass in KBUILD_CPPFLAGS and CC_OPTION_CFLAGS for the
check to determine if --no-pie is necessary, which is the case when these
two aren't defined when "make -C tools/testing/selftests/kvm" runs.

Fix it by simplifying the no-pie-option logic. With this change, both
build variations work.

"make TARGETS=kvm kselftest"
"make -C tools/testing/selftests/kvm"

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ba78497519894..fc8aeb224c032 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -46,7 +46,7 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(UNAME_M) -I..
 
 no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
-        $(CC) -Werror $(KBUILD_CPPFLAGS) $(CC_OPTION_CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
+        $(CC) -Werror -no-pie -x c - -o "$$TMP", -no-pie)
 
 # On s390, build the testcases KVM-enabled
 pgste-option = $(call try-run, echo 'int main() { return 0; }' | \
-- 
2.20.1



