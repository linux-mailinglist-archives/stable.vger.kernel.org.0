Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665101DDB1F
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgEUXjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729657AbgEUXjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:39:45 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CD4C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:45 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id y64so9171420qkc.19
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=lsHWewZFHpVh3di2yWQfJ/v54VHWbMLTI/JuXiFkJks=;
        b=FYJqhJFFux8u7DMnpr4LSBB36k7vFiRNmS6AaTsUCEglrnW87bOmG7nAgzZRISD2Qz
         wDAVOFi2RATuMiwZ15VJ63EZgjnZBdAuzZQH2t4IAAgL2XkyA4c7sORRz/fFjErx8Gi0
         C/pF1M0EAi7v8Kjew/rkPcEG+Ip+IoRgmIHL6cklNJpMwcjQlQlMJSxPznGcQwBVnr70
         QPADB0cnCVR8tgC7ZANlPORzZeYKN4/SRA6b1+MQTaoUXIcsW7pmKxEw0SWYsH34Kvc4
         3gQWQjpnOTk7jKGc1f/GbEXrWRe8ApTOngo1UVL/k8t1kGrYsrAFvCT+q9ffVONVw4Im
         5CvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=lsHWewZFHpVh3di2yWQfJ/v54VHWbMLTI/JuXiFkJks=;
        b=Cqglr9DAQs14sPoADFShXGEUzQSWkdIXH9ANRkXiEOx4wUx0/PhJf95FMB20v0Q1Wa
         mhrhGFtofc1fvk9Yk8f7lhR5EdwCYttK6mXdp3dmZrJhIqPf14bZ9XwiGATdqcMLf/z7
         a2Q2uHyThX8zW7Hh6zy7JAkAUbtPDF3y0/VV7+Yqgdsnj6Vtol75Zl4wIqwsALhYJVZ8
         8Z5YmRw00E9BeRtxQTUHLLkGi+bykIxQw1Qb5Z1nFlsHAaNTHINgUjNPzAT6Lrr7VAwE
         dy0dtiKXX7bfeJeCmK5AaWghYwBuTrKNMl/XgTHEeMbZKpK0jL+TREnutMdf92FQxaHZ
         l9fA==
X-Gm-Message-State: AOAM531MYJfSeVgcGryF7/CEHgQLBbHBqrhskcRfjiogqwdS7hfZ+0aE
        ozGXBE10Exik1Epr3gKkCYBFmMv22Yncsg==
X-Google-Smtp-Source: ABdhPJwcXyp7+cp2PjaDL7YQ2YK8+am31powMK838M5nM1/ZikDFyFc6To0fbeNeMBqpCMXKYqWqH+XiYJhx4g==
X-Received: by 2002:a05:6214:3ee:: with SMTP id cf14mr1272683qvb.128.1590104384633;
 Thu, 21 May 2020 16:39:44 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:15 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521233937.175182-1-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 00/22] l2tp locking and ordering fixes
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

*Now with better spelling of "upstream".*

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
2.27.0.rc0.183.gde8f92d652-goog

