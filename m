Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAC22266CD
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732546AbgGTQGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732326AbgGTQGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:06:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71A9122CB1;
        Mon, 20 Jul 2020 16:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261182;
        bh=UGRiLNW0JDahO8Xf3/NU6SppfpdGiTJJ7PsnPOcTj68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfAxDhSVLPy/ralBBlMv+ydoZz2uSe6ePDMjxG7dveCBG1ZKcKF40HqTaGPSEE5G1
         OhTFW+R4kkhM3ArjWZ0G/6JvybIxxPd2xcbZa1eKN+rYZ8FiHI4E9ZzGZ+Rbi/UFYR
         9bfH6Qnj2CRZ80e1rOBJyMkSxQT/QV7gHrxsDB7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 023/244] net: ipa: always check for stopped channel
Date:   Mon, 20 Jul 2020 17:34:54 +0200
Message-Id: <20200720152826.970928166@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 5468cbcddf47f674829c6ada190283108a63d7b5 ]

In gsi_channel_stop(), there's a check to see if the channel might
have entered STOPPED state since a previous call, which might have
timed out before stopping completed.

That check actually belongs in gsi_channel_stop_command(), which is
called repeatedly by gsi_channel_stop() for RX channels.

Fixes: 650d1603825d ("soc: qcom: ipa: the generic software interface")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/gsi.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -490,6 +490,12 @@ static int gsi_channel_stop_command(stru
 	enum gsi_channel_state state = channel->state;
 	int ret;
 
+	/* Channel could have entered STOPPED state since last call
+	 * if it timed out.  If so, we're done.
+	 */
+	if (state == GSI_CHANNEL_STATE_STOPPED)
+		return 0;
+
 	if (state != GSI_CHANNEL_STATE_STARTED &&
 	    state != GSI_CHANNEL_STATE_STOP_IN_PROC)
 		return -EINVAL;
@@ -773,13 +779,6 @@ int gsi_channel_stop(struct gsi *gsi, u3
 
 	gsi_channel_freeze(channel);
 
-	/* Channel could have entered STOPPED state since last call if the
-	 * STOP command timed out.  We won't stop a channel if stopping it
-	 * was successful previously (so we still want the freeze above).
-	 */
-	if (channel->state == GSI_CHANNEL_STATE_STOPPED)
-		return 0;
-
 	/* RX channels might require a little time to enter STOPPED state */
 	retries = channel->toward_ipa ? 0 : GSI_CHANNEL_STOP_RX_RETRIES;
 


