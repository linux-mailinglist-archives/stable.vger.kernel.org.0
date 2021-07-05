Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C988E3BC072
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbhGEPgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233160AbhGEPey (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3C7A619AD;
        Mon,  5 Jul 2021 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499084;
        bh=PWDQcW0qgTf0nfb1boA+21LCDTNkO+PPhim+Nm5vvaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rskuZiWAO6TUmBB9VL9mdK6l9sjE4NJq+GJwFi10KoMjhcIK/f0V9kQrexBo7+Ivl
         CDyOlonE2DvFP9W/RebbyBYw3hgadH/rwOWqOh7pVEgGWpzqDlYStOrD1XezgqK0KQ
         5U3ANVvudyT+CHc3gN7A2nUzSoyS/Xi9vYBjqzy23mBVxD0uqk0B34iqJuJsfekQJ3
         DZOHpj4RieiyAUCy4otAFUoePeh8wriB+cWRyE/n5KuT/vMO7j9dx7wm408/b+M6lB
         VMpkGljtpEhRBwQrGXMB1Y7VqdSlkv3YQR3yc0f81R2fy3nCjxX8A964UPx2RIOPjO
         9JPkkVmIkI1kA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 08/17] fs: dlm: cancel work sync othercon
Date:   Mon,  5 Jul 2021 11:31:04 -0400
Message-Id: <20210705153114.1522046-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153114.1522046-1-sashal@kernel.org>
References: <20210705153114.1522046-1-sashal@kernel.org>
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
index a93ebffe84b3..f476a90e8aae 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -609,7 +609,7 @@ static void close_connection(struct connection *con, bool and_other,
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

