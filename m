Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABEF4F2CC9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244869AbiDEJLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244666AbiDEIwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E400262B;
        Tue,  5 Apr 2022 01:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEC4B60FFB;
        Tue,  5 Apr 2022 08:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8359C385A0;
        Tue,  5 Apr 2022 08:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148108;
        bh=DaKU9tzGBNC8vhMrAakJ4TImi/mLVIJ8Z1GA0IsQzmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYP55RF47NXaevtVfFjQpv9OXSQsyDPfXcjLy3VAVU2uaZLv5ND33/oYkhlcYjMPb
         wcLGv6nCMkjZHhX4+37Iik6suzv+BY8sXh9+2W9hc7vHsZAZqMcDO9TNUB8WwxGoH7
         hk2gYInFBGuxg1Er+COgmSVySx5n3JFy/yLDHkMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0220/1017] selftests/sgx: Treat CC as one argument
Date:   Tue,  5 Apr 2022 09:18:53 +0200
Message-Id: <20220405070400.781660623@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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



