Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE4C3BC0A8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbhGEPhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233410AbhGEPf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:35:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F6B61A0F;
        Mon,  5 Jul 2021 15:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499105;
        bh=TBrufl6TPKKiNoy4hCLak0Og77qCfvDgDpsIRexzWhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTMCrBcWyKAi70zkpkzFyq6AXgWXmPv+tiNp0TMiI8RIbtGo1oa87/Q5g4GL4z4wY
         stospU6VfonhZHjo8EEJ7lsc+H8Qjevlwp5EEZd7xg1/qid+/XgLNSJaxKXabodsFj
         0nSavXCLVKGMMqlb+9oRzZohc7nUF4vNVPq0UXZFMxp6EiHoZjEPG3ZB90fEe53rwf
         UdR1+AZX9N0L1l9jdHgBrwYkL9gyO4fAYlSCG0TAwCTtMare5A0x+g6kAOj+yc0dwN
         82rmpd/fBek3WOpRZ4kdlojYdCN4waoL5WT8kPQkQ6J1NGMYZQBMEBeYofr6U5CngF
         OJrYzXyUN/RiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 07/15] fs: dlm: cancel work sync othercon
Date:   Mon,  5 Jul 2021 11:31:28 -0400
Message-Id: <20210705153136.1522245-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153136.1522245-1-sashal@kernel.org>
References: <20210705153136.1522245-1-sashal@kernel.org>
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
index 4813d0e0cd9b..af17fcd798c8 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -595,7 +595,7 @@ static void close_connection(struct connection *con, bool and_other,
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

