Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2692836AD98
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhDZHh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232916AbhDZHgk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:36:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B00C613BA;
        Mon, 26 Apr 2021 07:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422473;
        bh=wQmhuzaCHK+pZWUvY/gW8zm0lQr9CrxBVVbOKseXz0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swJOujZTQbbUOaWjC15rUA1u8YMQtQKu4UIyCqnk3YT8dLKUs+TOfp0NfJC+4mm0E
         OZCckNPjQ68R6qNReMsd2hMY5kmT1WjHn62xomUO2npg8WtCr5APE9JZ3vtu8do82G
         5LQMWobDFJen/52sEiU7GMkFwsQZIqT/t3EbmBMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Qing <wangqing@vivo.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/49] arc: kernel: Return -EFAULT if copy_to_user() fails
Date:   Mon, 26 Apr 2021 09:29:01 +0200
Message-Id: <20210426072819.894742117@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
References: <20210426072819.721586742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

[ Upstream commit 46e152186cd89d940b26726fff11eb3f4935b45a ]

The copy_to_user() function returns the number of bytes remaining to be
copied, but we want to return -EFAULT if the copy doesn't complete.

Signed-off-by: Wang Qing <wangqing@vivo.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/kernel/signal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index 48685445002e..da243420bcb5 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -99,7 +99,7 @@ stash_usr_regs(struct rt_sigframe __user *sf, struct pt_regs *regs,
 			     sizeof(sf->uc.uc_mcontext.regs.scratch));
 	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(sigset_t));
 
-	return err;
+	return err ? -EFAULT : 0;
 }
 
 static int restore_usr_regs(struct pt_regs *regs, struct rt_sigframe __user *sf)
@@ -113,7 +113,7 @@ static int restore_usr_regs(struct pt_regs *regs, struct rt_sigframe __user *sf)
 				&(sf->uc.uc_mcontext.regs.scratch),
 				sizeof(sf->uc.uc_mcontext.regs.scratch));
 	if (err)
-		return err;
+		return -EFAULT;
 
 	set_current_blocked(&set);
 	regs->bta	= uregs.scratch.bta;
-- 
2.30.2



