Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39A24FCFF6
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349967AbiDLGk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349974AbiDLGjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:39:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193CB1DA66;
        Mon, 11 Apr 2022 23:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D583618CF;
        Tue, 12 Apr 2022 06:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A972AC385A1;
        Tue, 12 Apr 2022 06:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745313;
        bh=q5WX2t/zqVNLbyFm61nHFdNhUX0OLGyezCCoWBiH+uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6i081oYWvP3dhn15/LE1J1IBIfAeDDNcAMdDCauVFO24mV1NpAk6w4JpGOCIr9j9
         UOgd1QaAaQ+W68/uQrOTgG//EdweWQFCmVvRgwz5rd+5OBfoyxeZ7LGmv+M0dtOqoa
         bhiax1A1b4sffpI3ltAYgfwxsQV3FM0BBHeuBNfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/171] Bluetooth: use memset avoid memory leaks
Date:   Tue, 12 Apr 2022 08:29:04 +0200
Message-Id: <20220412062929.417640687@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

[ Upstream commit d3715b2333e9a21692ba16ef8645eda584a9515d ]

Use memset to initialize structs to prevent memory leaks
in l2cap_ecred_connect

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 0ddbc415ce15..012c1a0abda8 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1438,6 +1438,7 @@ static void l2cap_ecred_connect(struct l2cap_chan *chan)
 
 	l2cap_ecred_init(chan, 0);
 
+	memset(&data, 0, sizeof(data));
 	data.pdu.req.psm     = chan->psm;
 	data.pdu.req.mtu     = cpu_to_le16(chan->imtu);
 	data.pdu.req.mps     = cpu_to_le16(chan->mps);
-- 
2.35.1



