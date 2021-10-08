Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9A34268B5
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbhJHLaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240180AbhJHLae (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E42CD61029;
        Fri,  8 Oct 2021 11:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692519;
        bh=IwBmwPj4lBeGAqBXUaux1jxyzcp9Z5zTSwal7ZcxulQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9pzTHaXf9tKMzgQMXfd+yyxOlJjSllGNrTTiEEsXMv8Y+pmd4O9DmtN1iOV1rCVX
         zPhuQBcngE73mNtwmo2z03RWk01Pennj6SpAfMQpRYMzxMdwQjRCtn/IIvXEeNO8Cd
         OCbw7W39QdjK7r6z4h53lMYCp7aqLQRKHDeLisbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 2/7] xen-netback: correct success/error reporting for the SKB-with-fraglist case
Date:   Fri,  8 Oct 2021 13:27:34 +0200
Message-Id: <20211008112713.595541458@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112713.515980393@linuxfoundation.org>
References: <20211008112713.515980393@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 3ede7f84c7c21f93c5eac611d60eba3f2c765e0f ]

When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
special considerations for the head of the SKB no longer apply. Don't
mistakenly report ERROR to the frontend for the first entry in the list,
even if - from all I can tell - this shouldn't matter much as the overall
transmit will need to be considered failed anyway.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/netback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index c8c6afc0ab51..15c73ebe5efc 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -994,7 +994,7 @@ check_frags:
 				 * the header's copy failed, and they are
 				 * sharing a slot, send an error
 				 */
-				if (i == 0 && sharedslot)
+				if (i == 0 && !first_shinfo && sharedslot)
 					xenvif_idx_release(queue, pending_idx,
 							   XEN_NETIF_RSP_ERROR);
 				else
-- 
2.33.0



