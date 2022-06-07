Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF71540601
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346470AbiFGRcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347716AbiFGRa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543B511AFDC;
        Tue,  7 Jun 2022 10:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DC3F6141D;
        Tue,  7 Jun 2022 17:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC9EC34115;
        Tue,  7 Jun 2022 17:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622882;
        bh=rV5ATrQzgw5+uUp6EFkXrz+X1dUuzqSLwh7plizy/QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnHENhbC43+mtaZ72JtOnD90KJvvB6jjDvgshI9STmD2V2VNiYd1me87Tehzrt7yx
         /6mUAs8CmO/+V0fkPfnXnDjMjIQ49KlS1AS8Mqf5bRo5SwuAoT9gakcQI39r5423q/
         aD0wf0DDZSIC+BiERSMtDA6Ulqkz596B+CCxxuwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sathish Narasimman <sathish.narasimman@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/452] Bluetooth: LL privacy allow RPA
Date:   Tue,  7 Jun 2022 19:01:15 +0200
Message-Id: <20220607164915.057399563@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Sathish Narasimman <sathish.narasimman@intel.com>

[ Upstream commit 8ce85ada0a05e21a5386ba5c417c52ab00fcd0d1 ]

allow RPA to add bd address to whitelist

Signed-off-by: Sathish Narasimman <sathish.narasimman@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_request.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 2405e1ffebbd..eb4c1c18eb01 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -842,6 +842,10 @@ static u8 update_white_list(struct hci_request *req)
 	 */
 	bool allow_rpa = hdev->suspended;
 
+	if (use_ll_privacy(hdev) &&
+	    hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY))
+		allow_rpa = true;
+
 	/* Go through the current white list programmed into the
 	 * controller one by one and check if that address is still
 	 * in the list of pending connections or list of devices to
-- 
2.35.1



