Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2ED59416F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbiHOVMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243585AbiHOVKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:10:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27315509F;
        Mon, 15 Aug 2022 12:18:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 126E1B81120;
        Mon, 15 Aug 2022 19:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625B7C433C1;
        Mon, 15 Aug 2022 19:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591136;
        bh=zo472JXDZC4ztxKvqyyytsSeGVG+XJDGa+4eATKg5Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rclxg+/wJferl0senWSDyT4tmR0r4yXs8eVFPi44i7UZ/7hh43HRcMioXKGOTPTEl
         WSIfyHnMeh0wEuB7FfM+Ad8qRkVnN1FlYvsRIBdH/euniQvmkrySOCnlplefux8PNL
         f9sA52ltqI2Wky60QXfNdVsH7XD6VkNqg5F0jx+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0483/1095] selftests/bpf: fix a test for snprintf() overflow
Date:   Mon, 15 Aug 2022 19:58:02 +0200
Message-Id: <20220815180449.544839968@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c5d22f4cfe8dfb93f1db0a1e7e2e7ebc41395d98 ]

The snprintf() function returns the number of bytes which *would*
have been copied if there were space.  In other words, it can be
> sizeof(pin_path).

Fixes: c0fa1b6c3efc ("bpf: btf: Add BTF tests")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/r/YtZ+aD/tZMkgOUw+@kili
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index ec823561b912..a294176f8a9d 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -5226,7 +5226,7 @@ static void do_test_pprint(int test_num)
 	ret = snprintf(pin_path, sizeof(pin_path), "%s/%s",
 		       "/sys/fs/bpf", test->map_name);
 
-	if (CHECK(ret == sizeof(pin_path), "pin_path %s/%s is too long",
+	if (CHECK(ret >= sizeof(pin_path), "pin_path %s/%s is too long",
 		  "/sys/fs/bpf", test->map_name)) {
 		err = -1;
 		goto done;
-- 
2.35.1



