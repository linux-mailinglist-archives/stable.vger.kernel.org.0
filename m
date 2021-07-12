Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BDB3C55FC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351093AbhGLIM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354140AbhGLIDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E93D861351;
        Mon, 12 Jul 2021 08:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076820;
        bh=j09TU71SQwlBlRbjUpxbYH/ocXZJ2W5ePea3GPs41VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5i8U9Mt1zMN5KC/oCSI/zBQtXZXvGE0DGWi42E+OU7RxVqHvKOjQyVJtQdBjdtG/
         gPyCVW8ZBCLr0ZU10g4k+Djgf05cBEIwD6Q//hwvMMpNrfGw0TovwF28G8SpdeDL87
         TMTZpD2UDl2bbyTZKo8zGD8SBZxKlOP2JAn73BFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 5.13 792/800] erofs: fix error return code in erofs_read_superblock()
Date:   Mon, 12 Jul 2021 08:13:35 +0200
Message-Id: <20210712061050.983953628@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 0508c1ad0f264a24c4643701823a45f6c9bd8146 upstream.

'ret' will be overwritten to 0 if erofs_sb_has_sb_chksum() return true,
thus 0 will return in some error handling cases. Fix to return negative
error code -EINVAL instead of 0.

Link: https://lore.kernel.org/r/20210519141657.3062715-1-weiyongjun1@huawei.com
Fixes: b858a4844cfb ("erofs: support superblock checksum")
Cc: stable <stable@vger.kernel.org> # 5.5+
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/erofs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -285,6 +285,7 @@ static int erofs_read_superblock(struct
 			goto out;
 	}
 
+	ret = -EINVAL;
 	blkszbits = dsb->blkszbits;
 	/* 9(512 bytes) + LOG_SECTORS_PER_BLOCK == LOG_BLOCK_SIZE */
 	if (blkszbits != LOG_BLOCK_SIZE) {


