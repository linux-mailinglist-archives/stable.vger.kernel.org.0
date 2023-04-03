Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD4F6D46A4
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbjDCOMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbjDCOMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:12:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCB52BEC2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:11:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42A72B81A49
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC904C4339B;
        Mon,  3 Apr 2023 14:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531111;
        bh=8U0+KCB4JzpOYrOfqQpnHMvfkiX3CwL64HOjTw2QnaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXx/CSADgRmkDawozfLsUKCtc36+AxZNrTj8aqNj5uwHYRnxrAjj7ocgsOfBpyWVA
         6r3aFdJLAwneP3UBxVlqvjfHDIeFCu8WUOwqPfSZikya//9X7aXc4KQfOH/sxiIuIB
         uyY/yvJ20NdwmS8rk0cBUDCHIDb0oWeQPKlHC/pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, lianhui tang <bluetlh@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/66] ca8210: fix mac_len negative array access
Date:   Mon,  3 Apr 2023 16:08:32 +0200
Message-Id: <20230403140352.780803104@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 6c993779ea1d0cccdb3a5d7d45446dd229e610a3 ]

This patch fixes a buffer overflow access of skb->data if
ieee802154_hdr_peek_addrs() fails.

Reported-by: lianhui tang <bluetlh@gmail.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20230217042504.3303396-1-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index eff7571dbea20..76ca8c63bc379 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1955,6 +1955,8 @@ static int ca8210_skb_tx(
 	 * packet
 	 */
 	mac_len = ieee802154_hdr_peek_addrs(skb, &header);
+	if (mac_len < 0)
+		return mac_len;
 
 	secspec.security_level = header.sec.level;
 	secspec.key_id_mode = header.sec.key_id_mode;
-- 
2.39.2



