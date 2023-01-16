Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF9066CCB9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbjAPR3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234801AbjAPR2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:28:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5063864A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:05:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B81161085
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC98C433EF;
        Mon, 16 Jan 2023 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888731;
        bh=7PL/U7m48sSDKl73aetmCMW3NnucifAm2enbroza2Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKD1BL6XX+MPx8k4NzzFttL9F6NfqwJ1Bdp6HuIYT1YnwcVlI9ivGdPu/fozFY2Sv
         tUz61OhKEQdZ8AFhrZvupViSOPOe2PkPNwyEMDbJtLjmUM/yKPFtjRpsu6RTVNzYcZ
         W+m7gAR8e2XaVf6az2j53g9STPHglXgh2PNNDe9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 076/338] ima: Fix misuse of dereference of pointer in template_desc_init_fields()
Date:   Mon, 16 Jan 2023 16:49:09 +0100
Message-Id: <20230116154824.199851460@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index 8687882277a1..ff49f9292931 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -196,11 +196,11 @@ static int template_desc_init_fields(const char *template_fmt,
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



