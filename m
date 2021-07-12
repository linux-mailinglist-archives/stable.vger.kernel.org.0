Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716983C5426
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347460AbhGLH5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244486AbhGLHxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 857D861242;
        Mon, 12 Jul 2021 07:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076212;
        bh=d8jd44KxI7f0aTLem40HYjRu39V/5zf/K7GYju+Vr2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FL3+suMuKqLGidB9+sSwW/hkCEedpyyxn6bIdBTE71i0S2s8/DnBI7wZxvgRaAT3
         ymvmSJ+XgDZqi3xK1lWip0K/88O0jJXfIxv8XEYnRAYX+JXgliMfPmY+E3rrNIkr7A
         sH7KHA4EXtWjOCZlq7l7609i7golvl3iBL+Slyu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        syzbot <syzkaller@googlegroups.com>,
        Alexander Aring <aahringo@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 546/800] ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl()
Date:   Mon, 12 Jul 2021 08:09:29 +0200
Message-Id: <20210712061025.446755370@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0303b30375dff5351a79cc2c3c87dfa4fda29bed ]

Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
must be present to avoid a crash.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Aring <alex.aring@gmail.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210621180244.882076-1-eric.dumazet@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index baa7e21b7f4f..ebc976b7fcc2 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -480,7 +480,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, struct genl_info *info)
 	struct hwsim_edge *e;
 	u32 v0, v1;
 
-	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
+	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
-- 
2.30.2



