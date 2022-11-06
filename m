Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1B561E3D3
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiKFRFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiKFREm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:04:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FC0F5B6;
        Sun,  6 Nov 2022 09:04:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19DCDB80BFC;
        Sun,  6 Nov 2022 17:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E9BC433C1;
        Sun,  6 Nov 2022 17:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754267;
        bh=wJwWHA/6zk0F4kCPJYNjwAp1jUnmUfCkzw47JYfRCbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvGZN/pO9Is6HH9SFnspWffvYgtmaPqg4KSDWZLGBPokTPo8laW+EbFotw+c0l9Vw
         JDkLAr2ujpsQGZ05aDNxNrNYhi9OQ1lrDxFu0qrCt0ELXt5Z+FQRoqq+D52eBkLtsd
         HfBmdGSgt9eCH6S+xHq5blbJaGUbYmWW5745+MfDnyfzBtNgVW55XVyd+8StIf4hfl
         Vh4Qhblg8d8NQdB7xF4eySYC4iipO8u89fm8LJDX1aMOC/68z2z3zEiu/2vcDC81Nc
         wlOrISf/c8w4hPkf1MXiA6g+hnStDnI81XXhzwh+HYWBQUlmCy6WWwuh0ZnVlROMO1
         4a/+AHC80oLPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        nayna@linux.ibm.com, zohar@linux.ibm.com, rnsastry@linux.ibm.com,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 18/30] selftests/kexec: fix build for ARCH=x86_64
Date:   Sun,  6 Nov 2022 12:03:30 -0500
Message-Id: <20221106170345.1579893-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Cañuelo <ricardo.canuelo@collabora.com>

[ Upstream commit 2a8e366b23fea29a5308f71ba49555e3c8c664f1 ]

Handle the scenario where the build is launched with the ARCH envvar
defined as x86_64.

Signed-off-by: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kexec/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kexec/Makefile b/tools/testing/selftests/kexec/Makefile
index 806a150648c3..67fe7a46cb62 100644
--- a/tools/testing/selftests/kexec/Makefile
+++ b/tools/testing/selftests/kexec/Makefile
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # Makefile for kexec tests
 
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+ARCH_PROCESSED := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
-ifeq ($(ARCH),$(filter $(ARCH),x86 ppc64le))
+ifeq ($(ARCH_PROCESSED),$(filter $(ARCH_PROCESSED),x86 ppc64le))
 TEST_PROGS := test_kexec_load.sh test_kexec_file_load.sh
 TEST_FILES := kexec_common_lib.sh
 
-- 
2.35.1

