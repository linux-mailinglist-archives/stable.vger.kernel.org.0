Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F46A6E63CB
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbjDRMn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjDRMnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:43:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E0A118F7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:43:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7936E6333D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E0FC433EF;
        Tue, 18 Apr 2023 12:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821796;
        bh=Qxy8ZmtPJkvBYhgNYNbwECvwRmJOJ2gSy/Ii9u2NxSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmkeGWHFI67uuhgLatFmTGmZ5JYAVSEwV4LPn06mjOsZKeXphyIVhJN1vxQaOPJP1
         AwWh2P7nheZzGxeJ59UpJ3m0qvemBygZcJRf84AOOgxIAC740U3lAcxo/7D8088eW3
         UoWIr8Ww8CiO2YcPD/x5Ux35lxZyG09ukfYWPrfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Archie Pusaka <apusaka@chromium.org>,
        Ying Hsu <yinghsu@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 015/134] Bluetooth: Free potentially unfreed SCO connection
Date:   Tue, 18 Apr 2023 14:21:11 +0200
Message-Id: <20230418120313.525364928@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

commit 0f00cd322d22d4441de51aa80bcce5bb6a8cbb44 upstream.

It is possible to initiate a SCO connection while deleting the
corresponding ACL connection, e.g. in below scenario:

(1) < hci setup sync connect command
(2) > hci disconn complete event (for the acl connection)
(3) > hci command complete event (for(1), failure)

When it happens, hci_cs_setup_sync_conn won't be able to obtain the
reference to the SCO connection, so it will be stuck and potentially
hinder subsequent connections to the same device.

This patch prevents that by also deleting the SCO connection if it is
still not established when the corresponding ACL connection is deleted.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Ying Hsu <yinghsu@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1063,8 +1063,15 @@ int hci_conn_del(struct hci_conn *conn)
 
 	if (conn->type == ACL_LINK) {
 		struct hci_conn *sco = conn->link;
-		if (sco)
+		if (sco) {
 			sco->link = NULL;
+			/* Due to race, SCO connection might be not established
+			 * yet at this point. Delete it now, otherwise it is
+			 * possible for it to be stuck and can't be deleted.
+			 */
+			if (sco->handle == HCI_CONN_HANDLE_UNSET)
+				hci_conn_del(sco);
+		}
 
 		/* Unacked frames */
 		hdev->acl_cnt += conn->sent;


