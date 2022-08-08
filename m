Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7A158C0FC
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbiHHB5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243702AbiHHBzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:55:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE611C117;
        Sun,  7 Aug 2022 18:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCAF2B80DDF;
        Mon,  8 Aug 2022 01:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75C8C433C1;
        Mon,  8 Aug 2022 01:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922752;
        bh=seCT/ORXlSvodg00k6NkJU1CqWU/SW76DI4qvjh+el8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDQfnofeU9kcJb0fiop7yCD1y6EmD5A/Evih5YtGqKbWz6XN/jbR/biPmdaObkzMA
         8gyn69JNueOpqEy5Uf7BSfeL+NmQZWDyceAAvBIIVw8vBDebxpFdakwyBiNtSbPZKv
         NdakFw9GIbDwTB9jfa5XCqfF7f8yay+qHRVul+re4Nf5tgmVuS/HnWS7AEJVEFbipG
         N0KvmxBZKg6UOefNesPD5BMLJYurquQZGNcUqAjJQFSOUdvFVkgEfSgBfCshvw9Q5i
         0pdjiiTkcdpBkM1cROh1iAvLnbCd03tlhmR6EmIuSunY6LmojVLWaByr0luBTcPakg
         ksWvSTllH9ixQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiu Jianfeng <xiujianfeng@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/23] selinux: Add boundary check in put_entry()
Date:   Sun,  7 Aug 2022 21:38:30 -0400
Message-Id: <20220808013832.316381-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013832.316381-1-sashal@kernel.org>
References: <20220808013832.316381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 15ec76fb29be31df2bccb30fc09875274cba2776 ]

Just like next_entry(), boundary check is necessary to prevent memory
out-of-bound access.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/policydb.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/selinux/ss/policydb.h b/security/selinux/ss/policydb.h
index 162d0e79b85b..b18bc405f820 100644
--- a/security/selinux/ss/policydb.h
+++ b/security/selinux/ss/policydb.h
@@ -356,6 +356,8 @@ static inline int put_entry(const void *buf, size_t bytes, int num, struct polic
 {
 	size_t len = bytes * num;
 
+	if (len > fp->len)
+		return -EINVAL;
 	memcpy(fp->data, buf, len);
 	fp->data += len;
 	fp->len -= len;
-- 
2.35.1

