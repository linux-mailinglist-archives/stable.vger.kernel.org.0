Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9804A58C130
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243782AbiHHB5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243822AbiHHB4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690C5FD0B;
        Sun,  7 Aug 2022 18:39:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E482B80DDF;
        Mon,  8 Aug 2022 01:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11956C433D6;
        Mon,  8 Aug 2022 01:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922781;
        bh=FPDq19YmQbyACbhIMdsFfnd/zvD9KE4s0mLFIVXUVOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmwPV2acglsSvsZuLYKlN149I5kMtyx5xHxcwQAiozjb1hXD12VZrzf7zF/DPQced
         DLeqkTcuhUDLI1hX1D4rOz73a8rFrMV3HO136wK3/32gyNTFEy62U15Lp6UeAdUcbX
         QeyhRPA3/jS9oYdGi0uvCcrBhAvZjflp/gqbiQimm/nt43PnyLbV+3SMHkFrdJuFR8
         4jxXneIP5ApbWk421pSdUnmE4y3BfZhQmIfyF7oHD5w2TWFhupBkRN83LfGxn8xXbY
         5v9HqHOiMZAfpIMpDTrgLo2pKFEmUH/ngposuvMmIbnnOoJzdHURm8aZXdub1hbseu
         0TCJQWpWJTA+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiu Jianfeng <xiujianfeng@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/16] selinux: Add boundary check in put_entry()
Date:   Sun,  7 Aug 2022 21:39:13 -0400
Message-Id: <20220808013914.316709-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013914.316709-1-sashal@kernel.org>
References: <20220808013914.316709-1-sashal@kernel.org>
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
index 215f8f30ac5a..2a479785ebd4 100644
--- a/security/selinux/ss/policydb.h
+++ b/security/selinux/ss/policydb.h
@@ -360,6 +360,8 @@ static inline int put_entry(const void *buf, size_t bytes, int num, struct polic
 {
 	size_t len = bytes * num;
 
+	if (len > fp->len)
+		return -EINVAL;
 	memcpy(fp->data, buf, len);
 	fp->data += len;
 	fp->len -= len;
-- 
2.35.1

