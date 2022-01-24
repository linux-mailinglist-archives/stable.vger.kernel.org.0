Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41FD499384
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350658AbiAXUe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34092 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382881AbiAXU01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:26:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00EE3B811F9;
        Mon, 24 Jan 2022 20:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024E6C340E5;
        Mon, 24 Jan 2022 20:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055984;
        bh=LMcJzmhZ16w/aeOwg1sAK9yzJhMtOiwmj70gGTRHMjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ax+N1rIisuBJX/bTxDgK8YaAdRxW5CofIIMuKkPqe61MTaY2BIc1nevqiHmySwRuX
         tP7p59U12Cl7kC88uj1GQlvAiGphObVguPsRZS6mHEkfKKbd6/5SDTPIBHmzpjOX4T
         6uizZM0l79cdcaLkLRxVAErZrrBWTgEnHtxk2iII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Zixun <zhang133010@icloud.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 298/846] x86/mce/inject: Avoid out-of-bounds write when setting flags
Date:   Mon, 24 Jan 2022 19:36:55 +0100
Message-Id: <20220124184111.190228138@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Zixun <zhang133010@icloud.com>

[ Upstream commit de768416b203ac84e02a757b782a32efb388476f ]

A contrived zero-length write, for example, by using write(2):

  ...
  ret = write(fd, str, 0);
  ...

to the "flags" file causes:

  BUG: KASAN: stack-out-of-bounds in flags_write
  Write of size 1 at addr ffff888019be7ddf by task writefile/3787

  CPU: 4 PID: 3787 Comm: writefile Not tainted 5.16.0-rc7+ #12
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014

due to accessing buf one char before its start.

Prevent such out-of-bounds access.

  [ bp: Productize into a proper patch. Link below is the next best
    thing because the original mail didn't get archived on lore. ]

Fixes: 0451d14d0561 ("EDAC, mce_amd_inj: Modify flags attribute to use string arguments")
Signed-off-by: Zhang Zixun <zhang133010@icloud.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/linux-edac/YcnePfF1OOqoQwrX@zn.tnic/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 0bfc14041bbb4..b63b548497c14 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -350,7 +350,7 @@ static ssize_t flags_write(struct file *filp, const char __user *ubuf,
 	char buf[MAX_FLAG_OPT_SIZE], *__buf;
 	int err;
 
-	if (cnt > MAX_FLAG_OPT_SIZE)
+	if (!cnt || cnt > MAX_FLAG_OPT_SIZE)
 		return -EINVAL;
 
 	if (copy_from_user(&buf, ubuf, cnt))
-- 
2.34.1



