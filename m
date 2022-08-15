Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A99359464F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349854AbiHOWic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349057AbiHOWfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0219972B73;
        Mon, 15 Aug 2022 12:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6F0CB81151;
        Mon, 15 Aug 2022 19:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D43C433D6;
        Mon, 15 Aug 2022 19:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592961;
        bh=D3RJWswlgttNeCNoxN0JrftIQMlO2blD6GKPcxf8Rqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjWIL1xtygkICe9IPJuw4HzBR3h8ZiZAXsqz3zTPz0yLb99nEhKq5NhBOdly72CCW
         OrPwBTZQ5fxD0yJLy6caEZzDvXahbxv8I2k7pIij1r4wlScaQA2cMwJfLR5lwsIrqb
         fbM/O+/peVSKgpz2rB9k7oP2OjhS23A41RXIRD6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0193/1157] selinux: fix memleak in security_read_state_kernel()
Date:   Mon, 15 Aug 2022 19:52:29 +0200
Message-Id: <20220815180447.464001926@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 73de1befcc53a7c68b0c5e76b9b5ac41c517760f ]

In this function, it directly returns the result of __security_read_policy
without freeing the allocated memory in *data, cause memory leak issue,
so free the memory if __security_read_policy failed.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
[PM: subject line tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/services.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 69b2734311a6..fe5fcf571c56 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -4048,6 +4048,7 @@ int security_read_policy(struct selinux_state *state,
 int security_read_state_kernel(struct selinux_state *state,
 			       void **data, size_t *len)
 {
+	int err;
 	struct selinux_policy *policy;
 
 	policy = rcu_dereference_protected(
@@ -4060,5 +4061,11 @@ int security_read_state_kernel(struct selinux_state *state,
 	if (!*data)
 		return -ENOMEM;
 
-	return __security_read_policy(policy, *data, len);
+	err = __security_read_policy(policy, *data, len);
+	if (err) {
+		vfree(*data);
+		*data = NULL;
+		*len = 0;
+	}
+	return err;
 }
-- 
2.35.1



