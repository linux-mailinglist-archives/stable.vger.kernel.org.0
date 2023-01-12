Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B99C6675AE
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbjALOX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbjALOXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:23:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E721254DBD
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:14:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F184B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EC0C433EF;
        Thu, 12 Jan 2023 14:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532888;
        bh=gF1lkcYF29gg8fx72uf5rO5vAAc3m1MmbkLcp5tEfjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKNHER6bnOyfqUOMHB9HjhK8JHPvnXal3ucbguuAX4t2O6OsK6TjAGmrfFJ4sEDRO
         EQNy6hL7kPDwdWOciZuaCq6QBHYsPkQkd0KEZnOst2YPb7dKDlgOwk6Prrve2G+5/d
         34X6H+GPHmJW1gl11JlpetUAfsa8G9MS0sGv/TKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/783] apparmor: fix a memleak in multi_transaction_new()
Date:   Thu, 12 Jan 2023 14:49:53 +0100
Message-Id: <20230112135537.237662469@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index c173f6fd7aee..49d97b331abc 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -867,8 +867,10 @@ static struct multi_transaction *multi_transaction_new(struct file *file,
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



