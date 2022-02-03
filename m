Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B29F4A83F2
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 13:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbiBCMmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 07:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiBCMmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 07:42:05 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6CFC061714;
        Thu,  3 Feb 2022 04:42:05 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nFbR5-0000XM-Ky; Thu, 03 Feb 2022 13:42:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <stable@vger.kernel.org>
Cc:     <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH 4.14.y 0/2] netfilter: nat: fix soft lockup when most ports are used
Date:   Thu,  3 Feb 2022 13:41:53 +0100
Message-Id: <20220203124155.16693-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

First patch removes old rovers, they are inherently racy
and cause packet drops/delays.

Second patch avoids iterating entire range of ports: It takes way
too long when most tuples are in use.

First patch is slightly mangled; nf_nat_proto_common.c needs minor adjustment
in context.

Florian Westphal (2):
  netfilter: nat: remove l4 protocol port rovers
  netfilter: nat: limit port clash resolution attempts

 include/net/netfilter/nf_nat_l4proto.h |  2 +-
 net/netfilter/nf_nat_proto_common.c    | 36 ++++++++++++++++++--------
 net/netfilter/nf_nat_proto_dccp.c      |  5 +---
 net/netfilter/nf_nat_proto_sctp.c      |  5 +---
 net/netfilter/nf_nat_proto_tcp.c       |  5 +---
 net/netfilter/nf_nat_proto_udp.c       | 10 ++-----
 6 files changed, 31 insertions(+), 32 deletions(-)

-- 
2.34.1

