Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1360F6B42AD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjCJOFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjCJOFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:05:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9531175A0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:05:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BEFDB822C0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44F7C433D2;
        Fri, 10 Mar 2023 14:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457110;
        bh=WbRGxJjexTrn32/f2mfDDeqTxPCV2Mqvg6pvIbLkbbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmJyvt9Ol+R+z/OIGJBWcvEx2rmhituEJK0xcLflkL8XYRxF4Uoi/MEYQY64WPAqs
         pxGUuaKmRXo4UfurH2WVJFta2ZlTb7KxNNrBBSw1Dcwy0TwxMCW0tNeTuD2bR7Rft1
         Opqs2PqtcKitk+0b+z0H4JbY9MqzBZJHH8LklnGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiang Yang <xiangyang3@huawei.com>,
        Anton Ivanov <anton.ivanov@kot-begemot.co.uk>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/200] um: vector: Fix memory leak in vector_config
Date:   Fri, 10 Mar 2023 14:37:10 +0100
Message-Id: <20230310133717.756287422@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Yang <xiangyang3@huawei.com>

[ Upstream commit 8f88c73afe481f93d40801596927e8c0047b6d96 ]

If the return value of the uml_parse_vector_ifspec function is NULL,
we should call kfree(params) to prevent memory leak.

Fixes: 49da7e64f33e ("High Performance UML Vector Network Driver")
Signed-off-by: Xiang Yang <xiangyang3@huawei.com>
Acked-By: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/vector_kern.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index ded7c47d2fbe5..131b7cb295767 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -767,6 +767,7 @@ static int vector_config(char *str, char **error_out)
 
 	if (parsed == NULL) {
 		*error_out = "vector_config failed to parse parameters";
+		kfree(params);
 		return -EINVAL;
 	}
 
-- 
2.39.2



