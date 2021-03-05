Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5295C32EB19
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhCEMl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:41:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233498AbhCEMlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:41:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB6926501C;
        Fri,  5 Mar 2021 12:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948105;
        bh=rCjQLpaXFPWhsy6+gKBiTLjmhg3HwXgLQgVHzoF0dMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/a1m333mDvlgksnKG/wmuZrprswYw1NlFqvpqrGvw/zDfCIYDWNxLgHyhd5NGi3E
         3r1ncBB/vliHDe+pu23kyB/FWbi/LfzK/lFvmTThtAzUnyiNDVz5b1XJzOqxyKwd5j
         bxkyyrpEhEerhtd/z+LlyMuUi7oWzlfLe0Ek49fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gopal Tiwari <gtiwari@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 30/41] Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data
Date:   Fri,  5 Mar 2021 13:22:37 +0100
Message-Id: <20210305120852.761087263@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
References: <20210305120851.255002428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gopal Tiwari <gtiwari@redhat.com>

[ Upstream commit e8bd76ede155fd54d8c41d045dda43cd3174d506 ]

kernel panic trace looks like:

 #5 [ffffb9e08698fc80] do_page_fault at ffffffffb666e0d7
 #6 [ffffb9e08698fcb0] page_fault at ffffffffb70010fe
    [exception RIP: amp_read_loc_assoc_final_data+63]
    RIP: ffffffffc06ab54f  RSP: ffffb9e08698fd68  RFLAGS: 00010246
    RAX: 0000000000000000  RBX: ffff8c8845a5a000  RCX: 0000000000000004
    RDX: 0000000000000000  RSI: ffff8c8b9153d000  RDI: ffff8c8845a5a000
    RBP: ffffb9e08698fe40   R8: 00000000000330e0   R9: ffffffffc0675c94
    R10: ffffb9e08698fe58  R11: 0000000000000001  R12: ffff8c8b9cbf6200
    R13: 0000000000000000  R14: 0000000000000000  R15: ffff8c8b2026da0b
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffffb9e08698fda8] hci_event_packet at ffffffffc0676904 [bluetooth]
 #8 [ffffb9e08698fe50] hci_rx_work at ffffffffc06629ac [bluetooth]
 #9 [ffffb9e08698fe98] process_one_work at ffffffffb66f95e7

hcon->amp_mgr seems NULL triggered kernel panic in following line inside
function amp_read_loc_assoc_final_data

        set_bit(READ_LOC_AMP_ASSOC_FINAL, &mgr->state);

Fixed by checking NULL for mgr.

Signed-off-by: Gopal Tiwari <gtiwari@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/amp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/amp.c b/net/bluetooth/amp.c
index e32f34189007..b01b43ab6f83 100644
--- a/net/bluetooth/amp.c
+++ b/net/bluetooth/amp.c
@@ -305,6 +305,9 @@ void amp_read_loc_assoc_final_data(struct hci_dev *hdev,
 	struct hci_request req;
 	int err = 0;
 
+	if (!mgr)
+		return;
+
 	cp.phy_handle = hcon->handle;
 	cp.len_so_far = cpu_to_le16(0);
 	cp.max_len = cpu_to_le16(hdev->amp_assoc_size);
-- 
2.30.1



