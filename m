Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C145F2B0F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiJCHrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbiJCHpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:45:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0CD57566;
        Mon,  3 Oct 2022 00:26:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4710B60FAA;
        Mon,  3 Oct 2022 07:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D2CC433C1;
        Mon,  3 Oct 2022 07:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781855;
        bh=HzWNp5YyPkS2fPfnmk/Ug6wOXveeiRA34eO/DWm4nXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wu1ihjTw2jz6m2mV2weVlkjYN5wnnpkMtbwPWH6qHx8DHKcSJmVJQygnZoevASXhy
         gKIVFKpNj712lLPc9LgzFBwXDJmfLmg9GTvP+sU+frMEN/liaWa8v8+knKgowVDwW4
         pgSG1s0gQtyzMJE2yfToJH/2g0omNoHU8vJB4drM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/30] selftests: Fix the if conditions of in test_extra_filter()
Date:   Mon,  3 Oct 2022 09:12:10 +0200
Message-Id: <20221003070717.161179231@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
References: <20221003070716.269502440@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit bc7a319844891746135dc1f34ab9df78d636a3ac ]

The socket 2 bind the addr in use, bind should fail with EADDRINUSE. So
if bind success or errno != EADDRINUSE, testcase should be failed.

Fixes: 3ca8e4029969 ("soreuseport: BPF selection functional test")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/r/1663916557-10730-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/reuseport_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/reuseport_bpf.c b/tools/testing/selftests/net/reuseport_bpf.c
index b5277106df1f..b0cc082fbb84 100644
--- a/tools/testing/selftests/net/reuseport_bpf.c
+++ b/tools/testing/selftests/net/reuseport_bpf.c
@@ -330,7 +330,7 @@ static void test_extra_filter(const struct test_params p)
 	if (bind(fd1, addr, sockaddr_size()))
 		error(1, errno, "failed to bind recv socket 1");
 
-	if (!bind(fd2, addr, sockaddr_size()) && errno != EADDRINUSE)
+	if (!bind(fd2, addr, sockaddr_size()) || errno != EADDRINUSE)
 		error(1, errno, "bind socket 2 should fail with EADDRINUSE");
 
 	free(addr);
-- 
2.35.1



