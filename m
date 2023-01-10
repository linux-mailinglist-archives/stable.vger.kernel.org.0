Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290B6664A5F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbjAJScf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239352AbjAJScG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:32:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3765B493
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:27:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8224DB81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BBCC433D2;
        Tue, 10 Jan 2023 18:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375230;
        bh=jtBRg0qN1hf8VIQGcLgqzlTWHXsf1Orz0TBhX97ScsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDmo2HgBEfjiz/dSOvIH/eeSdC8AVUrQpQXQmE63TH3d+3wHJMzOXNlUlZVELIdFi
         nzKsE5zF1VvbJi09cwZLys0g2a7NejxMCmnDlnbwXg/jxkf+MurhC/zlbezgJU6Yqn
         HWX+NAw7grOfj+LiJXwgj38JY6cH8aSU2bn4EDw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Jiaming Li <lijiaming30@huawei.com>,
        Huaxin Lu <luhuaxin1@huawei.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.15 121/290] ima: Fix a potential NULL pointer access in ima_restore_measurement_list
Date:   Tue, 10 Jan 2023 19:03:33 +0100
Message-Id: <20230110180035.972434770@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Huaxin Lu <luhuaxin1@huawei.com>

commit 11220db412edae8dba58853238f53258268bdb88 upstream.

In restore_template_fmt, when kstrdup fails, a non-NULL value will still be
returned, which causes a NULL pointer access in template_desc_init_fields.

Fixes: c7d09367702e ("ima: support restoring multiple template formats")
Cc: stable@kernel.org
Co-developed-by: Jiaming Li <lijiaming30@huawei.com>
Signed-off-by: Jiaming Li <lijiaming30@huawei.com>
Signed-off-by: Huaxin Lu <luhuaxin1@huawei.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_template.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -336,8 +336,11 @@ static struct ima_template_desc *restore
 
 	template_desc->name = "";
 	template_desc->fmt = kstrdup(template_name, GFP_KERNEL);
-	if (!template_desc->fmt)
+	if (!template_desc->fmt) {
+		kfree(template_desc);
+		template_desc = NULL;
 		goto out;
+	}
 
 	spin_lock(&template_list);
 	list_add_tail_rcu(&template_desc->list, &defined_templates);


