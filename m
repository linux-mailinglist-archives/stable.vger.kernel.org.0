Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349FA3CDD60
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244232AbhGSO5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244072AbhGSO4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:56:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E1DB613AA;
        Mon, 19 Jul 2021 15:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708858;
        bh=oJAUPZVyOiSn/Pm1jQw8KTg6JuS7VYNilo3Jvm9zJPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEfqDX+qRxKA37saTkkfKO1FttFExjbwKgIRv7+OaZXiZ3HLSBCv9+lRc4kl3ctik
         rEOyg8XR1ya+RYtMcE+HjTxhzZKxkvtSx9tckJZr2stPe2vJ51xpXMvwieucxfshmH
         1fioRUzDYg20pMLkPO1Wlkul9yeK88ueaBE5ka54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 159/421] Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid
Date:   Mon, 19 Jul 2021 16:49:30 +0200
Message-Id: <20210719144951.975264590@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 799acb9347915bfe4eac0ff2345b468f0a1ca207 ]

This fixes parsing of LTV entries when the length is 0.

Found with:

tools/mgmt-tester -s "Add Advertising - Success (ScRsp only)"

Add Advertising - Success (ScRsp only) - run
  Sending Add Advertising (0x003e)
  Test condition added, total 1
[   11.004577] ==================================================================
[   11.005292] BUG: KASAN: slab-out-of-bounds in tlv_data_is_valid+0x87/0xe0
[   11.005984] Read of size 1 at addr ffff888002c695b0 by task mgmt-tester/87
[   11.006711]
[   11.007176]
[   11.007429] Allocated by task 87:
[   11.008151]
[   11.008438] The buggy address belongs to the object at ffff888002c69580
[   11.008438]  which belongs to the cache kmalloc-64 of size 64
[   11.010526] The buggy address is located 48 bytes inside of
[   11.010526]  64-byte region [ffff888002c69580, ffff888002c695c0)
[   11.012423] The buggy address belongs to the page:
[   11.013291]
[   11.013544] Memory state around the buggy address:
[   11.014359]  ffff888002c69480: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[   11.015453]  ffff888002c69500: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[   11.016232] >ffff888002c69580: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
[   11.017010]                                      ^
[   11.017547]  ffff888002c69600: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
[   11.018296]  ffff888002c69680: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[   11.019116] ==================================================================

Fixes: 2bb36870e8cb2 ("Bluetooth: Unify advertising instance flags check")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5340b1097afb..e9a4f11278d9 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -6468,6 +6468,9 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
 	for (i = 0, cur_len = 0; i < len; i += (cur_len + 1)) {
 		cur_len = data[i];
 
+		if (!cur_len)
+			continue;
+
 		if (data[i + 1] == EIR_FLAGS &&
 		    (!is_adv_data || flags_managed(adv_flags)))
 			return false;
-- 
2.30.2



