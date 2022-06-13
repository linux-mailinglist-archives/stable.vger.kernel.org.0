Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60205548724
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379012AbiFMNqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379077AbiFMNnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:43:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921683EB8D;
        Mon, 13 Jun 2022 04:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2FE36125A;
        Mon, 13 Jun 2022 11:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CA4C34114;
        Mon, 13 Jun 2022 11:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119906;
        bh=r+9jZckJhU5GOlndnobg0898jPtm8X7hVE+DfhMLKLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tgto6gzApPgMlGWeD64sc5eJSIp0luy1bd+GVSRfjKbda2oDrYLU5m2fk31ukgs5f
         a4YG8sd4no5gT7TEE+TjudPlSMe7G2ViFBk4lBltxe2ACy3Qo5M0unPM1K8t7/ahgO
         CHe3RIMkeAHjUcsH/fK+17KgTFKlaEGHGhQWrn50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 151/339] Bluetooth: MGMT: Add conditions for setting HCI_CONN_FLAG_REMOTE_WAKEUP
Date:   Mon, 13 Jun 2022 12:09:36 +0200
Message-Id: <20220613094931.264269801@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit a9a347655d224fa2841877957b34fc9d491fc2d7 ]

HCI_CONN_FLAG_REMOTE_WAKEUP can only be set if device can be programmed
in the allowlist which in case of device using RPA requires LL Privacy
support to be enabled.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215768
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index d2d390534e54..74937a834648 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4529,6 +4529,23 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
 						le_addr_type(cp->addr.type));
 		if (params) {
+			DECLARE_BITMAP(flags, __HCI_CONN_NUM_FLAGS);
+
+			bitmap_from_u64(flags, current_flags);
+
+			/* Devices using RPAs can only be programmed in the
+			 * acceptlist LL Privacy has been enable otherwise they
+			 * cannot mark HCI_CONN_FLAG_REMOTE_WAKEUP.
+			 */
+			if (test_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, flags) &&
+			    !use_ll_privacy(hdev) &&
+			    hci_find_irk_by_addr(hdev, &params->addr,
+						 params->addr_type)) {
+				bt_dev_warn(hdev,
+					    "Cannot set wakeable for RPA");
+				goto unlock;
+			}
+
 			bitmap_from_u64(params->flags, current_flags);
 			status = MGMT_STATUS_SUCCESS;
 
@@ -4545,6 +4562,7 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		}
 	}
 
+unlock:
 	hci_dev_unlock(hdev);
 
 done:
-- 
2.35.1



