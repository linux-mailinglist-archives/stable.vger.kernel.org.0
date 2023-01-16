Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA86666CCD5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbjAPR3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234801AbjAPR3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:29:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFD238EA4
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:06:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78D9061089
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E769C433EF;
        Mon, 16 Jan 2023 17:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888796;
        bh=5w9TgSiHiITj4U+TEURvmQb3w7Xd4Q32ydJbMWhLr4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4mBuFWYf6IuC9eLQ1Ba687eni7h4JKP4y4eUhXS56vW2guupy5pEIzg33e2FCrsB
         neKmlSXR77HHZG4UJnLe7ddLYrXWFqjdrU5IDYUJ/EXOMWLQ0axF7D+V/1w3oKOKo4
         3Y0MdTJ+vM1BFijJyTlWMM9aFND6ECzdvM8xuJXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 141/338] apparmor: fix a memleak in multi_transaction_new()
Date:   Mon, 16 Jan 2023 16:50:14 +0100
Message-Id: <20230116154826.994936553@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit c73275cf6834787ca090317f1d20dbfa3b7f05aa ]

In multi_transaction_new(), the variable t is not freed or passed out
on the failure of copy_from_user(t->data, buf, size), which could lead
to a memleak.

Fix this bug by adding a put_multi_transaction(t) in the error path.

Fixes: 1dea3b41e84c5 ("apparmor: speed up transactional queries")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index afd3e06e8fdd..91f636c353e5 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -874,8 +874,10 @@ static struct multi_transaction *multi_transaction_new(struct file *file,
 	if (!t)
 		return ERR_PTR(-ENOMEM);
 	kref_init(&t->count);
-	if (copy_from_user(t->data, buf, size))
+	if (copy_from_user(t->data, buf, size)) {
+		put_multi_transaction(t);
 		return ERR_PTR(-EFAULT);
+	}
 
 	return t;
 }
-- 
2.35.1



