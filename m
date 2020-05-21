Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E521DD043
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgEUOlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgEUOlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E49C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v1so5516527ybo.23
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LpPrQxk+WxocYc5RQ870a7IAanT5OH+iNVgv8TZXNsM=;
        b=J870jd/En7q1MDXRl66Nhk1FzJ9MyrVnFWlGRhEuQ7bFMcIkR71uI8OJiAdGvfiNPc
         +Rw92HdWlcTOYtpBcWOzAtSC+naYbuAnwD+ifOWBpHIvg1o0CVgF8sV58P3LGq4ChuM+
         9MwGtAhokWnfXFfNvAKfct3T112HDyShprHn1xTGCKVVtmuGBLsIlU1YSsIja4vgdXmG
         UjG1eMYPLqOoAkFfWs4HyDj7kono7gOFeRR1kEyj2dCtk8QM9NjPuN52VZ4kdZl6FG8A
         ROiUyT3oyeSFoCFYXUINTktGgObRdNn1wRAvHoUlg9Y/Nqyn/vQWUPOC2hFSbNrS5185
         MaSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LpPrQxk+WxocYc5RQ870a7IAanT5OH+iNVgv8TZXNsM=;
        b=eu3o6USCzfoa436Cwv0ZO8ybBbAeIXGMrbqUIs24NNQxCVyQDfxOYIYuFMt3ZlL0t8
         7yPb783P0J8OVca0x0196A+xRuASiW+RZjXMphwR3qBPOKEi+ySwUJ3vFtkB7/cdB3zE
         VdoHij2jNMOIOC9xbGLOJyn3UG4cs1MNAsTutNKJ18x3jLBnDR6Bj2S0G0egy9TI7e7n
         gynDQLO008kmXWDUywU9FXUcUM4o6E+KJWJjSjkCvvI7lRpr1rS3A2PAy/nh9pVMdn/a
         mX9QS7Nuqps+hXooe8qmdMdckyS094kZyE/Ceo0sup1X/vt84XzDpZ7pnqw5na5abZi+
         mOEQ==
X-Gm-Message-State: AOAM531lGV0UItS2aM+SJ3qETdv0rEkiWjnFgbAIFHB1hWEohhwciqCS
        ljmfANggK6wHtocH9VeN40723s/hMX82Ew==
X-Google-Smtp-Source: ABdhPJyzBP3qgJXp9wEVsrKyZaWOFrY68C6o15LhFXI6RBf7X6BR/2ene2MW9mhf5E/EUXS2Mh8OiJct6ad0UA==
X-Received: by 2002:a25:9b87:: with SMTP id v7mr4379894ybo.416.1590072082700;
 Thu, 21 May 2020 07:41:22 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:44 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-7-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 06/22] l2tp: remove useless duplicate session detection in l2tp_netlink
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

commit af87ae465abdc070de0dc35d6c6a9e7a8cd82987 uptream.

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
2.26.2.761.g0e0b3e54be-goog

