Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D94B25AC8C
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 16:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgIBOHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 10:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgIBOGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 10:06:15 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F003C06125F
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 07:06:00 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id i26so6791985ejb.12
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 07:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IVTgojsctywPYI2BEUQy4+C3blLe36Gj3Nv25ImuhV0=;
        b=FSIxk/zEZcpRBi4QeA27pDHb8zta0fipi9M8oPao1vJqAKMQ1Nl/wY9iDXfn1qg2Fn
         3UzMUKmDfog2N0nFQFUL8HycGnQzav+odJ5MCnGUhFKd9cqqptqDs2imsEN+lhkdbZTY
         8DUfRu8NVnHHcWzgCsG3q9M/qsy7Nor83MI52S49iunbpGDDKQKOgmlKaXPdapwOZiYv
         +30SxmXGZiQu7iHS91xxpfNmqBsUn45yyH69fICZeoJDP6QxBGSFjkVZDFsYOhDaS9i3
         8loKeLHqNqi8NEveRFmFHKR36is9Pr11uHTNiAQLWDxhzlG+TnHfT5gLFW9PLeB3aatg
         M8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IVTgojsctywPYI2BEUQy4+C3blLe36Gj3Nv25ImuhV0=;
        b=APlouZh1NKS27oflr4u+c5gvWgEAUjcefMM8psivHnyPNnYDgXMjL6ywND/iNsoyG8
         cFiYlbYyvz6B6CS5LmW05LndxIOzNrnxGpy70uGviEqSDFVwGCTHnDd23a+S1Sg5UlmA
         iSDnsoti0Y32wdGQCpMbaUpGOHt/mCnj1K0OhYjLMzXu8FRdT2SAoXA+6wktyJW67zpi
         slAcyF6ZFDrSOBG4R7rVS5NRjHHxE1WdIaPm6LAOZz+Ek5MukmtpbgzWC5Jlz1nicMVW
         W+EGh+mz4B/NlsVQK01pQFOJYxmEybG6wjKZbNPsXEB2amE1750pS/prkZlLPqkLCvKT
         8vdw==
X-Gm-Message-State: AOAM530VtOo7/7lQYQGgooz9q6P+GHouZHf83jt6//Dny5ZMevY78sJe
        KdQc9s2HLysClpgHGNXoKxop4A==
X-Google-Smtp-Source: ABdhPJzvECs35eFjMsTYjZyxiCkatxfda7vl17SgvZwSIAVXMCxivw1u4HfLCZBNieZxqOzgVR4r9g==
X-Received: by 2002:a17:906:5206:: with SMTP id g6mr199229ejm.292.1599055559289;
        Wed, 02 Sep 2020 07:05:59 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw14oqa3w7cibjsc.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:8cba:3abe:17e1:aaec])
        by smtp.gmail.com with ESMTPSA id r15sm4119296edv.94.2020.09.02.07.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 07:05:58 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        matthieu.baerts@tessares.net, davem@davemloft.net,
        Tim Froidcoeur <tim.froidcoeur@tessares.net>
Subject: [PATCH 4.9 2/2] net: initialize fastreuse on inet_inherit_port
Date:   Wed,  2 Sep 2020 16:05:45 +0200
Message-Id: <20200902140545.867718-3-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200902140545.867718-1-tim.froidcoeur@tessares.net>
References: <20200902140545.867718-1-tim.froidcoeur@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d76f3351cea2d927fdf70dd7c06898235035e84e ]

In the case of TPROXY, bind_conflict optimizations for SO_REUSEADDR or
SO_REUSEPORT are broken, possibly resulting in O(n) instead of O(1) bind
behaviour or in the incorrect reuse of a bind.

the kernel keeps track for each bind_bucket if all sockets in the
bind_bucket support SO_REUSEADDR or SO_REUSEPORT in two fastreuse flags.
These flags allow skipping the costly bind_conflict check when possible
(meaning when all sockets have the proper SO_REUSE option).

For every socket added to a bind_bucket, these flags need to be updated.
As soon as a socket that does not support reuse is added, the flag is
set to false and will never go back to true, unless the bind_bucket is
deleted.

Note that there is no mechanism to re-evaluate these flags when a socket
is removed (this might make sense when removing a socket that would not
allow reuse; this leaves room for a future patch).

For this optimization to work, it is mandatory that these flags are
properly initialized and updated.

When a child socket is created from a listen socket in
__inet_inherit_port, the TPROXY case could create a new bind bucket
without properly initializing these flags, thus preventing the
optimization to work. Alternatively, a socket not allowing reuse could
be added to an existing bind bucket without updating the flags, causing
bind_conflict to never be called as it should.

Call inet_csk_update_fastreuse when __inet_inherit_port decides to create
a new bind_bucket or use a different bind_bucket than the one of the
listen socket.

Fixes: 093d282321da ("tproxy: fix hash locking issue when using port redirection in __inet_inherit_port()")
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
---
 net/ipv4/inet_hashtables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 4bf542f4d980..887633870763 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -163,6 +163,7 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
 				return -ENOMEM;
 			}
 		}
+		inet_csk_update_fastreuse(tb, child);
 	}
 	inet_bind_hash(child, tb, port);
 	spin_unlock(&head->lock);
-- 
2.25.1

