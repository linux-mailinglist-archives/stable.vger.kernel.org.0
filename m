Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC4E608700
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiJVHzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiJVHyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC3D2C6EA8;
        Sat, 22 Oct 2022 00:47:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4FAA60AFD;
        Sat, 22 Oct 2022 07:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D5DC433C1;
        Sat, 22 Oct 2022 07:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424806;
        bh=W0IX97rDbejV5O6XzcEziQT2bEP4ZyIT4QwCqP1mfbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAvZbU9Nuog+vRWdKm1VUh3LC9rXk5f/Ivq6EdYkkJ2k9BMEEGpReDkb5KiA3L+oC
         gtV1ZPK52gvd7KGE0yDkJbTyVUa8h9DkDUXwA35RxfNjkw6wAjsNBQSQ9hklRigZJf
         R8B7y67XvgbiIhc6xbHP24Md97pmlwsHdrqdEbZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 283/717] Bluetooth: hci_sync: Fix not indicating power state
Date:   Sat, 22 Oct 2022 09:22:42 +0200
Message-Id: <20221022072503.834302003@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3b4cee67bbd6..a7c0cd2fabfb 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4033,6 +4033,7 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 		    hci_dev_test_flag(hdev, HCI_MGMT) &&
 		    hdev->dev_type == HCI_PRIMARY) {
 			ret = hci_powered_update_sync(hdev);
+			mgmt_power_on(hdev, ret);
 		}
 	} else {
 		/* Init failed, cleanup */
-- 
2.35.1



