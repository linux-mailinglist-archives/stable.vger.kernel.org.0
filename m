Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEB06353D5
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbiKWJAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236908AbiKWI7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:59:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31AC100B00
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:59:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E204B81EEF
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5F1C433D7;
        Wed, 23 Nov 2022 08:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193978;
        bh=AvowpiZKw3BTNJT0xhVLI96/zStxMmZuE3bEptJGq4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBa6JLUoUiWXwUY3Sb5bCldqMNm3gwewS+GmJ+zAUBTNFrH/g7YbphYyBfSJ28YS1
         76aUaAvhVKSz69dg1nvWn2X1zRKYqiHYUEhhZsIeBh7z9iQbWyXCFpPGX83zSQY0ke
         JGy6aaWleGeZvpI+TdWGigsMdf02whmcNw9zhzYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/88] Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
Date:   Wed, 23 Nov 2022 09:50:33 +0100
Message-Id: <20221123084549.745428831@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f937b758a188d6fd328a81367087eddbb2fce50f ]

l2cap_global_chan_by_psm shall not return fixed channels as they are not
meant to be connected by (S)PSM.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 60bf8603ddc9..8b5b232294b5 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1824,7 +1824,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 		if (link_type == LE_LINK && c->src_type == BDADDR_BREDR)
 			continue;
 
-		if (c->psm == psm) {
+		if (c->chan_type != L2CAP_CHAN_FIXED && c->psm == psm) {
 			int src_match, dst_match;
 			int src_any, dst_any;
 
-- 
2.35.1



