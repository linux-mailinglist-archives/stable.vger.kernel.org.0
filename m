Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664C64F2609
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbiDEHyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiDEHxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:53:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976E01DA44;
        Tue,  5 Apr 2022 00:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DC22B81B98;
        Tue,  5 Apr 2022 07:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B344C340EE;
        Tue,  5 Apr 2022 07:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144934;
        bh=YieYlB7YlBu+iFUivAZxGhvRELcFenEmof40d3ij6O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOKa6TIDm70CrGyfkixVe8GQVjt3D5LT4YcA+75CB2ZrKujLJE1fofM4ljYb8ILTu
         E2FfTbCiRl8hjQDcM7K5bC7VyY2OeDHTjMlHNvEqnrw1v/TJuXX1qrdy1tRsQmv6El
         fkdRQ+fccHAKEUyn4hvn+J/eEDVGXaF6cQooFHAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0225/1126] selftests/sgx: Treat CC as one argument
Date:   Tue,  5 Apr 2022 09:16:12 +0200
Message-Id: <20220405070414.213103155@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 2956584e1e37..75af864e07b6 100644
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



