Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC0B3CDAC2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245054AbhGSOh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:37:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243766AbhGSOgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:36:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F216113C;
        Mon, 19 Jul 2021 15:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707815;
        bh=TBrufl6TPKKiNoy4hCLak0Og77qCfvDgDpsIRexzWhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WH8ZZ/0AWPVXLge6xh69xwvJ9489/AHZLzzjKOFwYzbKwBKpnrVogsrGm0SIUVKxz
         t1LC8lUcLUYUJeUCuj4B5+SAKJrrWdfO32j28y7CIxJYuWD9XAQ1MfTC7oGMqhjZBq
         K8hKdHxi93/EJL4HYVuaIU2ySZHb3rFbNVPB2ATQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 066/315] fs: dlm: cancel work sync othercon
Date:   Mon, 19 Jul 2021 16:49:15 +0200
Message-Id: <20210719144945.026485549@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



