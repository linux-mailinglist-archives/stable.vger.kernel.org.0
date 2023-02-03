Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C8468965E
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbjBCK2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbjBCK14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:27:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E09C1043E
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:27:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2210561EC7
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2248C433EF;
        Fri,  3 Feb 2023 10:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420028;
        bh=cvLq+yvxkJlEFaASeVrLiMX4COBGk8+rYUWfYsjkzSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAHrNAllN5y5iuxmiBIDakHFvJFxiX9/iVcBa9awzARm0f8+5zceUmBuNmhxjnRz0
         QYhJ4rhjHf9KfNlY8XjIOlbeoun/XGe8sLjuCpRR2fcYYwiPJqe/4O4HLmGS2e7HO2
         KytgARbmrylInBIyRF+UqzwcV4YAdZS0omNK1C2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/134] s390/debug: add _ASM_S390_ prefix to header guard
Date:   Fri,  3 Feb 2023 11:12:40 +0100
Message-Id: <20230203101026.357817812@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 0d4d52361b6c29bf771acd4fa461f06d78fb2fac ]

Using DEBUG_H without a prefix is very generic and inconsistent with
other header guards in arch/s390/include/asm. In fact it collides with
the same name in the ath9k wireless driver though that depends on !S390
via disabled wireless support. Let's just use a consistent header guard
name and prevent possible future trouble.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/debug.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/debug.h b/arch/s390/include/asm/debug.h
index 310134015541..54f4bc5d1108 100644
--- a/arch/s390/include/asm/debug.h
+++ b/arch/s390/include/asm/debug.h
@@ -4,8 +4,8 @@
  *
  *    Copyright IBM Corp. 1999, 2000
  */
-#ifndef DEBUG_H
-#define DEBUG_H
+#ifndef _ASM_S390_DEBUG_H
+#define _ASM_S390_DEBUG_H
 
 #include <linux/string.h>
 #include <linux/spinlock.h>
@@ -416,4 +416,4 @@ int debug_unregister_view(debug_info_t *id, struct debug_view *view);
 #define PRINT_FATAL(x...)	printk(KERN_DEBUG PRINTK_HEADER x)
 #endif /* DASD_DEBUG */
 
-#endif /* DEBUG_H */
+#endif /* _ASM_S390_DEBUG_H */
-- 
2.39.0



