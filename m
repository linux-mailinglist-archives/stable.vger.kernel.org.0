Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6BB211F00
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfEBP1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:27:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbfEBP1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:27:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50EA420B7C;
        Thu,  2 May 2019 15:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810859;
        bh=S/hnEV/Fm4HD8QCgh1l35IVag92DVRNcOgaOol65l8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xiVB2QVU6mWYMP5JWvaPyyO/LQgl5mq6QNz4cDfmPvS0TUcbm0xW6NIiXbZNHX4CM
         gsxKnG5WUAfEP6qv9zymreybwxvE/APvakKLwTIBcDWk1u7pgTmAvBIRV6/laKGNdL
         5YenM1r0QJohIfBMWeMk/DMfoODJMdUK/Em2XN0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 10/72] ieee802154: hwsim: propagate genlmsg_reply return code
Date:   Thu,  2 May 2019 17:20:32 +0200
Message-Id: <20190502143334.278374504@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
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
index 624bff4d3636..f1ed1744801c 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -332,7 +332,7 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			goto out_err;
 		}
 
-		genlmsg_reply(skb, info);
+		res = genlmsg_reply(skb, info);
 		break;
 	}
 
-- 
2.19.1



