Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D487B40955B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345367AbhIMOkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344700AbhIMOiQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:38:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E76C161BFA;
        Mon, 13 Sep 2021 13:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541296;
        bh=1KxslZDYSzRSDVoMzpoXv6DNjpDe7gVNaxhtbnTnN0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqh1f+LR5ozP0+YGpZ0f4W3LAh+JZgNLcD0Ivk54CT2x/OlTZciR4GXw/EHuZS+Mn
         KbsICeg/kAJ+gErOD9CjoY8cFiFeU+Rqz0mRZHhoOttwPsVsaQQEQryDq2Su8reIJ9
         RR3kYcRP9CM6v/+xVBAPBN/IKc9UhC8FGEKotVZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 209/334] devlink: Clear whole devlink_flash_notify struct
Date:   Mon, 13 Sep 2021 15:14:23 +0200
Message-Id: <20210913131120.485128665@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit ed43fbac717882165a2a4bd64f7b1f56f7467bb7 ]

The { 0 } doesn't clear all fields in the struct, but tells to the
compiler to set all fields to zero and doesn't touch any sub-fields
if they exists.

The {} is an empty initialiser that instructs to fully initialize whole
struct including sub-fields, which is error-prone for future
devlink_flash_notify extensions.

Fixes: 6700acc5f1fe ("devlink: collect flash notify params into a struct")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3963b1bc1e59..5a85a7b0feb2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4125,7 +4125,7 @@ out_free_msg:
 
 static void devlink_flash_update_begin_notify(struct devlink *devlink)
 {
-	struct devlink_flash_notify params = { 0 };
+	struct devlink_flash_notify params = {};
 
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE,
@@ -4134,7 +4134,7 @@ static void devlink_flash_update_begin_notify(struct devlink *devlink)
 
 static void devlink_flash_update_end_notify(struct devlink *devlink)
 {
-	struct devlink_flash_notify params = { 0 };
+	struct devlink_flash_notify params = {};
 
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE_END,
-- 
2.30.2



