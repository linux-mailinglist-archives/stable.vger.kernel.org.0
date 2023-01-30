Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EB1681016
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbjA3OAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236826AbjA3OAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:00:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892113A585
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:59:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2ABD1CE16A2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45D1C433D2;
        Mon, 30 Jan 2023 13:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087129;
        bh=MCTorT43Jz+5c57L8MDjQkWfYPRYx5Z5nD5S8weD8E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2l/q7wR0rG3KBOcQe6aQGbeQ60hPtLtpTLI3OstUY11E8K14rcLHmyqrCDIc0q2h
         s1Pc+lGSmfFJncK3VFBUdAKGBUgaCg+Yrj8WYkzYdEds6s8Fl9lT+qyW/erv9CZ29L
         MvfFuoJG7AwJMW3/mQYjwG2FvRR002y6a+XXrGog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/313] wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid
Date:   Mon, 30 Jan 2023 14:48:31 +0100
Message-Id: <20230130134340.185841670@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Szymon Heidrich <szymon.heidrich@gmail.com>

[ Upstream commit b870e73a56c4cccbec33224233eaf295839f228c ]

Since resplen and respoffs are signed integers sufficiently
large values of unsigned int len and offset members of RNDIS
response will result in negative values of prior variables.
This may be utilized to bypass implemented security checks
to either extract memory contents by manipulating offset or
overflow the data buffer via memcpy by manipulating both
offset and len.

Additionally assure that sum of resplen and respoffs does not
overflow so buffer boundaries are kept.

Fixes: 80f8c5b434f9 ("rndis_wlan: copy only useful data from rndis_command respond")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230111175031.7049-1-szymon.heidrich@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rndis_wlan.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 82a7458e01ae..bf72e5fd39cf 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -696,8 +696,8 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 		struct rndis_query	*get;
 		struct rndis_query_c	*get_c;
 	} u;
-	int ret, buflen;
-	int resplen, respoffs, copylen;
+	int ret;
+	size_t buflen, resplen, respoffs, copylen;
 
 	buflen = *len + sizeof(*u.get);
 	if (buflen < CONTROL_BUFFER_SIZE)
@@ -732,22 +732,15 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 
 		if (respoffs > buflen) {
 			/* Device returned data offset outside buffer, error. */
-			netdev_dbg(dev->net, "%s(%s): received invalid "
-				"data offset: %d > %d\n", __func__,
-				oid_to_string(oid), respoffs, buflen);
+			netdev_dbg(dev->net,
+				   "%s(%s): received invalid data offset: %zu > %zu\n",
+				   __func__, oid_to_string(oid), respoffs, buflen);
 
 			ret = -EINVAL;
 			goto exit_unlock;
 		}
 
-		if ((resplen + respoffs) > buflen) {
-			/* Device would have returned more data if buffer would
-			 * have been big enough. Copy just the bits that we got.
-			 */
-			copylen = buflen - respoffs;
-		} else {
-			copylen = resplen;
-		}
+		copylen = min(resplen, buflen - respoffs);
 
 		if (copylen > *len)
 			copylen = *len;
-- 
2.39.0



