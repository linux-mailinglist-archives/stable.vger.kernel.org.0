Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CB9382E9D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbhEQOJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238087AbhEQOHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:07:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEC2E61378;
        Mon, 17 May 2021 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260374;
        bh=MXO7lywpyeZqi4VabcZBelWaWHOEX+WMMkhOrrfSQC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUPeQGthiyDWKtPD3dgkNFUvqNUprB1KYlLNwJTxF0FRN23dve1NMtQrpysExavFM
         hbKNI8pbRtNDXxrIWNte+AAmGP8ukrqCaQm9vBCWRhvEp8L5Wi0gpxpZmWn5bgNmRk
         2oHiXgt7jVySF15YOsgHhDh2j9l+5+vnbccFxK2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miao-chen Chou <mcchou@chromium.org>,
        Daniel Winkler <danielwinkler@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 052/363] Bluetooth: Do not set cur_adv_instance in adv param MGMT request
Date:   Mon, 17 May 2021 15:58:38 +0200
Message-Id: <20210517140304.365800070@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Winkler <danielwinkler@google.com>

[ Upstream commit b6f1b79deabd32f89adbf24ef7b30f82d029808a ]

We set hdev->cur_adv_instance in the adv param MGMT request to allow the
callback to the hci param request to set the tx power to the correct
instance. Now that the callbacks use the advertising handle from the hci
request (as they should), this workaround is no longer necessary.

Furthermore, this change resolves a race condition that is more
prevalent when using the extended advertising MGMT calls - if
hdev->cur_adv_instance is set in the params request, then when the data
request is called, we believe our new instance is already active. This
treats it as an update and immediately schedules the instance with the
controller, which has a potential race with the software rotation adv
update. By not setting hdev->cur_adv_instance too early, the new
instance is queued as it should be, to be used when the rotation comes
around again.

This change is tested on harrison peak to confirm that it resolves the
race condition on registration, and that there is no regression in
single- and multi-advertising automated tests.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 74971b4bd457..939c6f77fecc 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7976,7 +7976,6 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	hdev->cur_adv_instance = cp->instance;
 	/* Submit request for advertising params if ext adv available */
 	if (ext_adv_capable(hdev)) {
 		hci_req_init(&req, hdev);
-- 
2.30.2



