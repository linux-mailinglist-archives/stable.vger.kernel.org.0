Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D313CDBBE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbhGSOtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344086AbhGSOsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2CD5613EE;
        Mon, 19 Jul 2021 15:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708380;
        bh=02+n9T0DAzaZsjEkfSbEp6l5E6mJy6t4MhOi5+aaAC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBSVqEGn0K0USf8q1+MWj7KIzUeWiICn0Y/rIy05E4qyQGaAAdPTkf44MAJeBnTVj
         5GfaF1ivfrUQTadDFx9GTmgK1PSrq/REdambjQ7aC5vcBaNBzglYhN7lJgNYTFreps
         pqru+ythmWfd6NOyqtTNxhznbeZ44Z89ZNbENZEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, marcosfrm <marcosfrm@gmail.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 287/315] f2fs: add MODULE_SOFTDEP to ensure crc32 is included in the initramfs
Date:   Mon, 19 Jul 2021 16:52:56 +0200
Message-Id: <20210719144952.875584075@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
index 990339c538b0..b2c747f53c0c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2896,4 +2896,5 @@ module_exit(exit_f2fs_fs)
 MODULE_AUTHOR("Samsung Electronics's Praesto Team");
 MODULE_DESCRIPTION("Flash Friendly File System");
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: crc32");
 
-- 
2.30.2



