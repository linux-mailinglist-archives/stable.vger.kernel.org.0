Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E166918B4C4
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgCSNM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbgCSNM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:12:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B4A3215A4;
        Thu, 19 Mar 2020 13:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623546;
        bh=yz68c61gnGBkpldyJlxAypbhJtxqSMGYLCBceO05UoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/z3rCk1M9sQL6cbqQ6qz5bjxKMNFIlMvc0d8JIBqM7leX17v+5CVy555kznl8cvB
         mz+L6gaVRC3OE3VlMVvHdpdVaEQNAedG4rx0ZkW0GY/Nxuw4YPyyvGbmUKpxRHi4JP
         ht+sTezjtoHZz66qqNXql5zHJmWNFlJfj3O62hbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alvaro Antelo <alvaro.antelo@gmail.com>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 56/90] batman-adv: Accept only filled wifi station info
Date:   Thu, 19 Mar 2020 14:00:18 +0100
Message-Id: <20200319123945.669377960@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit d62890885efbc48acea46964ea3af69b61c8c5eb upstream.

The wifi driver can decide to not provide parts of the station info. For
example, the expected throughput of the station can be omitted when the
used rate control doesn't provide this kind of information.

The B.A.T.M.A.N. V implementation must therefore check the filled bitfield
before it tries to access the expected_throughput of the returned
station_info.

Reported-by: Alvaro Antelo <alvaro.antelo@gmail.com>
Fixes: c833484e5f38 ("batman-adv: ELP - compute the metric based on the estimated throughput")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Reviewed-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_v_elp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -19,6 +19,7 @@
 #include "main.h"
 
 #include <linux/atomic.h>
+#include <linux/bitops.h>
 #include <linux/byteorder/generic.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
@@ -29,6 +30,7 @@
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/netdevice.h>
+#include <linux/nl80211.h>
 #include <linux/random.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -102,6 +104,8 @@ static u32 batadv_v_elp_get_throughput(s
 			}
 			if (ret)
 				goto default_throughput;
+			if (!(sinfo.filled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
+				goto default_throughput;
 
 			return sinfo.expected_throughput / 100;
 		}


