Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4B2651343
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbiLST3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiLST2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:28:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73110140AF
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:28:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ED6A60EF0
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F3AC433EF;
        Mon, 19 Dec 2022 19:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671478117;
        bh=iUgEU8nBl+a3A5tU9zgI/QliV6uTr4WE0BYZefH7lL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9pngsvCiCPaHMeh9qTfoaDwzYpOacUnVy+urtrKpf3u9iaP9zdL7DTnylYtnVbcy
         7Huv64NaWJa6eSkAnlMPsQa5iPxrpe5Ij2GINfoOBSpiEDmfqiMFLFmChMzTn3dlm9
         VsL2GJBOCaZQ+Z08sYcN0EpPApllpxvJO2OVhQ4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sungwoo Kim <iam@sung-woo.kim>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/18] Bluetooth: L2CAP: Fix u8 overflow
Date:   Mon, 19 Dec 2022 20:25:10 +0100
Message-Id: <20221219182941.219721956@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
References: <20221219182940.701087296@linuxfoundation.org>
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

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit bcd70260ef56e0aee8a4fc6cd214a419900b0765 ]

By keep sending L2CAP_CONF_REQ packets, chan->num_conf_rsp increases
multiple times and eventually it will wrap around the maximum number
(i.e., 255).
This patch prevents this by adding a boundary check with
L2CAP_MAX_CONF_RSP

Btmon log:
Bluetooth monitor ver 5.64
= Note: Linux version 6.1.0-rc2 (x86_64)                               0.264594
= Note: Bluetooth subsystem version 2.22                               0.264636
@ MGMT Open: btmon (privileged) version 1.22                  {0x0001} 0.272191
= New Index: 00:00:00:00:00:00 (Primary,Virtual,hci0)          [hci0] 13.877604
@ RAW Open: 9496 (privileged) version 2.22                   {0x0002} 13.890741
= Open Index: 00:00:00:00:00:00                                [hci0] 13.900426
(...)
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #32 [hci0] 14.273106
        invalid packet size (12 != 1033)
        08 00 01 00 02 01 04 00 01 10 ff ff              ............
> ACL Data RX: Handle 200 flags 0x00 dlen 1547             #33 [hci0] 14.273561
        invalid packet size (14 != 1547)
        0a 00 01 00 04 01 06 00 40 00 00 00 00 00        ........@.....
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #34 [hci0] 14.274390
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 00 00 00 04  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #35 [hci0] 14.274932
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 07 00 03 00  ........@.......
= bluetoothd: Bluetooth daemon 5.43                                   14.401828
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #36 [hci0] 14.275753
        invalid packet size (12 != 1033)
        08 00 01 00 04 01 04 00 40 00 00 00              ........@...

Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index c5e4d2b8cb0b..cf56582d298a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4449,7 +4449,8 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 
 	chan->ident = cmd->ident;
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP, len, rsp);
-	chan->num_conf_rsp++;
+	if (chan->num_conf_rsp < L2CAP_CONF_MAX_CONF_RSP)
+		chan->num_conf_rsp++;
 
 	/* Reset config buffer. */
 	chan->conf_len = 0;
-- 
2.35.1



