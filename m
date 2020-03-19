Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B881C18B7A7
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgCSNen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728973AbgCSNMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:12:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 613B12145D;
        Thu, 19 Mar 2020 13:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623559;
        bh=VihryuoItoXxh/VaTuC2RDkKuohmb55B2WJjP8uKwrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSxm7hvMeZETPNDjUvcSv3jNDViQQZmyGtJh7HiZMcUsWiMS/sPUdQhhCGcW8RQ2r
         2Kz8dlhssb556/XvXn0N4wxpnvuZN8f1yXC3IQ+bcEd0uFvyJaqs3KqQVttJ7MHvwE
         /XOrizqaOckRWrRhGadbSpkXnIOfWIBy6wpoL+OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Linus=20L=FCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 68/90] batman-adv: Avoid storing non-TT-sync flags on singular entries too
Date:   Thu, 19 Mar 2020 14:00:30 +0100
Message-Id: <20200319123949.592169931@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

commit 4a519b83da16927fb98fd32b0f598e639d1f1859 upstream.

Since commit 54e22f265e87 ("batman-adv: fix TT sync flag inconsistencies")
TT sync flags and TT non-sync'd flags are supposed to be stored
separately.

The previous patch missed to apply this separation on a TT entry with
only a single TT orig entry.

This is a minor fix because with only a single TT orig entry the DDoS
issue the former patch solves does not apply.

Fixes: 54e22f265e87 ("batman-adv: fix TT sync flag inconsistencies")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1708,7 +1708,8 @@ static bool batadv_tt_global_add(struct
 		ether_addr_copy(common->addr, tt_addr);
 		common->vid = vid;
 
-		common->flags = flags;
+		common->flags = flags & (~BATADV_TT_SYNC_MASK);
+
 		tt_global_entry->roam_at = 0;
 		/* node must store current time in case of roaming. This is
 		 * needed to purge this entry out on timeout (if nobody claims


