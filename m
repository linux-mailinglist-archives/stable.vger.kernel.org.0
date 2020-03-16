Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D57C018759C
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732810AbgCPWbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:11 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49100 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732743AbgCPWbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WIlcSuUC2sBz+C8rH47jtvYBKP5Vd2Ymob/mbW0jguo=;
        b=H8z7ND3Tr7ow7kq+6+6uoMYU9XJIQOIuqfULLroYm0B4lSC76xtFzjbIpYVbk2urETKqst
        V8plnXwbGOWC3uo3x0mzNCv9UQBzV3vILrNZoLJ2Ai6L5k1ERJAD7fLhOHt2LND7onoKwD
        44SwWdgQQ/z8lvr8IM5evWd4RSGx1gA=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.9 00/24] batman-adv: Pending fixes
Date:   Mon, 16 Mar 2020 23:30:41 +0100
Message-Id: <20200316223105.6333-1-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I was asked by Greg KH to check for missing fixes in linux 4.9.y and provide
backports for it. I've ended up with a lot more missing patches than
I've expected. Not sure why these were missing but I couldn't find them at
the moment in any stable release for 4.9.y. Feel free to check for things
which I've missed too.

Kind regards,
	Sven

Linus Lüssing (5):
  batman-adv: Fix transmission of final, 16th fragment
  batman-adv: fix TT sync flag inconsistencies
  batman-adv: Fix TT sync flags for intermediate TT responses
  batman-adv: Avoid storing non-TT-sync flags on singular entries too
  batman-adv: Fix multicast TT issues with bogus ROAM flags

Marek Lindner (1):
  batman-adv: prevent TT request storms by not sending inconsistent TT
    TLVLs

Sven Eckelmann (18):
  batman-adv: Fix double free during fragment merge error
  batman-adv: Initialize gw sel_class via batadv_algo
  batman-adv: Fix rx packet/bytes stats on local ARP reply
  batman-adv: Use default throughput value on cfg80211 error
  batman-adv: Accept only filled wifi station info
  batman-adv: Avoid spurious warnings from bat_v neigh_cmp
    implementation
  batman-adv: Always initialize fragment header priority
  batman-adv: Fix check of retrieved orig_gw in batadv_v_gw_is_eligible
  batman-adv: Fix lock for ogm cnt access in batadv_iv_ogm_calc_tq
  batman-adv: Fix internal interface indices types
  batman-adv: Avoid race in TT TVLV allocator helper
  batman-adv: Fix debugfs path for renamed hardif
  batman-adv: Fix debugfs path for renamed softif
  batman-adv: Prevent duplicated gateway_node entry
  batman-adv: Fix duplicated OGMs on NETDEV_UP
  batman-adv: Avoid free/alloc race when handling OGM2 buffer
  batman-adv: Avoid free/alloc race when handling OGM buffer
  batman-adv: Don't schedule OGM for disabled interface

 net/batman-adv/bat_iv_ogm.c            | 105 +++++++++++++----
 net/batman-adv/bat_v.c                 |  25 +++--
 net/batman-adv/bat_v_elp.c             |  10 +-
 net/batman-adv/bat_v_ogm.c             |  42 +++++--
 net/batman-adv/debugfs.c               |  40 +++++++
 net/batman-adv/debugfs.h               |  11 ++
 net/batman-adv/distributed-arp-table.c |   5 +-
 net/batman-adv/fragmentation.c         |  22 ++--
 net/batman-adv/gateway_client.c        |  11 +-
 net/batman-adv/gateway_common.c        |   5 +
 net/batman-adv/hard-interface.c        |  51 +++++++--
 net/batman-adv/originator.c            |   4 +-
 net/batman-adv/originator.h            |   4 +-
 net/batman-adv/routing.c               |   6 +
 net/batman-adv/soft-interface.c        |   1 -
 net/batman-adv/translation-table.c     | 149 ++++++++++++++++++++-----
 net/batman-adv/types.h                 |  22 +++-
 17 files changed, 414 insertions(+), 99 deletions(-)

-- 
2.20.1

