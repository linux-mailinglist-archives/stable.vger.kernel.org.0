Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA3C457E46
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 13:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbhKTMnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 07:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhKTMnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 07:43:10 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F92EC061574
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 04:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1637412006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qLLq3fj17J46k64ugYLdpOib5/vxhkCELZ10FySSXSw=;
        b=xG2R9qv8bGF/CTNE6S8dXRfpVg4QajF99KEs4aMixdkERi6Ah1wgMl3MH7LJjpUY18jvHe
        80hAcYrKMi8G6KgIORCYcHK3mvHCL72Kq1RzDz/SoP+ei0IwV/3HHBdE0Q67lLGKO7jrQ5
        RC8krL2j37dfd7cFPYHgoLftV/TnCM0=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.9 0/7] batman-adv: Fixes for stable/linux-4.9.y
Date:   Sat, 20 Nov 2021 13:39:51 +0100
Message-Id: <20211120123958.260826-1-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I went through  all changes in batman-adv since v4.9 with a Fixes: line
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

Linus Lüssing (3):
  batman-adv: Fix own OGM check in aggregated OGMs
  batman-adv: mcast: fix duplicate mcast packets in BLA backbone from
    LAN
  batman-adv: mcast: fix duplicate mcast packets from BLA backbone to
    mesh

Sven Eckelmann (4):
  batman-adv: Keep fragments equally sized
  batman-adv: Consider fragmentation for needed_headroom
  batman-adv: Reserve needed_*room for fragments
  batman-adv: Don't always reallocate the fragmentation skb head

 net/batman-adv/bat_v_ogm.c             |  11 +--
 net/batman-adv/bridge_loop_avoidance.c | 103 +++++++++++++++++++++----
 net/batman-adv/fragmentation.c         |  42 ++++++----
 net/batman-adv/hard-interface.c        |   3 +
 net/batman-adv/multicast.c             |  31 ++++++++
 net/batman-adv/multicast.h             |  15 ++++
 net/batman-adv/soft-interface.c        |   5 +-
 7 files changed, 172 insertions(+), 38 deletions(-)

-- 
2.30.2

