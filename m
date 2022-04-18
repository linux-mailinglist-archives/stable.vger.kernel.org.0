Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5943B50563A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242432AbiDRNct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244713AbiDRNat (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA30E0FE;
        Mon, 18 Apr 2022 05:55:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13ED160FE8;
        Mon, 18 Apr 2022 12:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192E8C385A7;
        Mon, 18 Apr 2022 12:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286502;
        bh=ArEFoaSFryx8GdalJQBJX+zoEu1WRX8cLaTmZZD7D+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRZ8dSVWG2J6chj9ksHThBrsAU6PgejwaobxZOuOfnOWROyqfeSljSOqGDyh5h8ci
         BDUM6ZcyEHLBNb3SNI10VCeLc5ssqS1fgp8sE9pzeLZmvvz5Cc34Nt23388tUKClMJ
         rodIoDXPJvfVyQ2v99zLhuQXZYe6ZH4s2oro3CXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 154/284] lib/test: use after free in register_test_dev_kmod()
Date:   Mon, 18 Apr 2022 14:12:15 +0200
Message-Id: <20220418121216.079476391@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index c0ce0156d54b..74f8d386f85e 100644
--- a/lib/test_kmod.c
+++ b/lib/test_kmod.c
@@ -1162,6 +1162,7 @@ static struct kmod_test_device *register_test_dev_kmod(void)
 	if (ret) {
 		pr_err("could not register misc device: %d\n", ret);
 		free_test_dev_kmod(test_dev);
+		test_dev = NULL;
 		goto out;
 	}
 
-- 
2.34.1



