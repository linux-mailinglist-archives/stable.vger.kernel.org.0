Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6A0457E38
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 13:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhKTMmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 07:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhKTMmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 07:42:47 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F010BC061574
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 04:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1637411980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qIZ4ceWhobrZ6dhjhEaCuwWdHu5EaAIxG28AL/vsizY=;
        b=DYqfkyaiUM/9LdZVw01GhURx7Pqzo3TIhAA6eKkvPJcQDnhDcFMrdumIkLll8RsUlujt5F
        bXBkwrxzyBmDQQ3CtMzYWEoLNhL0wbLlH/SNtkYhpqZHMB8rWflSJWfRx4L7qkHQn9WHzX
        NAGAww2zJam1IHrjQQXpM2cVrAy0L/o=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.4 00/11] batman-adv: Fixes for stable/linux-4.4.y
Date:   Sat, 20 Nov 2021 13:39:28 +0100
Message-Id: <20211120123939.260723-1-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I went through  all changes in batman-adv since v4.4 with a Fixes: line
and checked whether they were backported to the LTS kernels. The ones which
weren't ported and applied to this branch are now part of this patch series.

There are also following three patches included:

* batman-adv: Consider fragmentation for needed_headroom
* batman-adv: Reserve needed_*room for fragments
* batman-adv: Don't always reallocate the fragmentation skb head

which could in some circumstances cause packet loss but which were created
to fix high CPU load/low throughput problems. But I've added them here
anyway because the corresponding VXLAN patches were also added to stable.
And some stable kernels also got these fixes a while back.

Kind regards,
	Sven

Linus Lüssing (4):
  batman-adv: Fix multicast TT issues with bogus ROAM flags
  batman-adv: mcast: fix duplicate mcast packets in BLA backbone from
    LAN
  batman-adv: mcast: fix duplicate mcast packets in BLA backbone from
    mesh
  batman-adv: mcast: fix duplicate mcast packets from BLA backbone to
    mesh

Sven Eckelmann (6):
  batman-adv: Keep fragments equally sized
  batman-adv: Prevent duplicated softif_vlan entry
  batman-adv: Consider fragmentation for needed_headroom
  batman-adv: Reserve needed_*room for fragments
  batman-adv: Don't always reallocate the fragmentation skb head
  batman-adv: Avoid WARN_ON timing related checks

Taehee Yoo (1):
  batman-adv: set .owner to THIS_MODULE

 net/batman-adv/bat_iv_ogm.c            |   4 +-
 net/batman-adv/bridge_loop_avoidance.c | 133 ++++++++++++++++++++-----
 net/batman-adv/bridge_loop_avoidance.h |   4 +-
 net/batman-adv/debugfs.c               |   1 +
 net/batman-adv/fragmentation.c         |  41 +++++---
 net/batman-adv/hard-interface.c        |   3 +
 net/batman-adv/multicast.c             |  31 ++++++
 net/batman-adv/multicast.h             |  15 +++
 net/batman-adv/soft-interface.c        |  31 +++---
 net/batman-adv/translation-table.c     |   6 +-
 10 files changed, 215 insertions(+), 54 deletions(-)

-- 
2.30.2

