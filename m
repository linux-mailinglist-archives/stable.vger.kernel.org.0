Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398D02E4112
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440047AbgL1ONG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440042AbgL1ONG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B2B3206E5;
        Mon, 28 Dec 2020 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164746;
        bh=kMBpl3mriyFVPMZ7QTYRs14rMU1WvrC9xKG598VRvrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eV7BkMnvtP8d4SfP9IZ08qcw8CKnIJHh8l7TvWX3kcnhObEMCpKNZRw3YM7/MJ1Hm
         Qk6HebTVTfRkpIrpnMT/7FPJQsOmXw0FWlmC9ibYHRSaNeu+AqNWNfJMI7woCLpVBq
         X+qsSwlqI0YFjdKuWOX7ya84j995CzdnWAOtItFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeongseok Kim <hyeongseok@gmail.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/717] f2fs: fix double free of unicode map
Date:   Mon, 28 Dec 2020 13:44:34 +0100
Message-Id: <20201228125034.239891216@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyeongseok Kim <hyeongseok@gmail.com>

[ Upstream commit 89ff6005039a878afac87889fee748fa3f957c3a ]

In case of retrying fill_super with skip_recovery,
s_encoding for casefold would not be loaded again even though it's
already been freed because it's not NULL.
Set NULL after free to prevent double freeing when unmount.

Fixes: eca4873ee1b6 ("f2fs: Use generic casefolding support")
Signed-off-by: Hyeongseok Kim <hyeongseok@gmail.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 00eff2f518079..fef22e476c526 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3918,6 +3918,7 @@ free_bio_info:
 
 #ifdef CONFIG_UNICODE
 	utf8_unload(sb->s_encoding);
+	sb->s_encoding = NULL;
 #endif
 free_options:
 #ifdef CONFIG_QUOTA
-- 
2.27.0



