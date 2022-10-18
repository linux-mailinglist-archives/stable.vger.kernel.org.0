Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271F0601EC6
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiJRANJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiJRAL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:11:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAC88981E;
        Mon, 17 Oct 2022 17:09:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F06C61325;
        Tue, 18 Oct 2022 00:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040E6C43140;
        Tue, 18 Oct 2022 00:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051748;
        bh=F1Zh9MWWPP0P86pkGxoyo5sxny0zwrnppZjtslX2MnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0Y3Zf4sEWMcybc/TrVArC8mL2iskJHrONSaFRIBgHqNNtDNp8NVq9xXBsv1F2Tp7
         oY7kIuifhNj2dO7Qbws9961ReMl02NPMRucDkPtoUDVjU1zxVmO7zUJmXj6xhjvtOd
         24HtsaVA7XqRwKYO840jvP/W7PnZo0952NQ1Nq20uvmdgr3QxvuWCOgwEdhnd1zCMM
         Vcv4kgNSnIeYDHUe6TnwBwz6uJ1zf11ss9e5hP51tKVPgVWsQcG+6GFAYdzXbb4iZ5
         mweB7OdcFKqZdx0WC5kvmtRjXAefeTCtAAJ8k/APADTBZO9gooI10xBRMQlJTK9Vlr
         MwqOcN/5gjCxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 5.19 16/29] tracing/user_events: Use WRITE instead of READ for io vector import
Date:   Mon, 17 Oct 2022 20:08:25 -0400
Message-Id: <20221018000839.2730954-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000839.2730954-1-sashal@kernel.org>
References: <20221018000839.2730954-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Beau Belgrave <beaub@linux.microsoft.com>

[ Upstream commit 95f187603dbff69bef19b2ab3bb54d2c060f556d ]

import_single_range expects the direction/rw to be where it came from,
not the protection/limit. Since the import is in a write path use WRITE.

Link: https://lkml.kernel.org/r/20220728233309.1896-3-beaub@linux.microsoft.com
Link: https://lore.kernel.org/all/2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com/

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 706e1686b5eb..4c9f6c776618 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1245,7 +1245,8 @@ static ssize_t user_events_write(struct file *file, const char __user *ubuf,
 	if (unlikely(*ppos != 0))
 		return -EFAULT;
 
-	if (unlikely(import_single_range(READ, (char *)ubuf, count, &iov, &i)))
+	if (unlikely(import_single_range(WRITE, (char __user *)ubuf,
+					 count, &iov, &i)))
 		return -EFAULT;
 
 	return user_events_write_core(file, &i);
-- 
2.35.1

