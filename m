Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9A73BC026
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhGEPel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:34:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232921AbhGEPdu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:33:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F14261998;
        Mon,  5 Jul 2021 15:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499050;
        bh=VZxEzNYxkjz5w53d9KGlJfdQh/qfRbYdnoWkSUN3LIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vqszb0pyqx+ZUbL/rioimVDX8l6Q1mdhztyXQuDdn0/NrCPauudTEfxDX1+aK1Gp2
         sGbU1h4QUiCHAw+HDS0BnWUPlUn6gf46H8RXhW7nSCn0vcT+qLEq7/0KwKASHz+t7s
         o46B8tpn2D+gmkQ4eH52ALGnEZRe7MuF2DvudxPF6otXVR17yJnlpPvHC8UKR77d1u
         +P/yZD/bH4kX2AxUzAJyR+6qY8HAdt8V+v1vbIlCIQrFjLzA9f5eAyC5mNLt+nsZXm
         r9NPRb3J9J4t3vowYwNR3sXW/uXrv8GmDw5c8Skz13pTh58GhkmoQ6keVfc8jFv7Bd
         XlPqxqHmlfkcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 08/26] fs: dlm: cancel work sync othercon
Date:   Mon,  5 Jul 2021 11:30:21 -0400
Message-Id: <20210705153039.1521781-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit c6aa00e3d20c2767ba3f57b64eb862572b9744b3 ]

These rx tx flags arguments are for signaling close_connection() from
which worker they are called. Obviously the receive worker cannot cancel
itself and vice versa for swork. For the othercon the receive worker
should only be used, however to avoid deadlocks we should pass the same
flags as the original close_connection() was called.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 3951d39b9b75..d9202ba665ce 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -607,7 +607,7 @@ static void close_connection(struct connection *con, bool and_other,
 	}
 	if (con->othercon && and_other) {
 		/* Will only re-enter once. */
-		close_connection(con->othercon, false, true, true);
+		close_connection(con->othercon, false, tx, rx);
 	}
 	if (con->rx_page) {
 		__free_page(con->rx_page);
-- 
2.30.2

