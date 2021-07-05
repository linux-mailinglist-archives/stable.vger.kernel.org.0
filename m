Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A078A3BC0C5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhGEPh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233227AbhGEPgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:36:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9842C61A3E;
        Mon,  5 Jul 2021 15:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499120;
        bh=2DVL+U5N0kazf0FUeuMzX3wQhzDFloqH7dh45Bnoz7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4M7KHgB0ApimQkwUWCFt78ZsfWxhOzM43ubdtejlujVO5cBioGZbrENt8nmyiUBi
         ClkgfJIdBw0tmeAqzxUByDpBEcX/Xpqk8916J03a48DpYQ43w3M4qUpY1p+u3FueqS
         T+ebMEP1Dsv8c3aLOiS7R45UlppTQpRO5xiER+aksQ9DxPujHX5Kma6z5lIjWc4QfC
         Y+SEm7fQnIptYh4+POOGGz0eYvUls0yQbCVPzdqSmB9roXiPkWSUwHoHx5v0E31hSx
         +Me2JfQle6nAJdrBEVmzDhsrNhn+EurruxQHolzo0rYKi3weIUZxH7QQ0Goz49BPnB
         A+9lW71pBMzIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.9 3/9] fs: dlm: cancel work sync othercon
Date:   Mon,  5 Jul 2021 11:31:49 -0400
Message-Id: <20210705153155.1522423-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153155.1522423-1-sashal@kernel.org>
References: <20210705153155.1522423-1-sashal@kernel.org>
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
index 609998de533e..0d8aaf9c61be 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -599,7 +599,7 @@ static void close_connection(struct connection *con, bool and_other,
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

