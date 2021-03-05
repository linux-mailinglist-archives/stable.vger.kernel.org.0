Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92D432E944
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhCEMbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:31:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231710AbhCEMb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:31:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E63C665013;
        Fri,  5 Mar 2021 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947486;
        bh=Mz+lubvSBGbLo+GRYUVMAnYBklGNM92y7SYL1IZQJbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1VZnWJ0RlXwISqOAwi2UyxkiYy11eEQ/RlP7+Ai5t6F9YvX9hPk5XvzSxaV35940
         BB9jUveG64ha0VYH4NWL4zPShu2w55iVDCFVufHxNMPtKB7YofhO4WF14u/g3d/nzr
         92JhYZrbMbxFlkL39z1+AxHzSi1e+jcrWsGL3rlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gopal Tiwari <gtiwari@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/102] Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data
Date:   Fri,  5 Mar 2021 13:21:11 +0100
Message-Id: <20210305120905.851869511@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
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
index 9c711f0dfae3..be2d469d6369 100644
--- a/net/bluetooth/amp.c
+++ b/net/bluetooth/amp.c
@@ -297,6 +297,9 @@ void amp_read_loc_assoc_final_data(struct hci_dev *hdev,
 	struct hci_request req;
 	int err;
 
+	if (!mgr)
+		return;
+
 	cp.phy_handle = hcon->handle;
 	cp.len_so_far = cpu_to_le16(0);
 	cp.max_len = cpu_to_le16(hdev->amp_assoc_size);
-- 
2.30.1



