Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B7D28B97D
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390339AbgJLOBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731237AbgJLNin (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C68C422203;
        Mon, 12 Oct 2020 13:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509898;
        bh=RfuSN0CYEh4oojDPhHRz7Tt45yQDJvi6iWf2+2azS9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=javoQrK5mUlsV7v3oyJ5smGwUi+jSvsk5r8AC1x/nNgoh4EPm7bK+rk6OtTm3u9yR
         /AUIvOZ/g8vjQRlt4FZsd3UJR+tV2iNp56i6aFM3dNEwJpSjUXcln5J+R7Lpis2t+D
         yQ9b++OV5rd2SwgczJEVKvuM6UlDg7fe1UukDHL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 56/70] xfrm: clone whole liftime_cur structure in xfrm_do_migrate
Date:   Mon, 12 Oct 2020 15:27:12 +0200
Message-Id: <20201012132632.873988755@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 8366685b2883e523f91e9816d7be371eb1144749 ]

When we clone state only add_time was cloned. It missed values like
bytes, packets.  Now clone the all members of the structure.

v1->v3:
 - use memcpy to copy the entire structure

Fixes: 80c9abaabf42 ("[XFRM]: Extension for dynamic update of endpoint address(es)")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 37104258808a8..3f21d34833cf0 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1427,7 +1427,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	x->tfcpad = orig->tfcpad;
 	x->replay_maxdiff = orig->replay_maxdiff;
 	x->replay_maxage = orig->replay_maxage;
-	x->curlft.add_time = orig->curlft.add_time;
+	memcpy(&x->curlft, &orig->curlft, sizeof(x->curlft));
 	x->km.state = orig->km.state;
 	x->km.seq = orig->km.seq;
 	x->replay = orig->replay;
-- 
2.25.1



