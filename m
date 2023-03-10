Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742956B41F9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjCJN6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCJN6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:58:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B024A1D2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:58:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C566C61552
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB371C4339B;
        Fri, 10 Mar 2023 13:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456698;
        bh=dKrz7kU27bUbPOR2Cfrp+nKYGHZXrtgkSoaPoNk/cU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbADiIME/UXpHQFmb6Mcq70h8DXd2mbBLbZVsubQGjBvFXjEu/BPUz2GcKDXpkwWl
         qOfyZfVgtq0ezITP7rb5PvqTzARpU7bMoeZlt4zx6GHVh3GduBt1YAH2yp3AXEhFli
         vR10zYr/Z1gCAY9VcM/+XRkDhelOZ5EiqP8NYZKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 093/211] nfc: fix memory leak of se_io context in nfc_genl_se_io
Date:   Fri, 10 Mar 2023 14:37:53 +0100
Message-Id: <20230310133721.610731383@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 25ff6f8a5a3b8dc48e8abda6f013e8cc4b14ffea ]

The callback context for sending/receiving APDUs to/from the selected
secure element is allocated inside nfc_genl_se_io and supposed to be
eventually freed in se_io_cb callback function. However, there are several
error paths where the bwi_timer is not charged to call se_io_cb later, and
the cb_context is leaked.

The patch proposes to free the cb_context explicitly on those error paths.

At the moment we can't simply check 'dev->ops->se_io()' return value as it
may be negative in both cases: when the timer was charged and was not.

Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
Reported-by: syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st-nci/se.c   | 6 ++++++
 drivers/nfc/st21nfca/se.c | 6 ++++++
 net/nfc/netlink.c         | 4 ++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index ec87dd21e054a..b2f1ced8e6dd2 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -672,6 +672,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
 					ST_NCI_EVT_TRANSMIT_DATA, apdu,
 					apdu_length);
 	default:
+		/* Need to free cb_context here as at the moment we can't
+		 * clearly indicate to the caller if the callback function
+		 * would be called (and free it) or not. In both cases a
+		 * negative value may be returned to the caller.
+		 */
+		kfree(cb_context);
 		return -ENODEV;
 	}
 }
diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index df8d27cf2956b..dae288bebcb5a 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -236,6 +236,12 @@ int st21nfca_hci_se_io(struct nfc_hci_dev *hdev, u32 se_idx,
 					ST21NFCA_EVT_TRANSMIT_DATA,
 					apdu, apdu_length);
 	default:
+		/* Need to free cb_context here as at the moment we can't
+		 * clearly indicate to the caller if the callback function
+		 * would be called (and free it) or not. In both cases a
+		 * negative value may be returned to the caller.
+		 */
+		kfree(cb_context);
 		return -ENODEV;
 	}
 }
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 1fc339084d897..348bf561bc9fb 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1442,7 +1442,11 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
 	rc = dev->ops->se_io(dev, se_idx, apdu,
 			apdu_length, cb, cb_context);
 
+	device_unlock(&dev->dev);
+	return rc;
+
 error:
+	kfree(cb_context);
 	device_unlock(&dev->dev);
 	return rc;
 }
-- 
2.39.2



