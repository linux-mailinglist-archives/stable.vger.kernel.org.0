Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882DD3C4F21
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239950AbhGLHXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245140AbhGLHTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:19:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DDE660FF1;
        Mon, 12 Jul 2021 07:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074197;
        bh=6I2T8XFbIhEBcVIl9KYv5WDOP3d9fa/YF363DrriMpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZ2PX4LWtnTlLTUGfWM2c67lm3iVhEKjozHPTSgVVv03H9ZAm8z8EUCWr69Z5rw2h
         Z9glEpnjmGCmTiGwVk97vNXoJnBz231Jb53xfr/eTkXMCrfZcDjIef0YOYOeQtFbT9
         3gyyo3jId5+2H5tE6FWbYpTvYH7X6Hy+ZBJc6HWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 498/700] Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid
Date:   Mon, 12 Jul 2021 08:09:41 +0200
Message-Id: <20210712061029.472362450@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 939c6f77fecc..71de147f5558 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7579,6 +7579,9 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
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



