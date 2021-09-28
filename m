Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4469B41A79B
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbhI1F6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239108AbhI1F6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 213336127A;
        Tue, 28 Sep 2021 05:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808573;
        bh=xrMAs+IPKkLz+WhNBr+/uWnEYjVSKPnqoj2nhShfunE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cemAvYs090T6zr3rCLcZmJjkY7eUKclTUrRD8UssQutinH+LXDtnjRYwBXCzfS0lB
         S25mftrS+gLTm0frUqcO/h+vlxTct7liQzF4g1Qs/lXEuxanZGuF8cnwbg0lxAx6ts
         6t/4sQBHdQgxGFnX6KUaauyP6mI8dqEMY9xDU4Mn0o4ksPySW+kOvFpygWgWam5GrS
         0dlhc36cFdvQ6UYsnRutLISU45ocrOetI5pN1G3IKxjhstSvjZS9tyZDRCuju1551L
         SCWlxee97u6WhXYipUv5LDwwj+vxPm57Ak55FphrNzOdisMHfHefZNBmcM+7mipusS
         Bt1wvJ9/XT6Cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhijian <lizhijian@cn.fujitsu.com>,
        Philip Li <philip.li@intel.com>,
        kernel test robot <lkp@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 23/40] selftests: be sure to make khdr before other targets
Date:   Tue, 28 Sep 2021 01:55:07 -0400
Message-Id: <20210928055524.172051-23-sashal@kernel.org>
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

