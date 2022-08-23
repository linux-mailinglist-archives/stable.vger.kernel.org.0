Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3921759E02D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358578AbiHWLw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359050AbiHWLvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:51:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1CBD4181;
        Tue, 23 Aug 2022 02:32:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 873A3613F7;
        Tue, 23 Aug 2022 09:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0F6C433C1;
        Tue, 23 Aug 2022 09:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247140;
        bh=2xyhPch0MJygp7RYrx8cqb8RHV1ck2BsROSzHKc8JQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEii6ScxkdK9vWEZEQqPmtszYD2tuDbWysZ6xlQlyOIz9gIHPgIYf+Htl57m6xCZ5
         7ThXbsmIhUkT5ZLj/8NRgjq2lkxLRuhhh3scHVKzxH1bnBer8kObXCgHPubluMSr9L
         YHsDgq0NPl+jJt69Vr7kyS1+qniNm+EgnCi/Ef2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiu Jianfeng <xiujianfeng@huawei.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.4 300/389] apparmor: Fix memleak in aa_simple_write_to_buffer()
Date:   Tue, 23 Aug 2022 10:26:18 +0200
Message-Id: <20220823080128.102865094@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Xiu Jianfeng <xiujianfeng@huawei.com>

commit 417ea9fe972d2654a268ad66e89c8fcae67017c3 upstream.

When copy_from_user failed, the memory is freed by kvfree. however the
management struct and data blob are allocated independently, so only
kvfree(data) cause a memleak issue here. Use aa_put_loaddata(data) to
fix this issue.

Fixes: a6a52579e52b5 ("apparmor: split load data into management struct and data blob")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/apparmorfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -403,7 +403,7 @@ static struct aa_loaddata *aa_simple_wri
 
 	data->size = copy_size;
 	if (copy_from_user(data->data, userbuf, copy_size)) {
-		kvfree(data);
+		aa_put_loaddata(data);
 		return ERR_PTR(-EFAULT);
 	}
 


