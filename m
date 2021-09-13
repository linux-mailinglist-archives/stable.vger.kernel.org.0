Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A674408F71
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbhIMNmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242653AbhIMNku (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:40:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1906613D3;
        Mon, 13 Sep 2021 13:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539774;
        bh=jpXnv+lOz7CF+EqMTV8TeBztP/jhrnZ8CpsUG2v5lOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHfbV9SszmFXcpRWcbboB2drLC3PoqbBL4bSykpOWL6dJ0i6xK7+ubt9jhO4lBDUV
         CpFkxqDHTEIeR8zIZFCLCrOvZkyq+Z2EEq2P569DkVnJ9cZg9yaYUXAvaypbDwsD9J
         jqOHPQ+/NgJJ5LDhE34XrD3/XdfXj+D29PGAu8zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/236] devlink: Clear whole devlink_flash_notify struct
Date:   Mon, 13 Sep 2021 15:14:20 +0200
Message-Id: <20210913131105.654865069@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 6cc8c64ed62a..96cf4bc1f958 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3403,7 +3403,7 @@ out_free_msg:
 
 void devlink_flash_update_begin_notify(struct devlink *devlink)
 {
-	struct devlink_flash_notify params = { 0 };
+	struct devlink_flash_notify params = {};
 
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE,
@@ -3413,7 +3413,7 @@ EXPORT_SYMBOL_GPL(devlink_flash_update_begin_notify);
 
 void devlink_flash_update_end_notify(struct devlink *devlink)
 {
-	struct devlink_flash_notify params = { 0 };
+	struct devlink_flash_notify params = {};
 
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE_END,
-- 
2.30.2



