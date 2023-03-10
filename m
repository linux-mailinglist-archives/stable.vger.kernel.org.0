Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC386B42AB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbjCJOF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjCJOFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:05:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DBD11564C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:05:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3D8460D29
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CE2C433A0;
        Fri, 10 Mar 2023 14:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457104;
        bh=/cjJdSAhUZSONa21kxmpyuZu0v4WVF2y75F+zuJHNfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpYqhpQTu42ALrBxJewwZ7v2rTiu2kCn50wQrOOtPrLiGRrdriceEX85nKad1GV8Y
         E6+IFJj/H4zzR4XxvQot7PlcHxRAps8ojCFRJuKPZb7SahZ8p1+CyoDLDG9sa6JTjX
         9xWOG4VEfwQnIqK6R9UrT2IU49LXAUx+tCF9kxZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yangtao Li <frank.li@vivo.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/200] f2fs: allow set compression option of files without blocks
Date:   Fri, 10 Mar 2023 14:37:08 +0100
Message-Id: <20230310133717.698188075@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit e6261beb0c629403dc58997294dd521bd23664af ]

Files created by truncate have a size but no blocks, so
they can be allowed to set compression option.

Fixes: e1e8debec656 ("f2fs: add F2FS_IOC_SET_COMPRESS_OPTION ioctl")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7bb0c05e943cf..88eecd7149cd5 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3937,7 +3937,7 @@ static int f2fs_ioc_set_compress_option(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (inode->i_size != 0) {
+	if (F2FS_HAS_BLOCKS(inode)) {
 		ret = -EFBIG;
 		goto out;
 	}
-- 
2.39.2



