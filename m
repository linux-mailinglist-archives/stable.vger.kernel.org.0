Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A5D426917
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241730AbhJHLeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241259AbhJHLcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4008B61183;
        Fri,  8 Oct 2021 11:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692634;
        bh=ou2OW1kzAIvfu0JproD4nOzVQJ6oIX7/QxecRwcAUt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UudbnpFkA8XAdvU+QspTzXg+z4i8q6JrBt7rA8jDxvox/E7UqpWXsev2KoKtisNnj
         QC9yVNKrhYfksgQyYZ/niwPvjSDGG3z62hpyQ7xEUw1m1z33eiPCRNoXjYBHU4N/5F
         MmcSEz+DuLBPOd/tXWbMeM/6kdM7UJry71xdTVqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Li <philip.li@intel.com>,
        kernel test robot <lkp@intel.com>,
        Li Zhijian <lizhijian@cn.fujitsu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/16] selftests: be sure to make khdr before other targets
Date:   Fri,  8 Oct 2021 13:27:58 +0200
Message-Id: <20211008112715.739860315@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
References: <20211008112715.444305067@linuxfoundation.org>
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
index 67386aa3f31d..8794ce382bf5 100644
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



