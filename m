Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E0E58C14C
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243855AbiHHB6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244090AbiHHB4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F51B7D3;
        Sun,  7 Aug 2022 18:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F76060EE6;
        Mon,  8 Aug 2022 01:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A6EC433D6;
        Mon,  8 Aug 2022 01:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922819;
        bh=tvv5zKTRORCPg5nIx/6yTuFX5HiE0u44vXPAHIgH6PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haVs4VcWP9M2CfUTAHUzpoULTK7aSQfSmnEG/3ccS/lAaBt89AfLkNB7xoMlRpdwv
         VcfuX3Zmtl3tuE2KWVum9WnWQcknQVsARnLbKjkvnYJVZ9qC4bQwDdgfszQMU0s5YG
         0yDcpNOmx0dJ9b0IGS+3J9FdnBkyjS+ttazFUEDMPwg39MFpCYsmGk5X5MhahJSn+0
         0bsNbTHxnOdqQ1yrbvpSku4AL74orv6OsGDTvQNjGy9IwtYKN8xynR/vDWHg0S3oa2
         MSukhtWgdntFzNBbDp6bQ5RZaa7xiFMVIQxkkaSby/mSi942R+mWrRpBciexzMbwQb
         1DAFl0tztPldA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiu Jianfeng <xiujianfeng@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 8/8] selinux: Add boundary check in put_entry()
Date:   Sun,  7 Aug 2022 21:40:03 -0400
Message-Id: <20220808014005.317064-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808014005.317064-1-sashal@kernel.org>
References: <20220808014005.317064-1-sashal@kernel.org>
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
index 725d5945a97e..178d8804ecb1 100644
--- a/security/selinux/ss/policydb.h
+++ b/security/selinux/ss/policydb.h
@@ -349,6 +349,8 @@ static inline int put_entry(const void *buf, size_t bytes, int num, struct polic
 {
 	size_t len = bytes * num;
 
+	if (len > fp->len)
+		return -EINVAL;
 	memcpy(fp->data, buf, len);
 	fp->data += len;
 	fp->len -= len;
-- 
2.35.1

