Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2CC18B761
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgCSNNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbgCSNNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:13:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD733216FD;
        Thu, 19 Mar 2020 13:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623603;
        bh=c1PxxNuJbM5JWkNQ6MLInGeJAXXhBqAFhb4JU8MqEnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yySrYovXzm1bkawBIpm9cs+4oi18YqJwWDptbc9ASazY1acdiz7N7dxQIO9GvgPKP
         62WCELk42cKTn8xhcuQtZ70akveAFMaBnkXxZWQwThjp/Z7bXHbGhu7l4KtyS2hHsh
         TdzFz7vwJ58GmMlRMu5iqMQwKtD+RYd5G3rjc0aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 55/90] batman-adv: Use default throughput value on cfg80211 error
Date:   Thu, 19 Mar 2020 14:00:17 +0100
Message-Id: <20200319123945.376555621@linuxfoundation.org>
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

commit 3f3f87325dcb3c201076c81490f4da91ad4c09fc upstream.

A wifi interface should never be handled like an ethernet devices. The
parser of the cfg80211 output must therefore skip the ethtool code when
cfg80211_get_station returned an error.

Fixes: f44a3ae9a281 ("batman-adv: refactor wifi interface detection")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Reviewed-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_v_elp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -100,8 +100,10 @@ static u32 batadv_v_elp_get_throughput(s
 				 */
 				return 0;
 			}
-			if (!ret)
-				return sinfo.expected_throughput / 100;
+			if (ret)
+				goto default_throughput;
+
+			return sinfo.expected_throughput / 100;
 		}
 
 		/* unsupported WiFi driver version */


