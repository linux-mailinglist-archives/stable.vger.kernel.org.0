Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3EA738DA
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389047AbfGXTeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389042AbfGXTeD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:34:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 055B42238C;
        Wed, 24 Jul 2019 19:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996843;
        bh=Jp7I9JI9gHKzOWH5RRf8+aoRdq0+E3CVjbZ3MX7sVLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2aJecCK6a/Q89sK5vhv2ENUSeh3Z3ZjImUBz8E4kTVYdbPx31FcDZC725r52Gpf8G
         eqlgLoMxTDMa4V2BwlO6wGDWWZPaoPIJZ/XFeti1lO+rUReIWycKFUbe2OvrWrIrF0
         IjmXjQACqt0SRTQvZUouYM46kLuGvxyI0YF8jplU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 236/413] gtp: add missing gtp_encap_disable_sock() in gtp_encap_enable()
Date:   Wed, 24 Jul 2019 21:18:47 +0200
Message-Id: <20190724191752.167045447@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e30155fd23c9c141cbe7d99b786e10a83a328837 ]

If an invalid role is sent from user space, gtp_encap_enable() will fail.
Then, it should call gtp_encap_disable_sock() but current code doesn't.
It makes memory leak.

Fixes: 91ed81f9abc7 ("gtp: support SGSN-side tunnels")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index fc45b749db46..01fc51892e48 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -843,8 +843,13 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 
 	if (data[IFLA_GTP_ROLE]) {
 		role = nla_get_u32(data[IFLA_GTP_ROLE]);
-		if (role > GTP_ROLE_SGSN)
+		if (role > GTP_ROLE_SGSN) {
+			if (sk0)
+				gtp_encap_disable_sock(sk0);
+			if (sk1u)
+				gtp_encap_disable_sock(sk1u);
 			return -EINVAL;
+		}
 	}
 
 	gtp->sk0 = sk0;
-- 
2.20.1



