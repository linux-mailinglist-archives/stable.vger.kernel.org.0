Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82CC3E80BF
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbhHJRwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237251AbhHJRuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1E5261288;
        Tue, 10 Aug 2021 17:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617351;
        bh=LWtX7Sg/VE+wTK3kLySBFzwV8dTYOhUf8dKH7tMismg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUqhuWUNa4JbRRpjjidAi6iprkUDJY0LGQWAzzgjnYe+JhmC3JTYLiCCseinIS3RK
         fSsTQEGtScXINZXTc92qckQBres6ADihDyEOpC5g7BxB3B5kHE4LEOQeOkZg308F0G
         GDJSfB/SX48sx1mOvfnLt7WCAie+OVSw8bi6mmTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 020/175] ext4: fix potential uninitialized access to retval in kmmpd
Date:   Tue, 10 Aug 2021 19:28:48 +0200
Message-Id: <20210810173001.612148440@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit b66541422824cf6cf20e9a35112e9cb5d82cdf62 ]

if (!ext4_has_feature_mmp(sb)) then retval can be unitialized before
we jump to the wait_to_exit label.

Fixes: 61bb4a1c417e ("ext4: fix possible UAF when remounting r/o a mmp-protected file system")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20210713022728.2533770-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index bc364c119af6..cebea4270817 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -138,7 +138,7 @@ static int kmmpd(void *data)
 	unsigned mmp_check_interval;
 	unsigned long last_update_time;
 	unsigned long diff;
-	int retval;
+	int retval = 0;
 
 	mmp_block = le64_to_cpu(es->s_mmp_block);
 	mmp = (struct mmp_struct *)(bh->b_data);
-- 
2.30.2



