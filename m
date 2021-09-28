Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A32D41A800
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbhI1GAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239092AbhI1F73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DF5C61371;
        Tue, 28 Sep 2021 05:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808616;
        bh=ngnFhTU/JETqR764UoXSOx79JXyoqcpvWMouzvqyaTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkB3tmP7rV8ukbS7lECWAZgDg5bgrmLYK0R+3BzaOm15Da67QodTGg90ZkNhZ5bGQ
         MyVwzxOeLAkDaH9PQnbXiVNyAET6TA1RehzZDyIlIoRSAhnzpBCRKHX0UNx1F4VOrD
         RuSIkUAMjpgzqYFlfP5L2Pb7D+Hj8098KT+3LDQqpSv+xl414pxJJsGY2iDCYxIGYy
         0dVRiocpHVNPygjniUZKi0T3jOkwCJAMZkrdl158cMpovKm53E4/rk3JNdvfArmrz7
         uOzeO3nBpvKc9XK1PcEU5qdsq5SgcbcYNrQTjJoCD3qJ+/vWsHc9Vv3+Ey01RhrSo7
         yD/Kww5AdjDtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhijian <lizhijian@cn.fujitsu.com>,
        Philip Li <philip.li@intel.com>,
        kernel test robot <lkp@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/23] selftests: be sure to make khdr before other targets
Date:   Tue, 28 Sep 2021 01:56:36 -0400
Message-Id: <20210928055645.172544-15-sashal@kernel.org>
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
index 0af84ad48aa7..b7217b5251f5 100644
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

