Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A3F11F20
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfEBPZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbfEBPZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:25:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD36720675;
        Thu,  2 May 2019 15:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810704;
        bh=OIiIwFpL32ezEt1GXclMSHdGI81OzQ4c3atY4iwVccE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Oyo/0+ODlOAXNIICkcVL7XZfHEKVEHDsXigy0lt7ac54H5zb/Irn18+l8A24ycHH
         RcX5W7qsCBtthNsg3e7EDA4VUhHJc+XEyDRmJiW0+uc0y9MjU1qtWN/FjKx3ruNJ/T
         KLeeHX0KKuj3OjTzGpJTEWAzI7toofmwtpOTBJ+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 30/49] net/sched: dont dereference a->goto_chain to read the chain index
Date:   Thu,  2 May 2019 17:21:07 +0200
Message-Id: <20190502143327.657639861@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fe384e2fa36ca084a456fd30558cccc75b4b3fbd ]

callers of tcf_gact_goto_chain_index() can potentially read an old value
of the chain index, or even dereference a NULL 'goto_chain' pointer,
because 'goto_chain' and 'tcfa_action' are read in the traffic path
without caring of concurrent write in the control path. The most recent
value of chain index can be read also from a->tcfa_action (it's encoded
there together with TC_ACT_GOTO_CHAIN bits), so we don't really need to
dereference 'goto_chain': just read the chain id from the control action.

Fixes: e457d86ada27 ("net: sched: add couple of goto_chain helpers")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 include/net/tc_act/tc_gact.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/tc_act/tc_gact.h b/include/net/tc_act/tc_gact.h
index e82d93346b63..bb74ea83d57d 100644
--- a/include/net/tc_act/tc_gact.h
+++ b/include/net/tc_act/tc_gact.h
@@ -51,7 +51,7 @@ static inline bool is_tcf_gact_goto_chain(const struct tc_action *a)
 
 static inline u32 tcf_gact_goto_chain_index(const struct tc_action *a)
 {
-	return a->goto_chain->index;
+	return READ_ONCE(a->tcfa_action) & TC_ACT_EXT_VAL_MASK;
 }
 
 #endif /* __NET_TC_GACT_H */
-- 
2.19.1



