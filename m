Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4024FD5CA
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356098AbiDLHeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355371AbiDLH1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D928496A4;
        Tue, 12 Apr 2022 00:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0795B81B5E;
        Tue, 12 Apr 2022 07:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8118C385A8;
        Tue, 12 Apr 2022 07:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747250;
        bh=0zKCbHAONkY/vd2WJvNTYAVZp3uGT2GXWGlXpIL/qew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsoVXMsTVx/M5pzZXwVmUbufhSKfJukQGftOVE7p4GawT6FwED2OEOv/y7z9HmJGe
         bTjCe8BQ0nIuWyBBMs1wfcYNn8X6j/VcOgMTBQ6BwZPmR6v9QOUz2rnFsgP+jBnkPU
         O34ZZZANDJH3ksZRBYOPLyeZObuE9VU9A/1txSh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 012/343] Bluetooth: hci_sync: Fix compilation warning
Date:   Tue, 12 Apr 2022 08:27:10 +0200
Message-Id: <20220412062951.459437651@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 89a0b8b98f49ae34886e67624208c2898e1e4d7f ]

This fixes the following warning:

net/bluetooth/hci_sync.c:5143:5: warning: no previous prototype for
‘hci_le_ext_create_conn_sync’ [-Wmissing-prototypes]

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 405d48c3e63e..48c837530a11 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5156,8 +5156,8 @@ static void set_ext_conn_params(struct hci_conn *conn,
 	p->max_ce_len = cpu_to_le16(0x0000);
 }
 
-int hci_le_ext_create_conn_sync(struct hci_dev *hdev, struct hci_conn *conn,
-				u8 own_addr_type)
+static int hci_le_ext_create_conn_sync(struct hci_dev *hdev,
+				       struct hci_conn *conn, u8 own_addr_type)
 {
 	struct hci_cp_le_ext_create_conn *cp;
 	struct hci_cp_le_ext_conn_param *p;
-- 
2.35.1



