Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19B034CA39
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhC2Ifz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233938AbhC2Ie1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:34:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F16A6196E;
        Mon, 29 Mar 2021 08:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006866;
        bh=VmcGbA1/O5Oasqt+SD5cP8LTH5dJT6oFG0I36E9xXhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUvenv0XMCJQda4ZyzZaO+Sg8hUYPuQ2HdwCBNSbFLeQYs44eZka4mCOJzCaohzex
         qwp/YyuuRUT6cTfXq4jjlF3Ved6CrXI38/eS0zGWfMJRICcPa3IpDtFCYcYLrQerC7
         tVFsGiTxI5sMap3gCUF5GxH2SjNqUMgkVwK9vZ6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 131/254] kunit: tool: Disable PAGE_POISONING under --alltests
Date:   Mon, 29 Mar 2021 09:57:27 +0200
Message-Id: <20210329075637.530027341@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit 7fd53f41f771d250eb08db08650940f017e37c26 ]

kunit_tool maintains a list of config options which are broken under
UML, which we exclude from an otherwise 'make ARCH=um allyesconfig'
build used to run all tests with the --alltests option.

Something in UML allyesconfig is causing segfaults when page poisining
is enabled (and is poisoning with a non-zero value). Previously, this
didn't occur, as allyesconfig enabled the CONFIG_PAGE_POISONING_ZERO
option, which worked around the problem by zeroing memory. This option
has since been removed, and memory is now poisoned with 0xAA, which
triggers segfaults in many different codepaths, preventing UML from
booting.

Note that we have to disable both CONFIG_PAGE_POISONING and
CONFIG_DEBUG_PAGEALLOC, as the latter will 'select' the former on
architectures (such as UML) which don't implement __kernel_map_pages().

Ideally, we'd fix this properly by tracking down the real root cause,
but since this is breaking KUnit's --alltests feature, it's worth
disabling there in the meantime so the kernel can boot to the point
where tests can actually run.

Fixes: f289041ed4cf ("mm, page_poison: remove CONFIG_PAGE_POISONING_ZERO")
Signed-off-by: David Gow <davidgow@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/configs/broken_on_uml.config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/kunit/configs/broken_on_uml.config b/tools/testing/kunit/configs/broken_on_uml.config
index a7f0603d33f6..690870043ac0 100644
--- a/tools/testing/kunit/configs/broken_on_uml.config
+++ b/tools/testing/kunit/configs/broken_on_uml.config
@@ -40,3 +40,5 @@
 # CONFIG_RESET_BRCMSTB_RESCAL is not set
 # CONFIG_RESET_INTEL_GW is not set
 # CONFIG_ADI_AXI_ADC is not set
+# CONFIG_DEBUG_PAGEALLOC is not set
+# CONFIG_PAGE_POISONING is not set
-- 
2.30.1



