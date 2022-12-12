Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCAD64A014
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiLLNTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiLLNTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:19:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8184813E08
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:18:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32BCDB80D3B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACB9C433EF;
        Mon, 12 Dec 2022 13:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851117;
        bh=f+80fOIkJwd1arNU1RYevW9pjotKASW0lwpD7vH/N7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SObX/8KaP8dlDpC7haziug4Byd+S1mU+6ql4CKc1zPubBmVxU3ytsPrNh9CCLTLaV
         54sPfHYruAnNJT/EecEmqoZomRpub/S6epCMMSOuIerswz3UjFJde12GxvBXQkVBLT
         OI8Kqh/FgQ3O4yh/A4FMDgvDux6PFwzODsQiMems=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/106] selftests: rtnetlink: correct xfrm policy rule in kci_test_ipsec_offload
Date:   Mon, 12 Dec 2022 14:10:22 +0100
Message-Id: <20221212130928.323621981@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 85a0506c073332a3057f5a9635fa0d4db5a8e03b ]

When testing in kci_test_ipsec_offload, srcip is configured as $dstip,
it should add xfrm policy rule in instead of out.
The test result of this patch is as follows:
PASS: ipsec_offload

Fixes: 2766a11161cc ("selftests: rtnetlink: add ipsec offload API test")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20221201082246.14131-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/rtnetlink.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index c9ce3dfa42ee..c3a905923ef2 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -782,7 +782,7 @@ kci_test_ipsec_offload()
 	    tmpl proto esp src $srcip dst $dstip spi 9 \
 	    mode transport reqid 42
 	check_err $?
-	ip x p add dir out src $dstip/24 dst $srcip/24 \
+	ip x p add dir in src $dstip/24 dst $srcip/24 \
 	    tmpl proto esp src $dstip dst $srcip spi 9 \
 	    mode transport reqid 42
 	check_err $?
-- 
2.35.1



