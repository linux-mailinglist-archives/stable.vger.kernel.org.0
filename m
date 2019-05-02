Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA4B11DA7
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfEBPcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbfEBPcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E04C920C01;
        Thu,  2 May 2019 15:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811134;
        bh=OZ4c7QAWh0rxTtJ8GAIod4UGAirImXI2H1437/bD2Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lo0jKOmKDmibCJMS/xxeTSL1maA+bHbCMGASsqMRpaxTpn8lQerkpArKfLwj2nfSS
         2K9LEMriG4VeI3m0fSTa29QC6eudac80cHxwRJDOK+PoEV5AD7bOb8H3EOq3oDp72s
         0sYIOqkbKYkTYYyLXwmPKZiIWqhv9oLMBGWxOIKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 087/101] KVM: selftests: explicitly disable PIE for tests
Date:   Thu,  2 May 2019 17:21:29 +0200
Message-Id: <20190502143345.682698592@linuxfoundation.org>
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

[ Upstream commit 0a3f29b5a77d6c27796d7a7adabafd199dc066d5 ]

KVM selftests embed the guest "image" as a function in the test itself
and extract the guest code at runtime by manually parsing the elf
headers.  The parsing is very simple and doesn't supporting fancy things
like position independent executables.  Recent versions of gcc enable
pie by default, which results in triple fault shutdowns in the guest due
to the virtual address in the headers not matching up with the virtual
address retrieved from the function pointer.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 tools/testing/selftests/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f9a0e9938480..212b8f0032ae 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -28,7 +28,7 @@ LIBKVM += $(LIBKVM_$(UNAME_M))
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
-CFLAGS += -O2 -g -std=gnu99 -I$(LINUX_TOOL_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(UNAME_M) -I..
+CFLAGS += -O2 -g -std=gnu99 -no-pie -I$(LINUX_TOOL_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(UNAME_M) -I..
 LDFLAGS += -pthread
 
 # After inclusion, $(OUTPUT) is defined and
-- 
2.19.1



