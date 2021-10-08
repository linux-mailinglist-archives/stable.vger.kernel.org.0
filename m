Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F1F426984
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241148AbhJHLjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242675AbhJHLgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:36:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6929161261;
        Fri,  8 Oct 2021 11:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692738;
        bh=xrMAs+IPKkLz+WhNBr+/uWnEYjVSKPnqoj2nhShfunE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6OQbj1IFHqFGbUx2pDzFQJ5voc8ASfRl7KAkRlyrhtYHKGHQ3lbYCGEoBRSVA8HP
         5KOTV9eADLB0PGKSfKs1UsNTK5xhGDjPDQJ1rw0Nc+R0QTOklSkj1p+2fnHp6KWxaj
         oVTb1NW5GCRolGWUVIusN8mGHtLMnwJz2asA5jSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Li <philip.li@intel.com>,
        kernel test robot <lkp@intel.com>,
        Li Zhijian <lizhijian@cn.fujitsu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 22/48] selftests: be sure to make khdr before other targets
Date:   Fri,  8 Oct 2021 13:27:58 +0200
Message-Id: <20211008112720.761322114@linuxfoundation.org>
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

From: Li Zhijian <lizhijian@cn.fujitsu.com>

[ Upstream commit 8914a7a247e065438a0ec86a58c1c359223d2c9e ]

LKP/0Day reported some building errors about kvm, and errors message
are not always same:
- lib/x86_64/processor.c:1083:31: error: ‘KVM_CAP_NESTED_STATE’ undeclared
(first use in this function); did you mean ‘KVM_CAP_PIT_STATE2’?
- lib/test_util.c:189:30: error: ‘MAP_HUGE_16KB’ undeclared (first use
in this function); did you mean ‘MAP_HUGE_16GB’?

Although kvm relies on the khdr, they still be built in parallel when -j
is specified. In this case, it will cause compiling errors.

Here we mark target khdr as NOTPARALLEL to make it be always built
first.

CC: Philip Li <philip.li@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index fa2ac0e56b43..fe7ee2b0f29c 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -48,6 +48,7 @@ ARCH		?= $(SUBARCH)
 # When local build is done, headers are installed in the default
 # INSTALL_HDR_PATH usr/include.
 .PHONY: khdr
+.NOTPARALLEL:
 khdr:
 ifndef KSFT_KHDR_INSTALL_DONE
 ifeq (1,$(DEFAULT_INSTALL_HDR_PATH))
-- 
2.33.0



