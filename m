Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389E959D804
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351043AbiHWJei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350660AbiHWJd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:33:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8667E93524;
        Tue, 23 Aug 2022 01:39:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A75EB81C54;
        Tue, 23 Aug 2022 08:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2640C433C1;
        Tue, 23 Aug 2022 08:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243869;
        bh=FPDq19YmQbyACbhIMdsFfnd/zvD9KE4s0mLFIVXUVOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kh/+88KRUrgXQtAsSqmJv33ZeCxkvvp/Hp2A5DJpQHZAeZwufw28Ys5e6ve209NrN
         pH/Cn+mIckMLbL0RidQtUcHVMxuteMINWEn+5SkdBZwrT9u7BbKlFEwDVN7CSrWz/h
         UofzknpcnJIb5JsA/EEIFnmHaV2N3cPfa7BfAjEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 048/229] selinux: Add boundary check in put_entry()
Date:   Tue, 23 Aug 2022 10:23:29 +0200
Message-Id: <20220823080055.382672506@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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



