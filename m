Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C5A3CDFDA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344939AbhGSPM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245440AbhGSPK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 926BD60FD7;
        Mon, 19 Jul 2021 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709869;
        bh=110oo0bp8XEIgGoX8PuIKeTuPmcHodzQu7MT/F3PYyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVCCLf7KZUmZG26a1XEYtKj5u8CY8J2DjxVPXQyBk6iLYSe2kSjLrCcoSZAEmgLma
         /NvUHUwl6p1Y+74XVS7LeJpk/baX+Qr+5vdmxgfKASXHgh6HD1W9ypkI2ugkOYrHsh
         yqBIpilpNZUzdkHzD2V0Zue8EvoCKKry0yJBS0MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, marcosfrm <marcosfrm@gmail.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/149] f2fs: add MODULE_SOFTDEP to ensure crc32 is included in the initramfs
Date:   Mon, 19 Jul 2021 16:53:25 +0200
Message-Id: <20210719144924.326628728@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 0dd571785d61528d62cdd8aa49d76bc6085152fe ]

As marcosfrm reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=213089

Initramfs generators rely on "pre" softdeps (and "depends") to include
additional required modules.

F2FS does not declare "pre: crc32" softdep. Then every generator (dracut,
mkinitcpio...) has to maintain a hardcoded list for this purpose.

Hence let's use MODULE_SOFTDEP("pre: crc32") in f2fs code.

Fixes: 43b6573bac95 ("f2fs: use cryptoapi crc32 functions")
Reported-by: marcosfrm <marcosfrm@gmail.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index a9a083232bcf..6d904dc9bd19 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3804,4 +3804,5 @@ module_exit(exit_f2fs_fs)
 MODULE_AUTHOR("Samsung Electronics's Praesto Team");
 MODULE_DESCRIPTION("Flash Friendly File System");
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: crc32");
 
-- 
2.30.2



