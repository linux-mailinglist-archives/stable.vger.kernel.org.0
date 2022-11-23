Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC57D63538A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236545AbiKWIyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236484AbiKWIyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91669EC0BF
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:54:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49D42B81EED
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BE8C433D7;
        Wed, 23 Nov 2022 08:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193682;
        bh=gIJTAyOHPUI5ysHKZPrNJ7u/FgXcUIj68v3gpahNHQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEyFRKpLm02htprALrS+MlHBLlLEoPMqp2an3/S3DTirL5QGcYjKY4rDl2+HFdKou
         Ry557trQ2yEdUOi6aYOAb9/nZlUQ+ppv4dtFTo5YGEQsqB28TQrSa4vPl/ONi0c1Jd
         JVVv5JZV58xuUM4WYV4dCq5fu5NFU/B2cdWAgWV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 32/76] Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
Date:   Wed, 23 Nov 2022 09:50:31 +0100
Message-Id: <20221123084547.789393351@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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
index 693344984035..c230f89e7238 100644
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



