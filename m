Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911576895D5
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjBCKUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbjBCKUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:20:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC5F9E9DA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:19:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1708161EBA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AFAC433EF;
        Fri,  3 Feb 2023 10:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419566;
        bh=S90Wo5mKJdgcgpkQrsqkJur4QwGCdT5JL7l+0BYkU0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOHAVBZcHS62PYoRkqJVaO84TfHtvPTBpa7gO+f/hvyugGbmRxWwPx6OI1iX9JnKH
         JXAB2djGdm6KAdnCwsVIaNZ+jjrczEigK/X3Urep5kRlzaSCMHaAVOg5gbO2mHQ+yy
         U4Dlq/Q7VT6S9PkwVGSD4P+bF2annLVnR94uh0aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/80] wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid
Date:   Fri,  3 Feb 2023 11:12:09 +0100
Message-Id: <20230203101015.854767117@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 51e4e92d95a0..0bbeb61ec3a3 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -712,8 +712,8 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 		struct rndis_query	*get;
 		struct rndis_query_c	*get_c;
 	} u;
-	int ret, buflen;
-	int resplen, respoffs, copylen;
+	int ret;
+	size_t buflen, resplen, respoffs, copylen;
 
 	buflen = *len + sizeof(*u.get);
 	if (buflen < CONTROL_BUFFER_SIZE)
@@ -748,22 +748,15 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 
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



