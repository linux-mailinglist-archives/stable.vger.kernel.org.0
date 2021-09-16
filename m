Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F3740E4F8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348284AbhIPRGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349281AbhIPRD4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFF3D6187C;
        Thu, 16 Sep 2021 16:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810090;
        bh=c7fUCHeXoCaLMfyJzYxzKjsaNOBLhp+B2S0ZdKjyg58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jD1HY7KFGgpEapA9d13uvADEB7v4rRe7YftF4Vdn3kWOnwPCoOX9o0xIR0XPx5Zfu
         Hq2D825WrF2NINa5ipB2FxEeamKVthaGCklJwYcfrMlOAW2wsCY6IdLQoMfImMQhXL
         ZLMvBu1YXIIUipEmK/uXzQcecgBAdGhRK5qhurwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.14 014/432] btrfs: zoned: suppress reclaim error message on EAGAIN
Date:   Thu, 16 Sep 2021 17:56:03 +0200
Message-Id: <20210916155811.300358700@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit ba86dd9fe60e5853fbff96f2658212908b83f271 upstream.

btrfs_relocate_chunk() can fail with -EAGAIN when e.g. send operations are
running. The message can fail btrfs/187 and it's unnecessary because we
anyway add it back to the reclaim list.

btrfs_reclaim_bgs_work()
`-> btrfs_relocate_chunk()
    `-> btrfs_relocate_block_group()
        `-> reloc_chunk_start()
            `-> if (fs_info->send_in_progress)
                `-> return -EAGAIN

CC: stable@vger.kernel.org # 5.13+
Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1561,7 +1561,7 @@ void btrfs_reclaim_bgs_work(struct work_
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
-		if (ret)
+		if (ret && ret != -EAGAIN)
 			btrfs_err(fs_info, "error relocating chunk %llu",
 				  bg->start);
 


