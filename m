Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F504F2627
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbiDEHy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbiDEHyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:54:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9459529828;
        Tue,  5 Apr 2022 00:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31124615E7;
        Tue,  5 Apr 2022 07:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424EAC340EE;
        Tue,  5 Apr 2022 07:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144991;
        bh=H8uda6V1HheIjakja9+wxpTEmKta/xlolmoBqP/AHk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bC+IP6HKd1MuowyCUoEzf8W8Efsb7XhLTUyrt7JMmbnDLb6ODfQuQz6lyegloHBOg
         taitcScyPoSguDbgesTIfU03DKaGC87egqJFVSlsPfpy8X1mug2zXn56mrfPQa0N2k
         4NzAcZeKYoNzGJBbUiNjXgjtsegmW7PUTM6IMwho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0218/1126] selftests/sgx: Ensure enclave data available during debug print
Date:   Tue,  5 Apr 2022 09:16:05 +0200
Message-Id: <20220405070414.008927047@linuxfoundation.org>
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

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 2db703fc3b15e7ef68c82eca613a3c00d43d70af ]

In support of debugging the SGX tests print details from
the enclave and its memory mappings if any failure is encountered
during enclave loading.

When a failure is encountered no data is printed because the
printing of the data is preceded by cleanup of the data.

Move the data cleanup after the data print.

Fixes: 147172148909 ("selftests/sgx: Dump segments and /proc/self/maps only on failure")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lkml.kernel.org/r/dab672f771e9b99e50c17ae2a75dc0b020cb0ce9.1644355600.git.reinette.chatre@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index a7cd2c3e6f7e..b0bd95a4730d 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -186,8 +186,6 @@ static bool setup_test_encl(unsigned long heap_size, struct encl *encl,
 	return true;
 
 err:
-	encl_delete(encl);
-
 	for (i = 0; i < encl->nr_segments; i++) {
 		seg = &encl->segment_tbl[i];
 
@@ -208,6 +206,8 @@ static bool setup_test_encl(unsigned long heap_size, struct encl *encl,
 
 	TH_LOG("Failed to initialize the test enclave.\n");
 
+	encl_delete(encl);
+
 	return false;
 }
 
-- 
2.34.1



