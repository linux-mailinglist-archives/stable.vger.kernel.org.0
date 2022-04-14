Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FBF50110C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240229AbiDNNhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245521AbiDNN3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:29:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA67DAD115;
        Thu, 14 Apr 2022 06:23:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74ECFB82910;
        Thu, 14 Apr 2022 13:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF090C385AC;
        Thu, 14 Apr 2022 13:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942584;
        bh=ffsS/x+Hp3UTeuQC96zgTgsG4G+Laxov6WtZwS7N87o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xKbgoeyFYbG4aOSP47uaa3NIQXDGTw+z5QphX26bxVQq6pF67kNkPCauLLO7ynjA
         eBbLdTsdv2m7OUQDMe91SNrCLJgtGHdXpSuq0oQdbNYWMbnQEsoNXJ7aIsAlJPkx7k
         7Wr2jMPUQEZ0a32+pXxU4tWvTahqU+feuvKntXn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 187/338] lib/test: use after free in register_test_dev_kmod()
Date:   Thu, 14 Apr 2022 15:11:30 +0200
Message-Id: <20220414110844.220307654@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit dc0ce6cc4b133f5f2beb8b47dacae13a7d283c2c ]

The "test_dev" pointer is freed but then returned to the caller.

Fixes: d9c6a72d6fa2 ("kmod: add test driver to stress test the module loader")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_kmod.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/test_kmod.c b/lib/test_kmod.c
index 87a0cc750ea2..6813b183aa34 100644
--- a/lib/test_kmod.c
+++ b/lib/test_kmod.c
@@ -1155,6 +1155,7 @@ static struct kmod_test_device *register_test_dev_kmod(void)
 	if (ret) {
 		pr_err("could not register misc device: %d\n", ret);
 		free_test_dev_kmod(test_dev);
+		test_dev = NULL;
 		goto out;
 	}
 
-- 
2.34.1



