Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53AC405068
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351120AbhIIM1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351119AbhIIMWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:22:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3B3F61AF8;
        Thu,  9 Sep 2021 11:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188266;
        bh=6GYGAVk2gYlgVH3/XQYaDlJTce6H+5zqR3EON9Hy2B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQ99mw22qUUyiUTTiCeJbmPoZ6MAUY6//724oEGbbY1y15UMbXICrNE1TE0YwRsZW
         zbGgAQNsvW37WYTHo7hSax81YvayeL+qUFJ7ZhDarqgWQVvZBAmaXBuoqtbnB4geHt
         QqM4Qcpkca+DeEkuP15353NEMkQ+WZ3K7cXa0WBGhKwOGRT4OB6i9Q14g1h43lTugn
         KUn3fGF4JLBQXpdLnKG+Q09FrkruEYArRiyshOJ0NGtbwMn70Gv3Tt3blgajg9KneU
         S/4jvbZ8v+Soml22bJw92X9YrnxpUbXVeqzj/3w+EypD4jXuKwoOkv7nCF+6Kn8Jcs
         ajYfwbWT4CDrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 211/219] parport: remove non-zero check on count
Date:   Thu,  9 Sep 2021 07:46:27 -0400
Message-Id: <20210909114635.143983-211-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 0be883a0d795d9146f5325de582584147dd0dcdc ]

The check for count appears to be incorrect since a non-zero count
check occurs a couple of statements earlier. Currently the check is
always false and the dev->port->irq != PARPORT_IRQ_NONE part of the
check is never tested and the if statement is dead-code. Fix this
by removing the check on count.

Note that this code is pre-git history, so I can't find a sha for
it.

Acked-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Addresses-Coverity: ("Logically dead code")
Link: https://lore.kernel.org/r/20210730100710.27405-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/ieee1284_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/parport/ieee1284_ops.c b/drivers/parport/ieee1284_ops.c
index 2c11bd3fe1fd..17061f1df0f4 100644
--- a/drivers/parport/ieee1284_ops.c
+++ b/drivers/parport/ieee1284_ops.c
@@ -518,7 +518,7 @@ size_t parport_ieee1284_ecp_read_data (struct parport *port,
 				goto out;
 
 			/* Yield the port for a while. */
-			if (count && dev->port->irq != PARPORT_IRQ_NONE) {
+			if (dev->port->irq != PARPORT_IRQ_NONE) {
 				parport_release (dev);
 				schedule_timeout_interruptible(msecs_to_jiffies(40));
 				parport_claim_or_block (dev);
-- 
2.30.2

