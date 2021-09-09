Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEB2405942
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 16:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242856AbhIIOlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 10:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242097AbhIIOl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 10:41:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DABC066417;
        Thu,  9 Sep 2021 07:03:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mOKea-0003xf-2x; Thu, 09 Sep 2021 16:03:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     stable@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10.y 0/3] netfilter: nf_tables fixes for 5.10.y
Date:   Thu,  9 Sep 2021 16:03:34 +0200
Message-Id: <20210909140337.29707-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

please consider applying these nf_tables fixes to the 5.10.y tree.
These patches had to mangled to make them apply to 5.10.y.

I've done the follwoing tests in a kasan/kmemleak enabled vm:
1. run upstream nft python/shell tests.
   Without patch 2 and 3 doing so results in kernel crash.
   Some tests fail but afaics those are expected to
   fail on 5.10 due to lack of feature being tested.
2. Tested the 'conncount' feature (its affected by last patch).
   Worked as designed.
3. ran nftables related kernel self tests.

No kmemleak or kasan splats were seen.

Eric Dumazet (1):
  netfilter: nftables: avoid potential overflows on 32bit arches

Pablo Neira Ayuso (2):
  netfilter: nf_tables: initialize set before expression setup
  netfilter: nftables: clone set element expression template

 net/netfilter/nf_tables_api.c | 89 ++++++++++++++++++++++-------------
 net/netfilter/nft_set_hash.c  | 10 ++--
 2 files changed, 62 insertions(+), 37 deletions(-)

-- 
2.32.0

