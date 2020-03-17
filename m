Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0280F1891F0
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgCQX1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:43 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53410 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgCQX1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JVstoYuTmqPHzfAEF9FOVbIpuIEq7KLQExJ6UkvGE1Y=;
        b=I4QxQHrhrbYJoAqafHth7LXUXj2Mo+CPUXIvVBp1Rd2JZsMAa0KOvkW6wERhZyEawGlViZ
        co5hY9LT3Ip+ScQCMSuv9yklNYSMW6vNqet2n87+2EXtkDHeG/QAuzXjZHGL1+/1WhmuO5
        AOH+nyEebDT8FNia8NzwS+64S0ZkPYQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.4 00/48] batman-adv: Pending fixes
Date:   Wed, 18 Mar 2020 00:26:46 +0100
Message-Id: <20200317232734.6127-1-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

we were asked by Greg KH to check the failed backport of some recent fix to
linux 4.4.y and provide backports for it when required. I've found a lot more
missing patches than I've expected in this process and queued them up here.

Kind regards,
	Sven

Andrew Lunn (1):
  batman-adv: Avoid endless loop in bat-on-bat netdevice check

Florian Westphal (1):
  batman-adv: fix skb deref after free

Linus Lüssing (5):
  batman-adv: Avoid duplicate neigh_node additions
  batman-adv: Fix transmission of final, 16th fragment
  batman-adv: fix TT sync flag inconsistencies
  batman-adv: Fix TT sync flags for intermediate TT responses
  batman-adv: Avoid storing non-TT-sync flags on singular entries too

Marek Lindner (2):
  batman-adv: init neigh node last seen field
  batman-adv: prevent TT request storms by not sending inconsistent TT
    TLVLs

Matthias Schiffer (1):
  batman-adv: update data pointers after skb_cow()

Simon Wunderlich (1):
  batman-adv: lock crc access in bridge loop avoidance

Sven Eckelmann (37):
  batman-adv: Fix invalid read while copying bat_iv.bcast_own
  batman-adv: Only put gw_node list reference when removed
  batman-adv: Only put orig_node_vlan list reference when removed
  batman-adv: Fix unexpected free of bcast_own on add_if error
  batman-adv: Fix integer overflow in batadv_iv_ogm_calc_tq
  batman-adv: Deactivate TO_BE_ACTIVATED hardif on shutdown
  batman-adv: Drop reference to netdevice on last reference
  batman-adv: Fix reference counting of vlan object for tt_local_entry
  batman-adv: Fix use-after-free/double-free of tt_req_node
  batman-adv: Fix ICMP RR ethernet access after skb_linearize
  batman-adv: Clean up untagged vlan when destroying via rtnl-link
  batman-adv: Avoid nullptr dereference in bla after vlan_insert_tag
  batman-adv: Avoid nullptr dereference in dat after vlan_insert_tag
  batman-adv: Fix orig_node_vlan leak on orig_node_release
  batman-adv: Fix non-atomic bla_claim::backbone_gw access
  batman-adv: Fix reference leak in batadv_find_router
  batman-adv: Free last_bonding_candidate on release of orig_node
  batman-adv: Fix speedy join in gateway client mode
  batman-adv: Add missing refcnt for last_candidate
  batman-adv: Fix double free during fragment merge error
  batman-adv: Fix rx packet/bytes stats on local ARP reply
  batman-adv: Fix lock for ogm cnt access in batadv_iv_ogm_calc_tq
  batman-adv: Fix internal interface indices types
  batman-adv: Fix skbuff rcsum on packet reroute
  batman-adv: Avoid race in TT TVLV allocator helper
  batman-adv: Fix debugfs path for renamed hardif
  batman-adv: Fix debugfs path for renamed softif
  batman-adv: Prevent duplicated gateway_node entry
  batman-adv: Prevent duplicated nc_node entry
  batman-adv: Prevent duplicated global TT entry
  batman-adv: Prevent duplicated tvlv handler
  batman-adv: Reduce claim hash refcnt only for removed entry
  batman-adv: Reduce tt_local hash refcnt only for removed entry
  batman-adv: Reduce tt_global hash refcnt only for removed entry
  batman-adv: Only read OGM tvlv_len after buffer len check
  batman-adv: Avoid free/alloc race when handling OGM buffer
  batman-adv: Don't schedule OGM for disabled interface

 net/batman-adv/bat_iv_ogm.c            | 115 +++++++++---
 net/batman-adv/bridge_loop_avoidance.c | 152 ++++++++++++---
 net/batman-adv/debugfs.c               |  40 ++++
 net/batman-adv/debugfs.h               |  11 ++
 net/batman-adv/distributed-arp-table.c |  15 +-
 net/batman-adv/fragmentation.c         |  14 +-
 net/batman-adv/gateway_client.c        |  18 +-
 net/batman-adv/hard-interface.c        |  89 +++++++--
 net/batman-adv/hard-interface.h        |   6 +-
 net/batman-adv/main.c                  |   8 +-
 net/batman-adv/network-coding.c        |  33 ++--
 net/batman-adv/originator.c            |  26 ++-
 net/batman-adv/originator.h            |   4 +-
 net/batman-adv/routing.c               | 111 ++++++++---
 net/batman-adv/send.c                  |   4 +-
 net/batman-adv/soft-interface.c        |   9 +
 net/batman-adv/translation-table.c     | 249 +++++++++++++++++--------
 net/batman-adv/types.h                 |  23 ++-
 18 files changed, 707 insertions(+), 220 deletions(-)

-- 
2.20.1

