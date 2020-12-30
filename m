Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74282E7C24
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 20:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgL3TeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 14:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgL3TeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 14:34:09 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6C4C061573
        for <stable@vger.kernel.org>; Wed, 30 Dec 2020 11:33:29 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id i13so10178804qtp.10
        for <stable@vger.kernel.org>; Wed, 30 Dec 2020 11:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=Peklck7CpZfpOJe5mcdE2/1Il42gpzTGlciMeCYVkQc=;
        b=eHJEDgRB760zzarnKmPRov656PGVbvO87zvizcTd+tI5cIrMr4u27OIT1TqfZMC2pk
         z9F4M0OeOK6OkZFpnK8wxXsZXyY0nrDmQO743UEL8eMH+vQAsFTRo23NZfv+feMxPMiW
         8RiMLjfymxDGOednh/g3Yox8olFkIc1tfe+R/mf7DRsiTCu3nJzJzgqTV/6i/J6V3T5z
         akWo95ZaeOJTnnPaYmOLU1dNbaQ1dcxsXNJ8ZXRF3uEgyiBSw23KDi5SiPKFmQDzPB8V
         kjGhtIILgyjVm8P/L8QHlTay3h5rFKpNj4m5mVNId8KrMV79M6wl6kw/4q7id+JVF2En
         I+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=Peklck7CpZfpOJe5mcdE2/1Il42gpzTGlciMeCYVkQc=;
        b=P9c7QwFz3Y+epe3B1h04HVDDviT+qLiwBE9I62u1v0ns6rpZsz1JU9yblyJNGBZcDd
         0UlqaG+IQbayelKuO3hdv7039FhdQrQ8jRCv34HhehAgmdjZt9hBF2wvJMyqdNOlA0JB
         /la8bSorhAaZ1yicW2g4bmLHIYF2VyN+OkHZZtxYs6cMYtzkERbN7i5mv7a2/iJp4xmM
         bDJQunqdcl6LpvW9MyeaS7gYB0PLRDe0uksqzUr3/mdcYSxS+bEONuBc+rt1QDkCIn8A
         yb3R7a1Xe3tdaBwukPieNXYcj5VluiQ6BdR45iPXhjnfzWWNg6XR/wHJrFmAj+aJvCQU
         B8rw==
X-Gm-Message-State: AOAM533LtJkD8Z0akEWBbY8XuRe+7HDz6ONmBy8kB84fdHTXWbXlxiCj
        QTarX++QitoY6sxToGr9In7EO4ppgW4=
X-Google-Smtp-Source: ABdhPJyZQKOiomQ75SpVNSr5ZewCA78kGKJuOPKBWw9IYwuL2cmXH0CJv0oMbJ4do8/S+v3OrvnKBm7zG38=
Sender: "surenb via sendgmr" <surenb@surenb1.mtv.corp.google.com>
X-Received: from surenb1.mtv.corp.google.com ([100.98.240.136]) (user=surenb
 job=sendgmr) by 2002:a05:6214:1266:: with SMTP id r6mr57692657qvv.12.1609356808361;
 Wed, 30 Dec 2020 11:33:28 -0800 (PST)
Date:   Wed, 30 Dec 2020 11:33:21 -0800
Message-Id: <20201230193323.2133009-1-surenb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 0/2] backports for slab-out-of-bounds issue in ip6_xmit()
From:   Suren Baghdasaryan <surenb@google.com>
To:     surenb@google.com
Cc:     pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We received a slab-out-of-bounds report in ip6_xmit() for KASAN build on 4.9
kernel. The patches that fix this issue have been backported to to stable 4.14
and one of them even to 3.16 but 4.9 stable branch does not include them.
Backport to linux-4.9.y required trivial merge conflict resolution. They
cleanly apply to linux-stable linux-4.9.y branch tagged v4.9.249.

Paolo Abeni (2):
  net: ipv6: keep sk status consistent after datagram connect failure
  l2tp: fix races with ipv4-mapped ipv6 addresses

 net/ipv6/datagram.c  | 21 +++++++++++++++++----
 net/l2tp/l2tp_core.c | 38 ++++++++++++++++++--------------------
 net/l2tp/l2tp_core.h |  3 ---
 3 files changed, 35 insertions(+), 27 deletions(-)

-- 
2.29.2.729.g45daf8777d-goog

