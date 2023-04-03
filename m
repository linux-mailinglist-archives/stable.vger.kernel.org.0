Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CE26D4720
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjDCORV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbjDCORU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:17:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110CA22E90
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5A2BB81B4D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07106C4339B;
        Mon,  3 Apr 2023 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531436;
        bh=vwyP+btEt/+dbkYLeGagCBJ++IwAxrGwe1QLKWvlyYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7oTECuQcZHG7qng9GGWaDp/+XQY0bnjwqxSXI1JpY18s+y6KXNJDs9YIPv+Jo9wg
         BzPGUjBFh2OxgfnMT8iW4DS4J6JZs7VqffP03O2awXtQ0PS4MDb7xHRwwvT56YtRwH
         KQDXR/KCMlLdkD5xE74+DULtHpxZ67xUEEBfL2GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Alexander Aring <aahringo@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 61/84] ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()
Date:   Mon,  3 Apr 2023 16:09:02 +0200
Message-Id: <20230403140355.538863288@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 748b2f5e82d17480404b3e2895388fc2925f7caf ]

mac_len is of type unsigned, which can never be less than zero.

	mac_len = ieee802154_hdr_peek_addrs(skb, &header);
	if (mac_len < 0)
		return mac_len;

Change this to type int as ieee802154_hdr_peek_addrs() can return negative
integers, this is found by static analysis with smatch.

Fixes: 6c993779ea1d ("ca8210: fix mac_len negative array access")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230306191824.4115839-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 2d4471b77fa7c..f75faec23cc98 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1943,10 +1943,9 @@ static int ca8210_skb_tx(
 	struct ca8210_priv  *priv
 )
 {
-	int status;
 	struct ieee802154_hdr header = { };
 	struct secspec secspec;
-	unsigned int mac_len;
+	int mac_len, status;
 
 	dev_dbg(&priv->spi->dev, "%s called\n", __func__);
 
-- 
2.39.2



