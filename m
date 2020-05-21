Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E36B1DD04B
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgEUOlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgEUOlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:39 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49550C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:38 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id g16so7390757qvq.14
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6AwcSx6XlDZKWjTHB4sLFi4iBJC4gzL8HXaBfWbdC6M=;
        b=Vuy9H0TtUkP2H3VVfCjwH3gvKNB+/LR+1lhkTwCv6AqembtAcwth+AGJLVFiBX5SPg
         FBuLF2C3P9AQk4tc2ipCnsfXHT9ktwpbrVF+GnB5iwDsfTmkwBihJRukxXE6V9fz6t+/
         epbE/pryPvSx17/SspvvOqSIQsY2I4z0N22n35gluUarzx1O7Pv+z3yHuQtdC/7ScZ0H
         HkUapw8NGiQYmEEN2nVkGHD1eZn+cPWxcy9Fo08DM8w9K71Q/00zq7XGdjSGO0qhly4e
         +V58oUDOKLdjc8VSWE1bfzT/xFrHSBw7MKlpDG4ZzjfYOtMrZpCjV5+JGo0hjrAqg+Ef
         LCWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6AwcSx6XlDZKWjTHB4sLFi4iBJC4gzL8HXaBfWbdC6M=;
        b=JTqOcmMtSwFsZOD8Un4fRBLCysueuamKY7evOruzKh9rpcRJpEl261d6JrEEQy3vtm
         dEEVpl38aF2178Gj3I7Kq5xeQ6AJO9LFsNlEClCTs4lc+Q+pE98J9DYjwf+wtpsv9f5X
         rDRbNCGviCeWOsL+C9IsU6EK24OMTX+r9t4ZbRctKirUrrbWPlqObbQEMXU7NrFCKlFw
         f3p5l2ZA/xyAbKYfqFRMoRVmNXkpKo/gF8BQEoI2W1t8doY9k3DOdb9hoyLIqTw+Zi4x
         6pNQeuEfY4bB1oPGyOp5rfyaLwgc1CfZkqijqd2qXul1vwVfOBIyyf0J0Z1AK8VQpOo6
         pF4w==
X-Gm-Message-State: AOAM53022PBzrOXLcjnZ9F3SXAfu4TDNbGnjnuua/O2c9yevSb7ivF0x
        8Jw0319LWtIoe45mtEqzR96n0/kyms4pPA==
X-Google-Smtp-Source: ABdhPJwsF9mN93LgkyMcjMc6+6/9sNYIPTeSmLvq81RiIue4YrhktSqju/Dujk51ot7IfVw5NwVBeXAXpbqwJQ==
X-Received: by 2002:ad4:5424:: with SMTP id g4mr2758227qvt.176.1590072097507;
 Thu, 21 May 2020 07:41:37 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:51 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-14-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 13/22] l2tp: hold tunnel while handling genl tunnel updates
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit 8c0e421525c9eb50d68e8f633f703ca31680b746 uptream.

We need to make sure the tunnel is not going to be destroyed by
l2tp_tunnel_destruct() concurrently.

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 93148a215e7c..e454f23f31fb 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -310,8 +310,8 @@ static int l2tp_nl_cmd_tunnel_modify(struct sk_buff *skb, struct genl_info *info
 	}
 	tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
 
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel == NULL) {
+	tunnel = l2tp_tunnel_get(net, tunnel_id);
+	if (!tunnel) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -322,6 +322,8 @@ static int l2tp_nl_cmd_tunnel_modify(struct sk_buff *skb, struct genl_info *info
 	ret = l2tp_tunnel_notify(&l2tp_nl_family, info,
 				 tunnel, L2TP_CMD_TUNNEL_MODIFY);
 
+	l2tp_tunnel_dec_refcount(tunnel);
+
 out:
 	return ret;
 }
-- 
2.26.2.761.g0e0b3e54be-goog

