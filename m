Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D031DDB64
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgEUX5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbgEUX5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:57:55 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EB4C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:57:54 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id n33so9681605qtd.10
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=RfoEza1y19ufsGTPwu7LC2uK6a6hRprvlCuN9g00MWI=;
        b=JloEofgNlV6s0GwxOQVJ02zKR1huXlx7WtvxenI1rd2IIrf5Y59F9gN7Gx6V4uXXC9
         OIGYGirTSOawTZuQF2Sj95D2jkx9aNB/JgHc+hod/LML0bM6UmYh7w2HjKnXgkqTAdD3
         3UwPMBzpOY9+cA1JjGoMGnXvaDJ/wvBww+k/zKTiyOMzW6WSX/mWJ/uKcb2Oo5a6DbKK
         lpEctUGw8QOcAlrh0yrLnnq4dOFnXLE/NzTfTFzuqte3a5LIr7E7ENj7tBZJp0/PGHkp
         R3YfEF9qop7Dl/FAZJtKe+5+gSNiKmCsxQIDcnN0bLjxT/3Pr4wpk1CzPcGPq5hS5lc3
         OTSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=RfoEza1y19ufsGTPwu7LC2uK6a6hRprvlCuN9g00MWI=;
        b=qDEYmI/mVxjXBgKYxDFkkKDdxK+Rejr+Vze/Lndt0bjlKxbBJvcVz/d/Q2YBxYzyQp
         on7DjM00EER1hGFJEE9KvNOpKkwXeDN+5owbN8uywmhRbnnePajO48+mte7lfkdx7OkR
         RsBQmie0r75dMh6R6RepSpAP2z1M7Wi/ZFU9z+7RNO2X4Jv4I7CawKiZiIKVR0cgk7hn
         OmgtIHxd4WNI/UuRTKmK/6fU0Oayr8ZUyx2RuHgUB+pD32tWOpLV/4U0VErAC4UgYR3q
         W/1zlyGooWTfL46FEbXUOpdf/ov+YgHyaRcTeI5tnj+INb9FwXD6B0NdXbYGSGgxvFqB
         O6uA==
X-Gm-Message-State: AOAM530KnhxNzPqqoL9p/hXUXhHPnChH+oCh1PKifINY4Byd5EAUCkNf
        N9jzY4ckQqv55ewhmMe+WXiTesQzrWqIWw==
X-Google-Smtp-Source: ABdhPJxDr+TrBML1CJ5PsKf1owl04m3NgqKdNVv9SPxcMR5TNs6ZEoYHpwvlmqWSWY6kSwfD4bT2OYMvPwZaqg==
X-Received: by 2002:a0c:fe88:: with SMTP id d8mr1220652qvs.208.1590105472744;
 Thu, 21 May 2020 16:57:52 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:13 +0100
Message-Id: <20200521235740.191338-1-gprocida@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 00/27] more l2tp locking and ordering fixes
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg.

This is for 4.4.

This is a follow-up to "l2tp locking and ordering fixes" for 4.9.

Compared with that series, this pulls in 5 more patches (the first 5
Guillaume Nault ones below) containing more of the same as well as
making later changes apply more cleanly.

As before, every commit compiles with make allmodconfig, but I have no
hardware to test this with.

9dd79945b0f8 (use IS_ENABLED) would have made one patch or so cleaner
but I didn't add it.

There are also bunch of fixes that aren't l2tp locking or ordering
fixes and I didn't add them either. For the record...

Between 4.4 and 4.9:

018f82585823 net: l2tp: fix reversed udp6 checksum flags
56cff471d0c6 l2tp: Fix the connect status check in pppol2tp_getname
286c72deabaa udp: must lock the socket in udp_disconnect()
df90e6886146 l2tp: fix lookup for sockets not bound to a device in l2tp_ip
31e2f21fb35b l2tp: fix address test in __l2tp_ip6_bind_lookup()

Between 4.9 and 4.9.latest:

000224c1106c l2tp: consider '::' as wildcard address in l2tp_ip6 socket loo=
kup
d2d74d0e58b2 l2tp: take remote address into account in l2tp_ip and l2tp_ip6=
 socket lookups
65b05d03a578 l2tp: remove configurable payload offset
b437ed583592 l2tp: Fix possible NULL pointer dereference

Regards,
Giuliano.

Asbj=C3=B8rn Sloth T=C3=B8nnesen (3):
  net: l2tp: export debug flags to UAPI
  net: l2tp: deprecate PPPOL2TP_MSG_* in favour of L2TP_MSG_*
  net: l2tp: ppp: change PPPOL2TP_MSG_* =3D> L2TP_MSG_*

Guillaume Nault (22):
  l2tp: lock socket before checking flags in connect()
  l2tp: fix racy socket lookup in l2tp_ip and l2tp_ip6 bind()
  l2tp: hold session while sending creation notifications
  l2tp: take a reference on sessions used in genetlink handlers
  l2tp: don't use l2tp_tunnel_find() in l2tp_ip and l2tp_ip6
  l2tp: remove useless duplicate session detection in l2tp_netlink
  l2tp: remove l2tp_session_find()
  l2tp: define parameters of l2tp_session_get*() as "const"
  l2tp: define parameters of l2tp_tunnel_find*() as "const"
  l2tp: initialise session's refcount before making it reachable
  l2tp: hold tunnel while looking up sessions in l2tp_netlink
  l2tp: hold tunnel while processing genl delete command
  l2tp: hold tunnel while handling genl tunnel updates
  l2tp: hold tunnel while handling genl TUNNEL_GET commands
  l2tp: hold tunnel used while creating sessions with netlink
  l2tp: prevent creation of sessions on terminated tunnels
  l2tp: pass tunnel pointer to ->session_create()
  l2tp: fix l2tp_eth module loading
  l2tp: don't register sessions in l2tp_session_create()
  l2tp: initialise l2tp_eth sessions before registering them
  l2tp: protect sock pointer of struct pppol2tp_session with RCU
  l2tp: initialise PPP sessions before registering them

R. Parameswaran (2):
  New kernel function to get IP overhead on a socket.
  L2TP:Adjust intf MTU, add underlay L3, L2 hdrs.

 Documentation/networking/l2tp.txt |   8 +-
 include/linux/net.h               |   3 +
 include/net/ipv6.h                |   2 +
 include/uapi/linux/if_pppol2tp.h  |  13 +-
 include/uapi/linux/l2tp.h         |  17 +-
 net/ipv6/datagram.c               |   4 +-
 net/l2tp/l2tp_core.c              | 181 ++++++-----------
 net/l2tp/l2tp_core.h              |  47 +++--
 net/l2tp/l2tp_eth.c               | 214 +++++++++++++--------
 net/l2tp/l2tp_ip.c                |  68 ++++---
 net/l2tp/l2tp_ip6.c               |  82 ++++----
 net/l2tp/l2tp_netlink.c           | 124 +++++++-----
 net/l2tp/l2tp_ppp.c               | 309 ++++++++++++++++++------------
 net/socket.c                      |  46 +++++
 14 files changed, 629 insertions(+), 489 deletions(-)

--=20
2.27.0.rc0.183.gde8f92d652-goog

