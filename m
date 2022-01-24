Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED85498D74
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351808AbiAXTcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344991AbiAXT3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:29:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312ADC061368;
        Mon, 24 Jan 2022 11:13:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3B71B8122F;
        Mon, 24 Jan 2022 19:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A15C340E5;
        Mon, 24 Jan 2022 19:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051598;
        bh=MouureKsaSP7tMgNm+xCoUVff72Se1F9IIFgBjduPQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twigKzCqWOw5A9z4hJheS98Mj3Kr6jE2AHoh+thrGpNC8p9H2X6jT5YdZd69/r+mG
         nf/VpzypxUYWdPto1mRqs49N7N6QL/gGArVB44X2KQ7CH+p2jq3Pv9tOgTOQeQJdNG
         fuRj5bknIURqwX/0tQEn95s9VT/oRaeilQg7KfaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.19 026/239] f2fs: fix to do sanity check in is_alive()
Date:   Mon, 24 Jan 2022 19:41:04 +0100
Message-Id: <20220124183943.957395248@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit 77900c45ee5cd5da63bd4d818a41dbdf367e81cd upstream.

In fuzzed image, SSA table may indicate that a data block belongs to
invalid node, which node ID is out-of-range (0, 1, 2 or max_nid), in
order to avoid migrating inconsistent data in such corrupted image,
let's do sanity check anyway before data block migration.

Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -589,6 +589,9 @@ static bool is_alive(struct f2fs_sb_info
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 	}
 
+	if (f2fs_check_nid_range(sbi, dni->ino))
+		return false;
+
 	*nofs = ofs_of_node(node_page);
 	source_blkaddr = datablock_addr(NULL, node_page, ofs_in_node);
 	f2fs_put_page(node_page, 1);


