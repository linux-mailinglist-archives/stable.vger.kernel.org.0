Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA7C6E6452
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbjDRMsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbjDRMsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:48:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58B615A2D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54AFC62D1D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68544C4339C;
        Tue, 18 Apr 2023 12:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822082;
        bh=ZA4Uef2ssIGFJyW6w6pOYhKBoYCE4u6KYu1C5eKgdlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkKWMyO4anpd0ypt5imXksmrHTiyAmNeq/t+wL5ymPanr2TFNPgBgWDkXHfPtBCLa
         v/ONUcLstsIoSFa5FypxpxF53IlApom2xobxVkG398YDQJpqBwIh6n8xuciinN6Qd3
         HJUQGFs77lQsLY21Hzm0kSBJAmVDt0rod1IWPLw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Archie Pusaka <apusaka@chromium.org>,
        Ying Hsu <yinghsu@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.2 016/139] Bluetooth: Free potentially unfreed SCO connection
Date:   Tue, 18 Apr 2023 14:21:21 +0200
Message-Id: <20230418120314.283546097@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
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
@@ -1061,8 +1061,15 @@ int hci_conn_del(struct hci_conn *conn)
 
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


