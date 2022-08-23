Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C5F59DF59
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354186AbiHWKYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354333AbiHWKVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:21:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF7A23A;
        Tue, 23 Aug 2022 02:02:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29B70B8105C;
        Tue, 23 Aug 2022 09:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E9AC433D6;
        Tue, 23 Aug 2022 09:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245352;
        bh=FPDq19YmQbyACbhIMdsFfnd/zvD9KE4s0mLFIVXUVOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiR88ePKSsfQW/ChXr7fI8P2fRAwwbDX3GzpLfa3liX3ISQ/1B4vcwKbOOBRPyOVo
         zy6oaLEwoM9cmitHTm/55Rc8+sPuG4vOKxzQKbqfruBUfzQGc97fyzvaX/ZuFWdmeT
         Qv24nk0QkH7IIksg8yMpG75iwwaHe8pjV4rjUdvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/287] selinux: Add boundary check in put_entry()
Date:   Tue, 23 Aug 2022 10:23:41 +0200
Message-Id: <20220823080101.995458514@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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



