Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF2D1DD03C
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgEUOlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgEUOlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:10 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F404C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:10 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id n33so7885111qtd.10
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=6k14IwnWz9IUoxJi19PZH1jdwcO49hAgm7GG1yHzFMU=;
        b=rsRZw8yzTeJsbaswmpyeBE+LuI1+i8uAJ7HqXFK4ZFDC1L5SzMxcyX5v06VJYyE18i
         YgGliRFROPMigqGF9HL0QDMCfX6K+shvUNBc2uaeOFc+yYsNTMB0Nh6RdL22GlBdNuB3
         puk7vgKejG9FTNS8+JPJtIghzHLRE4T2pRkJJIUn7WSQzXgHBdMwIshtvEsuVVlo/Jet
         LyfQlZPt42IxhGBK88Xbqtw8GWYsuvwY4DT+IQdqwrTfBYy4qVgwicPboqG8fK2mwL7R
         OPcHhBifsLO0HKkomAd8T8I/CLaAlpTZh+UgovLAwvmkKqyIPp1heoNy/0Y8VXwwE4Fz
         vBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=6k14IwnWz9IUoxJi19PZH1jdwcO49hAgm7GG1yHzFMU=;
        b=nbGeWVT6TMpltP2H8PJdFkSHQSYgsx9HWWUQQFoaham/U7tLdUFlmcQIiozPdVC2LH
         fYUmRDgRLCgK/51PjzO7S6t9svxvxigvv4ngdWliB9Im8HtR96L6zFuuDo7i3/67I/pB
         y/Qsd2EXqRhBLdPwcMa7coOlFWv8/P46Eu/cQ1lGjePDzjdo4fn8eDohjKz9HOHncHZd
         f2DhoLgVHWE+xMI7BIHz66w8bHc4zcQRAJ8qia68mqspLxIqFv+6yLiP2wkH+a7+AzbY
         no4mZth4/LpER6SmRJly1dHtvg7ir4gGKF8VLozfggmwX1rnmIWg0+ukISmVImt9ZSlR
         NQbg==
X-Gm-Message-State: AOAM531k3r9TPAXOKeyxCTzt9PcGIFuGo4j8IKQ7SEnaioCv4dHtcb2g
        4e/ETmMK66fyXf86dUB1xWOwecxtDl1UeQ==
X-Google-Smtp-Source: ABdhPJwGv8sKIcu+imxbH/orWJh1ewr6kmXJnB657rQ/i10HAKCXp76wWkaDCequxsuZ3S7M5z+GvSuv70nTig==
X-Received: by 2002:ad4:5684:: with SMTP id bc4mr10537193qvb.85.1590072069719;
 Thu, 21 May 2020 07:41:09 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:38 +0100
Message-Id: <20200521144100.128936-1-gprocida@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 00/22] l2tp locking and ordering fixes
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

This is for 4.9.

This is a follow-up to "fix l2tp use-after-free in pppol2tp_sendmsg"
for 4.14. Pulling on the thread pulled in many other earlier locking
fixes in between 4.9 and 4.14.

I've done some minor rework on a few of these to avoid pulling in
refcount as a replacement for atomic which would have meant 10+ more
patches (I still had compilation errors at 10).

Some minor other patch commutation was needed and where it wasn't
completely trivial, I've added a note to the commit messages.

The series does include a few non-fixes, but they look safe and mean
that the fixes (and other backports) apply more cleanly.

Regards,
Giuliano.

Asbj=C3=B8rn Sloth T=C3=B8nnesen (3):
  net: l2tp: export debug flags to UAPI
  net: l2tp: deprecate PPPOL2TP_MSG_* in favour of L2TP_MSG_*
  net: l2tp: ppp: change PPPOL2TP_MSG_* =3D> L2TP_MSG_*

Guillaume Nault (17):
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
 include/uapi/linux/if_pppol2tp.h  |  13 +-
 include/uapi/linux/l2tp.h         |  17 +-
 net/l2tp/l2tp_core.c              | 174 ++++++-----------
 net/l2tp/l2tp_core.h              |  46 +++--
 net/l2tp/l2tp_eth.c               | 214 +++++++++++++--------
 net/l2tp/l2tp_netlink.c           |  79 ++++----
 net/l2tp/l2tp_ppp.c               | 309 ++++++++++++++++++------------
 net/socket.c                      |  46 +++++
 10 files changed, 516 insertions(+), 393 deletions(-)

--=20
2.26.2.761.g0e0b3e54be-goog

