Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0586048B6
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 16:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbiJSOGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 10:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiJSOGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 10:06:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E31D172B64;
        Wed, 19 Oct 2022 06:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6A8BB823AC;
        Wed, 19 Oct 2022 08:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3DCC433D6;
        Wed, 19 Oct 2022 08:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169595;
        bh=0KkmT5SgT36Ll04Lwr9o7RYoOWeWFnvdMbc5wTRsvb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsdyRXQFU62y3KRlku0zMPRsg41cEw+uxanDm+pgSPdZ3+WFHP8lMLGAE7OyGXL1I
         rH8tFL8MwziEYU1kVYnFLd6fafw2Dyip2hqH84qn4JjOm4xbqUWjVNeDdZnFX/lX/y
         Tj+1o6Vy5pn6Y18UR31myAkMzUXUha6b+kM4CjcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 334/862] Bluetooth: hci_sync: Fix not indicating power state
Date:   Wed, 19 Oct 2022 10:27:01 +0200
Message-Id: <20221019083304.805307471@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 6abf0dae8c3c927f54e62c46faf8aba580ba0d04 ]

When setting power state using legacy/non-mgmt API
(e.g hcitool hci0 up) the likes of mgmt_set_powered_complete won't be
called causing clients of the MGMT API to not be notified of the change
of the state.

Fixes: cf75ad8b41d2 ("Bluetooth: hci_sync: Convert MGMT_SET_POWERED")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index fbd5613eebfc..f70798589bf5 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4355,6 +4355,7 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 		    hci_dev_test_flag(hdev, HCI_MGMT) &&
 		    hdev->dev_type == HCI_PRIMARY) {
 			ret = hci_powered_update_sync(hdev);
+			mgmt_power_on(hdev, ret);
 		}
 	} else {
 		/* Init failed, cleanup */
-- 
2.35.1



