Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A07511DA9
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfEBPcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729142AbfEBPcR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90E8E20675;
        Thu,  2 May 2019 15:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811137;
        bh=4ACLzxXGGweNd17xot1i13hZHjJRXVj1UnMpZx67kak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7wKvPptjPa/Sgq+yXSJr4UQAkB6EX6pTmPCLfq/+w15vIePFcDbL9Kw0wmk4blUc
         aIjva81biF7VktIBqBx+6aUwNMGGsMZT1izMR24qAsSvtLh8HK78+L2fWCorO3mOD1
         VM8YdIUb8VZ5OMwQ3+PbbrU/CE5NKKqjBp6mrcbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 088/101] KVM: selftests: disable stack protector for all KVM tests
Date:   Thu,  2 May 2019 17:21:30 +0200
Message-Id: <20190502143345.751297735@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ffac839d040619847217647434b2b02469926871 ]

Since 4.8.3, gcc has enabled -fstack-protector by default.  This is
problematic for the KVM selftests as they do not configure fs or gs
segments (the stack canary is pulled from fs:0x28).  With the default
behavior, gcc will insert a stack canary on any function that creates
buffers of 8 bytes or more.  As a result, ucall() will hit a triple
fault shutdown due to reading a bad fs segment when inserting its
stack canary, i.e. every test fails with an unexpected SHUTDOWN.

Fixes: 14c47b7530e2d ("kvm: selftests: introduce ucall")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 tools/testing/selftests/kvm/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 212b8f0032ae..cb4a992d6dd3 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -28,8 +28,8 @@ LIBKVM += $(LIBKVM_$(UNAME_M))
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
-CFLAGS += -O2 -g -std=gnu99 -no-pie -I$(LINUX_TOOL_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(UNAME_M) -I..
-LDFLAGS += -pthread
+CFLAGS += -O2 -g -std=gnu99 -fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(UNAME_M) -I..
+LDFLAGS += -pthread -no-pie
 
 # After inclusion, $(OUTPUT) is defined and
 # $(TEST_GEN_PROGS) starts with $(OUTPUT)/
-- 
2.19.1



