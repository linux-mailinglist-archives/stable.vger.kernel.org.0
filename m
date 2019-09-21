Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E29B9D86
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 13:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407497AbfIULFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 07:05:31 -0400
Received: from kadath.azazel.net ([81.187.231.250]:59676 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407499AbfIULFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 07:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oTYzKmLCbhjNQvlwj09BIgb0blu6z/+b5YJM1oAt/R4=; b=OZR0YIZ943L8wpJgP+B8sqEyPR
        87TgkGfZelOuApD1BjMI+Qm0dzJczEk3TuNK1RNmXaEwYWgvFe5DSkizoqoANwBWCdeKlSmsmJqY7
        kTkpp5zaz2kDlKxMpKC41OuvsY75yv0qLwwr+CGCNwp7Oan/AA0TvMrIWjMGaVwH/qjSDva0y/bY6
        ojsvwpvmq1XrRizQKe+LgDnT2bJHnm0VdBDnDZ2+74sbgjDJrVUSputMjn/kA6GRY5BAPi6j6AMMs
        rS4frwOZbkmCzalG4yaEAHa3HBda6nhCqFZRLQ2/kL09+hx9fMfZgy9lu9R6ReEFlg3Ks9Q9ea5oY
        4OKzciQQ==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iBdCd-0007fj-D6; Sat, 21 Sep 2019 12:05:23 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Adam Borowski <kilobyte@angband.pl>
Subject: [PATCH 1/1] netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.
Date:   Sat, 21 Sep 2019 12:05:23 +0100
Message-Id: <20190921110523.15085-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190921110523.15085-1-jeremy@azazel.net>
References: <20190921110523.15085-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

nf_tables.h defines an API comprising several inline functions and
macros that depend on the nft member of struct net.  However, this is
only defined is CONFIG_NF_TABLES is enabled.  Added preprocessor checks
to ensure that nf_tables.h will compile if CONFIG_NF_TABLES is disabled.

(cherry picked from commit 47e640af2e492cc28778dd6f894d50313f7fba75)

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Reported-by: Adam Borowski <kilobyte@angband.pl>
Link: https://lore.kernel.org/netfilter-devel/20190920094925.aw7actk4tdnk3rke@salvia/T/
Cc: stable@vger.kernel.org
---
 include/net/netfilter/nf_tables.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 475d6f28ca67..7f7a4d9137e5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1206,6 +1206,8 @@ void nft_trace_notify(struct nft_traceinfo *info);
 #define MODULE_ALIAS_NFT_OBJ(type) \
 	MODULE_ALIAS("nft-obj-" __stringify(type))
 
+#if IS_ENABLED(CONFIG_NF_TABLES)
+
 /*
  * The gencursor defines two generations, the currently active and the
  * next one. Objects contain a bitmask of 2 bits specifying the generations
@@ -1279,6 +1281,8 @@ static inline void nft_set_elem_change_active(const struct net *net,
 	ext->genmask ^= nft_genmask_next(net);
 }
 
+#endif /* IS_ENABLED(CONFIG_NF_TABLES) */
+
 /*
  * We use a free bit in the genmask field to indicate the element
  * is busy, meaning it is currently being processed either by
-- 
2.23.0

