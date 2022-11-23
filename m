Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6BD635505
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbiKWJN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237239AbiKWJN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:13:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646F5106117
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 173FEB81EF1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DCAC433D7;
        Wed, 23 Nov 2022 09:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194833;
        bh=v8cGCJBDm0eZJLPzFSbLDbXewUjQNprW6ZfOK/nAJcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKqwln6lWI6mF6boqruXM9UhDrBkaRlAxOAPlMxTikRGDtPULjn8BZgt8QvSvdWj4
         WWrQhCyFs+bslR+8KtH8roSQRRDc8HQgRdMTIUNKGDR1pihbuYGWxhM7r9RNroigLa
         BWKHVQpcc07mso2WervclJDJ/PMCicyhaylcEs2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/156] selftests/intel_pstate: fix build for ARCH=x86_64
Date:   Wed, 23 Nov 2022 09:50:31 +0100
Message-Id: <20221123084600.686435421@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
index 7340fd6a9a9f..9fc1a40b0127 100644
--- a/tools/testing/selftests/intel_pstate/Makefile
+++ b/tools/testing/selftests/intel_pstate/Makefile
@@ -2,10 +2,10 @@
 CFLAGS := $(CFLAGS) -Wall -D_GNU_SOURCE
 LDLIBS := $(LDLIBS) -lm
 
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



