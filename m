Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164BC3CE161
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349189AbhGSPZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346962AbhGSPSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:18:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F09A61402;
        Mon, 19 Jul 2021 15:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710294;
        bh=UxX7E/3Wyq0jhAF9czvnldpvgqX6Mzs0NdJQVvqk8Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WeP3bCXrJOHlfAG1aR8ajTvWFaGCo1Hu9NU0qa/pxMQNNE3JKb8ASbHk8zuOOJBW1
         3C41eEs07J0uOHUbsUqBh1KccnPz2KHPahlyPFx4mPRPqZ30QIlnzIL+T6hj/oSfOx
         UUm7S7bHQYsEUxguBng2doZ/4NytkjXaF9qRXp8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        anton.ivanov@cambridgegreys.com,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/243] um: fix error return code in slip_open()
Date:   Mon, 19 Jul 2021 16:53:06 +0200
Message-Id: <20210719144945.976221221@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit b77e81fbe5f5fb4ad9a61ec80f6d1e30b6da093a ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: a3c77c67a443 ("[PATCH] uml: slirp and slip driver cleanups and fixes")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-By: anton.ivanov@cambridgegreys.com
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/slip_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/slip_user.c b/arch/um/drivers/slip_user.c
index 482a19c5105c..7334019c9e60 100644
--- a/arch/um/drivers/slip_user.c
+++ b/arch/um/drivers/slip_user.c
@@ -145,7 +145,8 @@ static int slip_open(void *data)
 	}
 	sfd = err;
 
-	if (set_up_tty(sfd))
+	err = set_up_tty(sfd);
+	if (err)
 		goto out_close2;
 
 	pri->slave = sfd;
-- 
2.30.2



