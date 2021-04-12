Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C6735CCFC
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245212AbhDLQcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243766AbhDLQaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:30:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 474C76139C;
        Mon, 12 Apr 2021 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244759;
        bh=wQmhuzaCHK+pZWUvY/gW8zm0lQr9CrxBVVbOKseXz0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJVlgUb+NRcWK9aaFy19WIPNDPYkSoeBGLPug83HYVP7deJbd6olatU3BYxi4yY3F
         KbQiolF/Ln8kqfdi6q3sgxubhJQFvFfOLSqDBFWL+yw3p3a7Ilss8tXzUr3/8LiYot
         HVx+NJs4NoA6eruCxj8zzrEHTeSAV1s8S006VpjJm2m5tsI5l6iKMDL7JKghCZjy0r
         n97X9ToSYTMi28d/IjibNl+zYvu2kh8KP0pkwXwzLnnvS+ROETHoNaHjkTw5uAkDSr
         j7LassIdsorzQJPlyZaGcrF8cztBcANKH6kTVILVL7StFfN6JK2CgwpmJOGIN9WAIT
         V2Fec8UlKD/vA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 05/28] arc: kernel: Return -EFAULT if copy_to_user() fails
Date:   Mon, 12 Apr 2021 12:25:30 -0400
Message-Id: <20210412162553.315227-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162553.315227-1-sashal@kernel.org>
References: <20210412162553.315227-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

