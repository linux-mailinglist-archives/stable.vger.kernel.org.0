Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA1C3BBFDC
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhGEPdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232592AbhGEPcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D232C61983;
        Mon,  5 Jul 2021 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499018;
        bh=cURFvA4Jf7l4CwOYpQGRCuP5EibVf4sASovRx07Poxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgdN5E+BP8Z6wPBSsTWUBeRDQSEfbbC34Odlo3QobSzVYsl20x0muWFtLJkNnEfwm
         luRL5wdio3tqBONnyEpS6JVZ8dbzpoH9HdH6IOejjwSgXHbHOMLoIj7dC28W5XWy58
         mNx+N3kr0wugw0osMvMfSGw53ebZnDeaZadefRs8bL9shyQYeGO7HWZO+tNT4Q1MLP
         euWQDWmxZAOjJgPUhNi9pBS2OjXjI50otBpeU6U2vrtRf5jRm5eQXitlKXXDfaePxC
         rC7PbD/MvoV2vXcVoWOTOamvmq+oeSbPR3snbKsXVMBU7Mu5TOuA7aeBgkCgrn7fZU
         He931tNQy+uOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 13/41] fs: dlm: cancel work sync othercon
Date:   Mon,  5 Jul 2021 11:29:33 -0400
Message-Id: <20210705153001.1521447-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153001.1521447-1-sashal@kernel.org>
References: <20210705153001.1521447-1-sashal@kernel.org>
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
index 44e2716ac158..0c78fdfb1f6f 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -599,7 +599,7 @@ static void close_connection(struct connection *con, bool and_other,
 	}
 	if (con->othercon && and_other) {
 		/* Will only re-enter once. */
-		close_connection(con->othercon, false, true, true);
+		close_connection(con->othercon, false, tx, rx);
 	}
 
 	con->rx_leftover = 0;
-- 
2.30.2

