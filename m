Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A073D5012F2
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345863AbiDNNyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345125AbiDNNpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:45:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922725FFB;
        Thu, 14 Apr 2022 06:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E5E0CE29B0;
        Thu, 14 Apr 2022 13:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15940C385A1;
        Thu, 14 Apr 2022 13:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943760;
        bh=ffsS/x+Hp3UTeuQC96zgTgsG4G+Laxov6WtZwS7N87o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWaDBHrTlRD5ywE0UfzeJHuwHW5V1c+h2H204oJ3Vs2iV+6+P7D8JDVwzW6DgeGEY
         SwdD/LWlGXGs7ypkbAbuqoaL9ZR5MsfE6pAcEz+A79J7d643pYwxFH9thre7RBakNb
         EmYsCS26WDf6/4lebANPLOU+vZvsclHtp1QEdcS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 272/475] lib/test: use after free in register_test_dev_kmod()
Date:   Thu, 14 Apr 2022 15:10:57 +0200
Message-Id: <20220414110902.717674632@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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



