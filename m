Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1ED657D6F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbiL1PnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiL1PnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:43:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B46417043
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C34A0B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D39FC433F0;
        Wed, 28 Dec 2022 15:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242188;
        bh=KzbOqu0S9jUEVPFhOZpxJcEZDgSm+A3Hd0Wzrm6/Wl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tH6fX9V7GOoJ6fJMwuZY5e2A0fUy3SAuuommvP5upr6Rb6xiF2q4jn0YPA+C1a4Yi
         01Icr/xhLI4Hk3clkHZH4K2s1Qe0nafbFXU+0BOoJUrxlKzWirxAVx3Q7TqEMCD/QT
         aFAjGnK6DQ1rq/+HAQ04am3quMupj1aon3dKlQmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0339/1146] ima: Fix misuse of dereference of pointer in template_desc_init_fields()
Date:   Wed, 28 Dec 2022 15:31:18 +0100
Message-Id: <20221228144339.365667520@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 25369175ce84813dd99d6604e710dc2491f68523 ]

The input parameter @fields is type of struct ima_template_field ***, so
when allocates array memory for @fields, the size of element should be
sizeof(**field) instead of sizeof(*field).

Actually the original code would not cause any runtime error, but it's
better to make it logically right.

Fixes: adf53a778a0a ("ima: new templates management mechanism")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_template.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index c25079faa208..195ac18f0927 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -245,11 +245,11 @@ int template_desc_init_fields(const char *template_fmt,
 	}
 
 	if (fields && num_fields) {
-		*fields = kmalloc_array(i, sizeof(*fields), GFP_KERNEL);
+		*fields = kmalloc_array(i, sizeof(**fields), GFP_KERNEL);
 		if (*fields == NULL)
 			return -ENOMEM;
 
-		memcpy(*fields, found_fields, i * sizeof(*fields));
+		memcpy(*fields, found_fields, i * sizeof(**fields));
 		*num_fields = i;
 	}
 
-- 
2.35.1



