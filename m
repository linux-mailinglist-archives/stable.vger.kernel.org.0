Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B23F4F27F9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiDEIJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235571AbiDEH7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784F040A19;
        Tue,  5 Apr 2022 00:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1541D615CD;
        Tue,  5 Apr 2022 07:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA03C340EE;
        Tue,  5 Apr 2022 07:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145336;
        bh=nIPnSGOQ2e/NQ2OK6jruFrUnda7HrbHSyCuSBx/dLX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCoDM4U7gYWMXGnO0Bbme+ou1XxRwi13FLWHhgmV9ljU2ijaX3TkcXpQqp2zWiPSe
         29bNcIhkhtsfk6zUQyBMiCCo80+8svCFG1jjECqzamT3QpPL3xioleRd6kibclS8SB
         qdxuNzpxyPLVHuAqHuy5XAvPvLFxnHZTMUt7QrFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Alistair Popple <apopple@nvidia.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0368/1126] selftests: vm: remove dependecy from internal kernel macros
Date:   Tue,  5 Apr 2022 09:18:35 +0200
Message-Id: <20220405070418.428636199@linuxfoundation.org>
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

[ Upstream commit 681696862bc1823595c05960a83766d1aa965c17 ]

The defination of swap() is used from kernel's internal header when this
test is built in source tree. The build fails when this test is built
out of source tree as defination of swap() isn't found. Selftests
shouldn't depend on kernel's internal header files. They can only depend
on uapi header files. Add the defination of swap() to fix the build
error:

	gcc -Wall  -I/linux_mainline2/build/usr/include -no-pie    userfaultfd.c -lrt -lpthread -o /linux_mainline2/build/kselftest/vm/userfaultfd
	userfaultfd.c: In function ‘userfaultfd_stress’:
	userfaultfd.c:1530:3: warning: implicit declaration of function ‘swap’; did you mean ‘swab’? [-Wimplicit-function-declaration]
	 1530 |   swap(area_src, area_dst);
	      |   ^~~~
	      |   swab
	/usr/bin/ld: /tmp/cclUUH7V.o: in function `userfaultfd_stress':
	userfaultfd.c:(.text+0x4d64): undefined reference to `swap'
	/usr/bin/ld: userfaultfd.c:(.text+0x4d82): undefined reference to `swap'
	collect2: error: ld returned 1 exit status

Fixes: 2c769ed7137a ("tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/userfaultfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 3fc1d2ee2948..c964bfe9fbcd 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -120,6 +120,9 @@ struct uffd_stats {
 				 ~(unsigned long)(sizeof(unsigned long long) \
 						  -  1)))
 
+#define swap(a, b) \
+	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+
 const char *examples =
     "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
     "./userfaultfd anon 100 99999\n\n"
-- 
2.34.1



