Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9A7635655
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237818AbiKWJaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237658AbiKWJag (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:30:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EB2112C53
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:28:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFFC7B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6D9C433C1;
        Wed, 23 Nov 2022 09:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195728;
        bh=5rig4E0gWQ2552DDEVY5T99PzN2A0F32cShy/T8DvYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2M0Cc1J2oiXYaFXsjrbr3+4YLHdPyKtrOh/hf5K6nuXxwoXcy+lkifdPC7OvHSSwJ
         0IeJGTWEENsw6RS9WIfqIZmUXLlNE5I2bcsHs5UeuGwjMpveQhpvozCSMypjPd2ebx
         RnSOYY5dHacRM5AwmnuYg9gEMruEKPZABUkbXGus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/181] selftests/intel_pstate: fix build for ARCH=x86_64
Date:   Wed, 23 Nov 2022 09:49:40 +0100
Message-Id: <20221123084603.259809412@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit beb7d862ed4ac6aa14625418970f22a7d55b8615 ]

Handle the scenario where the build is launched with the ARCH envvar
defined as x86_64.

Signed-off-by: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/intel_pstate/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/intel_pstate/Makefile b/tools/testing/selftests/intel_pstate/Makefile
index 39f0fa2a8fd6..05d66ef50c97 100644
--- a/tools/testing/selftests/intel_pstate/Makefile
+++ b/tools/testing/selftests/intel_pstate/Makefile
@@ -2,10 +2,10 @@
 CFLAGS := $(CFLAGS) -Wall -D_GNU_SOURCE
 LDLIBS += -lm
 
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+ARCH_PROCESSED := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
-ifeq (x86,$(ARCH))
+ifeq (x86,$(ARCH_PROCESSED))
 TEST_GEN_FILES := msr aperf
 endif
 
-- 
2.35.1



