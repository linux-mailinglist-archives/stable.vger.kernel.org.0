Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63F23C5071
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241607AbhGLHcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345220AbhGLH3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B14E86162D;
        Mon, 12 Jul 2021 07:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074773;
        bh=yDKKkLbLvZHkjEhLE8CA+rE3DY6EHc3b7WO5+7l+mkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eX2OTJbQAQUVHhc5r2i06sNbZibLuitPu8KWF8sVjKbQEshceBciGSIWPPQ16mgji
         yzQNL8UHe9DG8Z+lZR2jVJchgpWl81IluAeC5vY0o9RmUjKUkFY2CT1pjmO5H2Jgwu
         fhfbDu3UW/R/KrRTAOdP9KhgZPIJDuM3dC7yXPyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 5.12 692/700] erofs: fix error return code in erofs_read_superblock()
Date:   Mon, 12 Jul 2021 08:12:55 +0200
Message-Id: <20210712061049.579863117@linuxfoundation.org>
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
@@ -155,6 +155,7 @@ static int erofs_read_superblock(struct
 			goto out;
 	}
 
+	ret = -EINVAL;
 	blkszbits = dsb->blkszbits;
 	/* 9(512 bytes) + LOG_SECTORS_PER_BLOCK == LOG_BLOCK_SIZE */
 	if (blkszbits != LOG_BLOCK_SIZE) {


