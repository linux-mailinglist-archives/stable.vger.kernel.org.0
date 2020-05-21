Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1BF1DDB67
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgEUX6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:01 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32088C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:00 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v6so9280255qkh.7
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mJgEjWomeKju0JzVX7y/k1in+JffRXKgCUSin9ZeegY=;
        b=KxpPr8AG30vqYwqJMZsyFyDDQwg7RS5hmcFV9gZ0rf/hXorlQsLPQ9RvWI2M5kqbOK
         X2mYdLcgD5V24sAZuNjfc9CsoUfs14m1KuX/gaBvC/a9tYKVRQM8rQBq6aW5wiwEc536
         XsPPVyNUvIYeoR6nHSLqY8zUfkl1klw+KZmJzt5wS/6oMwlwQ97K94UexFmI2c3IlToL
         14tBwH3LfutN7h6tBHSrv9jZrye8rnxanDzOaTjerWn6p6uPPqmXbf2kv7BgdPZ1p7Lj
         0IdELwtr6XsFf8AwmJWuwK3tG+7Tfu35G/nIagIsOFyAPShcTfYQaNpfxL6kjEsZJSK6
         JnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mJgEjWomeKju0JzVX7y/k1in+JffRXKgCUSin9ZeegY=;
        b=ZGGJPO0p8E5Sn6lhkWUfcWsizbYsPTvGloENfIirf7pG5BC8B4R1V6tTrguqtQyTcp
         ZgqRJ5j1sGrS8zEMzI4QU6zaFA9+Qy1tqGhoX+EC67HHFRGWgBrByfMJKcxJZZ6zHGxO
         MDy2mc4bScqAWhKm1p8hvhTAZ4VSGNcuPCdqEwr8E/Vmt5cqMeqsIW/GoD6Gy0vrpyVw
         N3i810+ckpOZ42vLIF5LQCs7mYlPMi1taA7ZKmJxINCQfiRfNF/vmYXS4fjehnwwtCzy
         KbTPA9/qQ1ySqqoicU/fQHaMpcSsnuF9aL6+fHtMbR79z4b+4WNGxvb1FNYTXxC63Yg3
         EdDA==
X-Gm-Message-State: AOAM530PZfrtgfyc/RQLNWn7lkQ6axI6wsAx+APiImPF30G14ebaEDqF
        7Ce4zc5B6JNO9tON/HvXHBrIfdegV5CEzA==
X-Google-Smtp-Source: ABdhPJyDXxE4UON09Z1fwhOZ7JjVdRmwyX5xXJBgdiMEAlKK6ihhghuR35Z32ijvE0gG1GeazlaMGaDdppLGYg==
X-Received: by 2002:ad4:466f:: with SMTP id z15mr1284082qvv.101.1590105479340;
 Thu, 21 May 2020 16:57:59 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:16 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-4-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 03/27] l2tp: hold session while sending creation notifications
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Amit Pundir <amit.pundir@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit 5e6a9e5a3554a5b3db09cdc22253af1849c65dff upstream.

l2tp_session_find() doesn't take any reference on the returned session.
Therefore, the session may disappear while sending the notification.

Use l2tp_session_get() instead and decrement session's refcount once
the notification is sent.

Backporting Notes

This is a backport of a backport.

Fixes: 33f72e6f0c67 ("l2tp : multicast notification to the registered listeners")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index fb3248ff8b48..43f0af1c4697 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -626,10 +626,12 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 			session_id, peer_session_id, &cfg);
 
 	if (ret >= 0) {
-		session = l2tp_session_find(net, tunnel, session_id);
-		if (session)
+		session = l2tp_session_get(net, tunnel, session_id, false);
+		if (session) {
 			ret = l2tp_session_notify(&l2tp_nl_family, info, session,
 						  L2TP_CMD_SESSION_CREATE);
+			l2tp_session_dec_refcount(session);
+		}
 	}
 
 out:
-- 
2.27.0.rc0.183.gde8f92d652-goog

