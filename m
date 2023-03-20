Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3116C185D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjCTPXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbjCTPXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:23:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B129430EB6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30E40B80EAB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED17C4339B;
        Mon, 20 Mar 2023 15:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325377;
        bh=P4g2CFNdNBvNCMX+K3IV+XVBx8fsIMEksaiICuvU72M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCvo3yoCWN2GCMwjHfkWWp8UkoJH/1Y++mG4x9Sp5CR/Wy0JKJ1xF891hTDdoBcwj
         1YKFzsSyNk8jIbVOchGgCnN2z0pJ/uz2ZkxegLXivc9/wU1gmUFF/Tb5HsTClq803O
         0DkonQf4yPYXcKPDc5Wsb9h+DNvUny3GQE4j5cTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 037/211] selftests: fix LLVM build for i386 and x86_64
Date:   Mon, 20 Mar 2023 15:52:52 +0100
Message-Id: <20230320145514.789801291@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

From: Guillaume Tucker <guillaume.tucker@collabora.com>

[ Upstream commit 624c60f326c6e5a80b008e8a5c7feffe8c27dc72 ]

Add missing cases for the i386 and x86_64 architectures when
determining the LLVM target for building kselftest.

Fixes: 795285ef2425 ("selftests: Fix clang cross compilation")
Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index f7900e75d2306..05400462c7799 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -10,12 +10,14 @@ endif
 CLANG_TARGET_FLAGS_arm          := arm-linux-gnueabi
 CLANG_TARGET_FLAGS_arm64        := aarch64-linux-gnu
 CLANG_TARGET_FLAGS_hexagon      := hexagon-linux-musl
+CLANG_TARGET_FLAGS_i386         := i386-linux-gnu
 CLANG_TARGET_FLAGS_m68k         := m68k-linux-gnu
 CLANG_TARGET_FLAGS_mips         := mipsel-linux-gnu
 CLANG_TARGET_FLAGS_powerpc      := powerpc64le-linux-gnu
 CLANG_TARGET_FLAGS_riscv        := riscv64-linux-gnu
 CLANG_TARGET_FLAGS_s390         := s390x-linux-gnu
 CLANG_TARGET_FLAGS_x86          := x86_64-linux-gnu
+CLANG_TARGET_FLAGS_x86_64       := x86_64-linux-gnu
 CLANG_TARGET_FLAGS              := $(CLANG_TARGET_FLAGS_$(ARCH))
 
 ifeq ($(CROSS_COMPILE),)
-- 
2.39.2



