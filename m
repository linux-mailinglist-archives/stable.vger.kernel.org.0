Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1CD5F2B07
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiJCHqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbiJCHoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:44:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530D7578BC;
        Mon,  3 Oct 2022 00:25:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 041D0B80E6A;
        Mon,  3 Oct 2022 07:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5912FC433D7;
        Mon,  3 Oct 2022 07:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781394;
        bh=Q2DSGgW3V97mUVZbM74pZ1v1QXO/1Mv1ZjONQCfoQp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l01XHjcZSpDhHFTkyGUnTR1s1ubNPGMPXZm47+m/vrH3iYSwkdEUe5MmAf8UJ+2ve
         44WLXqlGJ1+WIel5EBSQ9oSQiQVcD8arAU3p6cSZKR4erzOZlcD8pSsSvHKIgLZXuQ
         nbnoXDoTqDdO8R46/fMtiYSUtP745CD5JJAVXBnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 083/101] selftests: Fix the if conditions of in test_extra_filter()
Date:   Mon,  3 Oct 2022 09:11:19 +0200
Message-Id: <20221003070726.517168159@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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
index 072d709c96b4..65aea27d761c 100644
--- a/tools/testing/selftests/net/reuseport_bpf.c
+++ b/tools/testing/selftests/net/reuseport_bpf.c
@@ -328,7 +328,7 @@ static void test_extra_filter(const struct test_params p)
 	if (bind(fd1, addr, sockaddr_size()))
 		error(1, errno, "failed to bind recv socket 1");
 
-	if (!bind(fd2, addr, sockaddr_size()) && errno != EADDRINUSE)
+	if (!bind(fd2, addr, sockaddr_size()) || errno != EADDRINUSE)
 		error(1, errno, "bind socket 2 should fail with EADDRINUSE");
 
 	free(addr);
-- 
2.35.1



