Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC8C1DDB25
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbgEUXj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgEUXj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:39:58 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50740C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:58 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id m9so9726725qtf.2
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jxAb0lBk4QuljfyG4+xJxwB31oF+LxH08LKlOkWqngA=;
        b=TYGt2hLa/gIuC1YSPxzYzwlI4T/RTBVoC7fPaT1sXR7jUXMBEAWEhsFtvY+PDZH3oZ
         U5CCepg/d8hhPT8WDCr75I7/QrpsJKwW/ZUKCOww6V9sTBkQMa0qkuQymamzAm109JCM
         OAQilk+24gul/27sMUboGoOqehLjrtbbV29gM26ObIYvOf/5LNzc0V8PIDekfriOHrwx
         bOjWq8LGzzTmnFi6WCcTRSdPhat/4oDTUYKAYSYuddVdKGTtanqpFlWczdk1INzPjUtF
         2UFaEDfRySXO8jrOre1C9l0DEGKI+GcuD07W9MBCnk3IOtsK9UtjNcEG4twk210ey/hP
         GBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jxAb0lBk4QuljfyG4+xJxwB31oF+LxH08LKlOkWqngA=;
        b=MGsTynhUtHiV0t04SH4XTvW5fhyB3LBr18JkuPMNyFV5Zk/lCcqTCbBUsaCpwTLayM
         1djesqQF88Ub4Frfo1SokBWzfW+Br6AaFTMCOWALmkRQygIMcAvTF/MExJhwkgnbytFv
         cWdqNqqTKYH81Rhekb3F4Z3nyh67TBfHSNXHX+NfMkaUKq9eXjeaVAk2BF9LNtaKUpTl
         tw/L2zgRlyoVHUudCBKdK5x1QuixRmyJs2/l5pndK3SNbBYEhhCHMJRJ/4o0JqrhR8Iw
         JocY5d5MqYulGiPOG3NEABF8ydDc5IlwX+kiXOqjw+iRpI8cNxzDrI0iT0jQnS9GapO/
         s6ZQ==
X-Gm-Message-State: AOAM530YAo6PC8Gch63/9pzYDNk4098GJdYa5Gi6dXeDDNqCzttRRi2m
        97j4zTsRsVPDTs9VnZ1IeD8q2QVErEql3w==
X-Google-Smtp-Source: ABdhPJyKVNofftkbZcOCw/+ZFSWTEecsv260mt5yyyzAkKCJkVFNTWJFfUtjm8Rdxj6+pxU3+4vo8x9jmwDpvA==
X-Received: by 2002:a0c:fb4b:: with SMTP id b11mr1195927qvq.96.1590104397500;
 Thu, 21 May 2020 16:39:57 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:21 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-7-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 06/22] l2tp: remove useless duplicate session detection in l2tp_netlink
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

commit af87ae465abdc070de0dc35d6c6a9e7a8cd82987 upstream.

There's no point in checking for duplicate sessions at the beginning of
l2tp_nl_cmd_session_create(); the ->session_create() callbacks already
return -EEXIST when the session already exists.

Furthermore, even if l2tp_session_find() returns NULL, a new session
might be created right after the test. So relying on ->session_create()
to avoid duplicate session is the only sane behaviour.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_netlink.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index d6fccfdca201..36651b60d776 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -513,11 +513,6 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 		goto out;
 	}
 	session_id = nla_get_u32(info->attrs[L2TP_ATTR_SESSION_ID]);
-	session = l2tp_session_find(net, tunnel, session_id);
-	if (session) {
-		ret = -EEXIST;
-		goto out;
-	}
 
 	if (!info->attrs[L2TP_ATTR_PEER_SESSION_ID]) {
 		ret = -EINVAL;
-- 
2.27.0.rc0.183.gde8f92d652-goog

