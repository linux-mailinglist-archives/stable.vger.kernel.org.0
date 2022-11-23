Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D63635535
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237262AbiKWJOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237263AbiKWJOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:14:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E7D107E65
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:14:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A7461B4D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0248BC433C1;
        Wed, 23 Nov 2022 09:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194861;
        bh=POwGG4pLJ+2XfsCxy8zrPY9aDITKMX4OWVbLHSl/pwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUT+c7fCtKCjRKEi/Sp3O/KGkkEWPOlGvGqON3Yop1pAhgVj5lTZQXoXmFY7enBui
         zWFExs6MseDDeAD/tC5QTDUTCwbWtB08w3GQQbgX30YTeQmbAesYvQmpB2JbWaV6Xo
         neZjziZHEdAQPQYQkXGfLq3TRvstRYQrTuQJuyis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/156] Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
Date:   Wed, 23 Nov 2022 09:50:37 +0100
Message-Id: <20221123084600.900601144@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
index c0cdc28e1d1e..afa7fc55555e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1833,7 +1833,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 		if (link_type == LE_LINK && c->src_type == BDADDR_BREDR)
 			continue;
 
-		if (c->psm == psm) {
+		if (c->chan_type != L2CAP_CHAN_FIXED && c->psm == psm) {
 			int src_match, dst_match;
 			int src_any, dst_any;
 
-- 
2.35.1



