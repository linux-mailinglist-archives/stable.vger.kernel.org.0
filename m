Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC70664A185
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiLLNla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiLLNk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:40:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203CDF63
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B09C160FF4
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0329C433D2;
        Mon, 12 Dec 2022 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852422;
        bh=HOzQOaRlNRpnntPjHChD7SVN+LVU6XUuHb9C2d9Eg88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jM4wnIbxGxbB2lWZdYS185v+D9T9xtHDEjZb6f64OBZ+Tc15IRZlrlEKCnbwauJt
         jvaFhHqUO+CbcBhruX/ZGEATvmf+21BntBQrpjkJrGYw3AzDdjsomaTnqbet2banr9
         khR6KQt/oCwkwUcX/T9R71D9h40PHDWCMrS4swHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.0 077/157] net: dsa: sja1105: avoid out of bounds access in sja1105_init_l2_policing()
Date:   Mon, 12 Dec 2022 14:17:05 +0100
Message-Id: <20221212130937.822199856@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radu Nicolae Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>

commit f8bac7f9fdb0017b32157957ffffd490f95faa07 upstream.

The SJA1105 family has 45 L2 policing table entries
(SJA1105_MAX_L2_POLICING_COUNT) and SJA1110 has 110
(SJA1110_MAX_L2_POLICING_COUNT). Keeping the table structure but
accounting for the difference in port count (5 in SJA1105 vs 10 in
SJA1110) does not fully explain the difference. Rather, the SJA1110 also
has L2 ingress policers for multicast traffic. If a packet is classified
as multicast, it will be processed by the policer index 99 + SRCPORT.

The sja1105_init_l2_policing() function initializes all L2 policers such
that they don't interfere with normal packet reception by default. To have
a common code between SJA1105 and SJA1110, the index of the multicast
policer for the port is calculated because it's an index that is out of
bounds for SJA1105 but in bounds for SJA1110, and a bounds check is
performed.

The code fails to do the proper thing when determining what to do with the
multicast policer of port 0 on SJA1105 (ds->num_ports = 5). The "mcast"
index will be equal to 45, which is also equal to
table->ops->max_entry_count (SJA1105_MAX_L2_POLICING_COUNT). So it passes
through the check. But at the same time, SJA1105 doesn't have multicast
policers. So the code programs the SHARINDX field of an out-of-bounds
element in the L2 Policing table of the static config.

The comparison between index 45 and 45 entries should have determined the
code to not access this policer index on SJA1105, since its memory wasn't
even allocated.

With enough bad luck, the out-of-bounds write could even overwrite other
valid kernel data, but in this case, the issue was detected using KASAN.

Kernel log:

sja1105 spi5.0: Probed switch chip: SJA1105Q
==================================================================
BUG: KASAN: slab-out-of-bounds in sja1105_setup+0x1cbc/0x2340
Write of size 8 at addr ffffff880bd57708 by task kworker/u8:0/8
...
Workqueue: events_unbound deferred_probe_work_func
Call trace:
...
sja1105_setup+0x1cbc/0x2340
dsa_register_switch+0x1284/0x18d0
sja1105_probe+0x748/0x840
...
Allocated by task 8:
...
sja1105_setup+0x1bcc/0x2340
dsa_register_switch+0x1284/0x18d0
sja1105_probe+0x748/0x840
...

Fixes: 38fbe91f2287 ("net: dsa: sja1105: configure the multicast policers, if present")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Radu Nicolae Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20221207132347.38698-1-radu-nicolae.pirea@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1038,7 +1038,7 @@ static int sja1105_init_l2_policing(stru
 
 		policing[bcast].sharindx = port;
 		/* Only SJA1110 has multicast policers */
-		if (mcast <= table->ops->max_entry_count)
+		if (mcast < table->ops->max_entry_count)
 			policing[mcast].sharindx = port;
 	}
 


