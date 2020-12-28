Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF4D2E6931
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgL1Mzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbgL1Mzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:55:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28F1022583;
        Mon, 28 Dec 2020 12:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160128;
        bh=15D66lAmC5ujMvsiQPtB5KNQLQq+7RPCCp9Gt1GWBx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2xaf5H+FtnBlZL8jXN6ALHMpLiJu4RaiDJdVBYJDP4AOuoplg4sjnZ4eO8BZmRMh
         aO0rW9OTAJBrWd9HnQ0iGHMYFFziQ+AG+/hcBN3NTt34o+ACFK2ZF7QIjBfvlDmfoE
         nVPtdb9bawlPcYTAmsh7evrPRlllTo4k+c7R+JOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 078/132] speakup: fix uninitialized flush_lock
Date:   Mon, 28 Dec 2020 13:49:22 +0100
Message-Id: <20201228124850.206005931@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit d1b928ee1cfa965a3327bbaa59bfa005d97fa0fe ]

The flush_lock is uninitialized, use DEFINE_SPINLOCK
to define and initialize flush_lock.

Fixes: c6e3fd22cd53 ("Staging: add speakup to the staging directory")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20201117012229.3395186-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/speakup/speakup_dectlk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/speakup_dectlk.c b/drivers/staging/speakup/speakup_dectlk.c
index 09063b82326f1..71aa623facd69 100644
--- a/drivers/staging/speakup/speakup_dectlk.c
+++ b/drivers/staging/speakup/speakup_dectlk.c
@@ -51,7 +51,7 @@ static unsigned char get_index(void);
 static int in_escape;
 static int is_flushing;
 
-static spinlock_t flush_lock;
+static DEFINE_SPINLOCK(flush_lock);
 static DECLARE_WAIT_QUEUE_HEAD(flush);
 
 static struct var_t vars[] = {
-- 
2.27.0



