Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262753BBF85
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhGEPcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232354AbhGEPcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2156861978;
        Mon,  5 Jul 2021 15:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498972;
        bh=+7mU4Z0yAsxln+wq4nJ1jQzGwlMOiI8KrVghTM5I2dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFLBnESgTY9MXVdO5dlr+MeqGrmaUHwYvTk2iptty9xc7BHnCRaopcJHnxnc5km7q
         mb1gsgL/JpDwbKroEPpEl42IUvpBREflRFEY71r/G406Y4xxZJq0T3Yv0f3o+tkmZ2
         ttvEFYAIcI4D8LDsx4JxFx7oQXElNUbd6a5PvoIClli7XknKNtjMaeQINMY04PrgTa
         PsBXbYwtQBHnXW3TFAmBnIqywgIOHJbqXQJ8pldUjEwCIzHI+sxajhtVy78+rEQcBn
         kXz/6dPolkQbYIfFZH0WONkdeHPxMCOb6+P1HoFNgHEQPEDh5xQp/11UsIedyJmU5i
         tt0JRS4oiKixA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 15/52] fs: dlm: cancel work sync othercon
Date:   Mon,  5 Jul 2021 11:28:36 -0400
Message-Id: <20210705152913.1521036-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152913.1521036-1-sashal@kernel.org>
References: <20210705152913.1521036-1-sashal@kernel.org>
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
index 01b672cee783..7e6736c70e11 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -714,7 +714,7 @@ static void close_connection(struct connection *con, bool and_other,
 
 	if (con->othercon && and_other) {
 		/* Will only re-enter once. */
-		close_connection(con->othercon, false, true, true);
+		close_connection(con->othercon, false, tx, rx);
 	}
 
 	con->rx_leftover = 0;
-- 
2.30.2

