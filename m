Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410E03831DD
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240014AbhEQOla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241055AbhEQOjW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:39:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF17961360;
        Mon, 17 May 2021 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261113;
        bh=whOO/qEGOEz7yoV6ZAmhRiWRqssU/z4LEZFhx831jh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2eIrzAGF/uVsynyYpml9qiwgELG5xf1+whDI6Issq+LztFTdR85r+Tjxc8GLbiLE
         ifF0PgV/tUxBht+Epmrz0SoxkNtHvSGCZor7tSmrvkCjKAZ89eDGttqNMogtBb5sbC
         Ezr02tAslDbQun4JvTjHRvcWleoox8ZgpOlFAxk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miao-chen Chou <mcchou@chromium.org>,
        Daniel Winkler <danielwinkler@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 049/329] Bluetooth: Do not set cur_adv_instance in adv param MGMT request
Date:   Mon, 17 May 2021 15:59:20 +0200
Message-Id: <20210517140303.711455823@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index fa0f7a4a1d2f..01e143c2bbc0 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7768,7 +7768,6 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	hdev->cur_adv_instance = cp->instance;
 	/* Submit request for advertising params if ext adv available */
 	if (ext_adv_capable(hdev)) {
 		hci_req_init(&req, hdev);
-- 
2.30.2



