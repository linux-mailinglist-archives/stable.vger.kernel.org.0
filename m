Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15444C1572
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbfI2ODy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730400AbfI2ODx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:03:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEEA82082F;
        Sun, 29 Sep 2019 14:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765833;
        bh=dQ/cnZf9Znd+YlFFWEkaZQE3GjRWqEoWkhJ1EVtpsOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=He66AVuKt9gFwQ2MdNk7V3cy6ngZJ5+6mWLo7xnMUWsHAXYU+4AbXREji6Iymotya
         Fqf/sZaCafT2ou3eUF08KBWvLwKHizmjOnXjm8kHIF1ImkVQaTfwonGP2KY8nJO+WR
         FS788NYQcSP9M4ZVSHYVw1QHj9LvwRMi5z8PSyIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Sowden <jeremy@azazel.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Adam Borowski <kilobyte@angband.pl>
Subject: [PATCH 5.3 01/25] netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.
Date:   Sun, 29 Sep 2019 15:56:04 +0200
Message-Id: <20190929135007.174891957@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
References: <20190929135006.127269625@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

commit 47e640af2e492cc28778dd6f894d50313f7fba75 upstream.

nf_tables.h defines an API comprising several inline functions and
macros that depend on the nft member of struct net.  However, this is
only defined is CONFIG_NF_TABLES is enabled.  Added preprocessor checks
to ensure that nf_tables.h will compile if CONFIG_NF_TABLES is disabled.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://lore.kernel.org/netfilter-devel/20190920094925.aw7actk4tdnk3rke@salvia/T/
Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Reported-by: Adam Borowski <kilobyte@angband.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netfilter/nf_tables.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1206,6 +1206,8 @@ void nft_trace_notify(struct nft_tracein
 #define MODULE_ALIAS_NFT_OBJ(type) \
 	MODULE_ALIAS("nft-obj-" __stringify(type))
 
+#if IS_ENABLED(CONFIG_NF_TABLES)
+
 /*
  * The gencursor defines two generations, the currently active and the
  * next one. Objects contain a bitmask of 2 bits specifying the generations
@@ -1279,6 +1281,8 @@ static inline void nft_set_elem_change_a
 	ext->genmask ^= nft_genmask_next(net);
 }
 
+#endif /* IS_ENABLED(CONFIG_NF_TABLES) */
+
 /*
  * We use a free bit in the genmask field to indicate the element
  * is busy, meaning it is currently being processed either by


