Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9A2498EBD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiAXTsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:48:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60392 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347600AbiAXTmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:42:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58126B8119D;
        Mon, 24 Jan 2022 19:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5DFC340E5;
        Mon, 24 Jan 2022 19:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053352;
        bh=SyEdvlIgdapcfev2ctZErMQFIAJu2b7NoRGv//Ys/ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJwYLrta7qz5RQZF7fLEKwfZj/wrJHQcbN2QNlagzK9jcKTSSVWlIBiPuGfCmXemJ
         aDz0HOzymOZL18vR9/n8BqMisRxbkygbtdjh6dxu3fai09ese6vZPRfhqZ6ykVStoL
         mLEYH2RFiCtL6ynN7uWNaEmnMviqCsP3gyxnZgXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 006/563] f2fs: fix to do sanity check in is_alive()
Date:   Mon, 24 Jan 2022 19:36:11 +0100
Message-Id: <20220124184024.626499753@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -998,6 +998,9 @@ static bool is_alive(struct f2fs_sb_info
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 	}
 
+	if (f2fs_check_nid_range(sbi, dni->ino))
+		return false;
+
 	*nofs = ofs_of_node(node_page);
 	source_blkaddr = data_blkaddr(NULL, node_page, ofs_in_node);
 	f2fs_put_page(node_page, 1);


