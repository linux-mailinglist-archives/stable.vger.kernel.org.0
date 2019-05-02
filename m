Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3F011D4A
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfEBP3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbfEBP3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:29:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90B5F20B7C;
        Thu,  2 May 2019 15:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810940;
        bh=s/AAX1UEWBA673sm0A49Y3i7KR+3WkkM5w339LZRE40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zM9eluby54I41HjWnNh18O49y60nD6Xx17yPFXm0e2TUyWrGk1M+SGPE00NJ4KIEM
         mRRTCLM+xk1Grv0aakBKShNSIiSuIJ/VNO2lRUHRrKobJmB4IcHrjyqq32WwqAVKVQ
         2Da8Hu4iBUDOFPPnR1pWnugAXZZgGxsGEq5dIzEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 015/101] ieee802154: hwsim: propagate genlmsg_reply return code
Date:   Thu,  2 May 2019 17:20:17 +0200
Message-Id: <20190502143341.114195926@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 19b39a25388e71390e059906c979f87be4ef0c71 ]

genlmsg_reply can fail, so propagate its return code

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index b6743f03dce0..3b88846de31b 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -324,7 +324,7 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			goto out_err;
 		}
 
-		genlmsg_reply(skb, info);
+		res = genlmsg_reply(skb, info);
 		break;
 	}
 
-- 
2.19.1



