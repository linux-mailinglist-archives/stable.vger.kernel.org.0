Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F837CA71C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405953AbfJCQum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405948AbfJCQuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:50:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B17620865;
        Thu,  3 Oct 2019 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121440;
        bh=u0uuZNqbC5y4WeD1oLHRxcr3SNy3Eqtmb8PtIZipKPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWycyvCJH1S4/bTviqedA8axPD9uWS4VF2XW0ZIcq6Dilza8mfqB+qgC2c+ZHOZzc
         BDQBqCIJwrBiHZxvheKAXtrfM/3UDGsSCHXphijEmd0BgA2H26ShDuNUYPFl3VUcRM
         0yHNm143ofM2bGUXO6cY3Jb90197gZM7whq0P95Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 5.3 279/344] staging: erofs: cannot set EROFS_V_Z_INITED_BIT if fill_inode_lazy fails
Date:   Thu,  3 Oct 2019 17:54:04 +0200
Message-Id: <20191003154607.555887592@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

commit 3407a4198faf01c9d7596c45b8606834b8dfc2b7 upstream.

As reported by erofs-utils fuzzer, unsupported compressed
clustersize will make fill_inode_lazy fail, for such case
we cannot set EROFS_V_Z_INITED_BIT since we need return
failure for each z_erofs_map_blocks_iter().

Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
Cc: <stable@vger.kernel.org> # 5.3+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-3-gaoxiang25@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/erofs/zmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/staging/erofs/zmap.c
+++ b/drivers/staging/erofs/zmap.c
@@ -86,12 +86,11 @@ static int fill_inode_lazy(struct inode
 
 	vi->z_physical_clusterbits[1] = vi->z_logical_clusterbits +
 					((h->h_clusterbits >> 5) & 7);
+	set_bit(EROFS_V_Z_INITED_BIT, &vi->flags);
 unmap_done:
 	kunmap_atomic(kaddr);
 	unlock_page(page);
 	put_page(page);
-
-	set_bit(EROFS_V_Z_INITED_BIT, &vi->flags);
 out_unlock:
 	clear_and_wake_up_bit(EROFS_V_BL_Z_BIT, &vi->flags);
 	return err;


