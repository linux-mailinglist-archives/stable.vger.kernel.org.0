Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7031548A69
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383862AbiFMO1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383809AbiFMOYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8138E2E9DD;
        Mon, 13 Jun 2022 04:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 334F8B80EB3;
        Mon, 13 Jun 2022 11:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D34C34114;
        Mon, 13 Jun 2022 11:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120720;
        bh=PdRcMK7wIRjwXJN2P587ZeIIRGxm5XyqCh0kw16O6vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ec557iOSYUxRudPLogMQFv45fYalW9rZgUF42y3bzhStuIF2AL8KLKc2fF3bk1O/S
         oWPcQaZekV0s4dQC3ILg4GhR3IQm/xERInGzOPeVZBr+VNxE/VuhbeUIxlxDmLaSqk
         MLjQnQAi2gPsIyRQTQyQrvXnepGOEeKMt9eCXSlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 132/298] Bluetooth: MGMT: Add conditions for setting HCI_CONN_FLAG_REMOTE_WAKEUP
Date:   Mon, 13 Jun 2022 12:10:26 +0200
Message-Id: <20220613094928.947092266@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index 15eab8b968ce..16cd2e7a10da 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4525,6 +4525,23 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
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
 
@@ -4541,6 +4558,7 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		}
 	}
 
+unlock:
 	hci_dev_unlock(hdev);
 
 done:
-- 
2.35.1



