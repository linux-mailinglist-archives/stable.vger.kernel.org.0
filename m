Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6DC4F35CD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbiDEKzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344743AbiDEJmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:42:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842C6BF009;
        Tue,  5 Apr 2022 02:28:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21DC361659;
        Tue,  5 Apr 2022 09:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE93C385A2;
        Tue,  5 Apr 2022 09:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150880;
        bh=DaKU9tzGBNC8vhMrAakJ4TImi/mLVIJ8Z1GA0IsQzmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4iUu7H2UIZS6hZ76uynBSagWAMmeuBrVLZWcqAtnmy72w4uwGDPqdgkUof01Ads8
         UoXO9gITXPHBxmumVyTUzaqV1/0foAF+aOSJWxqphISZcMhlbnCDVxwPXH4YgTiAda
         /JmGkZdYgjryMADHZXnCxFRuYMxwkbkJAfgUclhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/913] selftests/sgx: Treat CC as one argument
Date:   Tue,  5 Apr 2022 09:21:09 +0200
Message-Id: <20220405070346.063840285@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit 6170abb21e2380477080b25145da9747ad467d3d ]

CC can have multiple sub-strings like "ccache gcc". For check_cc.sh,
CC needs to be treated like one argument. Put double quotes around it to
make CC one string and hence one argument.

Fixes: 2adcba79e69d ("selftests/x86: Add a selftest for SGX")
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lkml.kernel.org/r/20220214184109.3739179-3-usama.anjum@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
index 7f12d55b97f8..472b27ccd7dc 100644
--- a/tools/testing/selftests/sgx/Makefile
+++ b/tools/testing/selftests/sgx/Makefile
@@ -4,7 +4,7 @@ include ../lib.mk
 
 .PHONY: all clean
 
-CAN_BUILD_X86_64 := $(shell ../x86/check_cc.sh $(CC) \
+CAN_BUILD_X86_64 := $(shell ../x86/check_cc.sh "$(CC)" \
 			    ../x86/trivial_64bit_program.c)
 
 ifndef OBJCOPY
-- 
2.34.1



