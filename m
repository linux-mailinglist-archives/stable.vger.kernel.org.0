Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837355F2B14
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbiJCHr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiJCHqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:46:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4596D58526;
        Mon,  3 Oct 2022 00:26:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8823CB80E89;
        Mon,  3 Oct 2022 07:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F020DC433D7;
        Mon,  3 Oct 2022 07:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781874;
        bh=lfT5Sb/B3uL8Vk29p+EkIcR/HdZXKH5A9Ykqm1Y9UAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/kslXZdKPsIn1Th4BAnee+n4e/CYdHw1eE8bAfAHfsXZhPHMGVlV3LtSTryFD5Zw
         LnRLHyU7PPOYS3aBrKBqrefh/j7YrBu2JxRIPsSUxRgG228OZmtcoXIXCfbG64G1xq
         deTWxbdyExkP1qCRBijYAOGMZNuxa6/hgH8kp9Fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Janne Karhunen <janne.karhunen@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Gou Hao <gouhao@uniontech.com>
Subject: [PATCH 4.19 12/25] ima: Have the LSM free its audit rule
Date:   Mon,  3 Oct 2022 09:12:15 +0200
Message-Id: <20221003070715.772124468@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070715.406550966@linuxfoundation.org>
References: <20221003070715.406550966@linuxfoundation.org>
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

From: Tyler Hicks <tyhicks@linux.microsoft.com>

commit 9ff8a616dfab96a4fa0ddd36190907dc68886d9b upstream.

Ask the LSM to free its audit rule rather than directly calling kfree().
Both AppArmor and SELinux do additional work in their audit_rule_free()
hooks. Fix memory leaks by allowing the LSMs to perform necessary work.

Fixes: b16942455193 ("ima: use the lsm policy update notifier")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Janne Karhunen <janne.karhunen@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima.h        |    5 +++++
 security/integrity/ima/ima_policy.c |    4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -298,6 +298,7 @@ static inline int ima_read_xattr(struct
 #ifdef CONFIG_IMA_LSM_RULES
 
 #define security_filter_rule_init security_audit_rule_init
+#define security_filter_rule_free security_audit_rule_free
 #define security_filter_rule_match security_audit_rule_match
 
 #else
@@ -308,6 +309,10 @@ static inline int security_filter_rule_i
 	return -EINVAL;
 }
 
+static inline void security_filter_rule_free(void *lsmrule)
+{
+}
+
 static inline int security_filter_rule_match(u32 secid, u32 field, u32 op,
 					     void *lsmrule,
 					     struct audit_context *actx)
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1044,8 +1044,10 @@ void ima_delete_rules(void)
 
 	temp_ima_appraise = 0;
 	list_for_each_entry_safe(entry, tmp, &ima_temp_rules, list) {
-		for (i = 0; i < MAX_LSM_RULES; i++)
+		for (i = 0; i < MAX_LSM_RULES; i++) {
+			security_filter_rule_free(entry->lsm[i].rule);
 			kfree(entry->lsm[i].args_p);
+		}
 
 		list_del(&entry->list);
 		kfree(entry);


