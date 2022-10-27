Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F5360FE83
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbiJ0RGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236978AbiJ0RFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:05:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93A0197FAD
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:05:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55DAF623F7
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6797AC433D6;
        Thu, 27 Oct 2022 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890348;
        bh=JdJn/9o0EpFKbKSqDVyIpUdzwW/fBKH4Ai+3IGpvqaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKfRlmEA+djG65snt7X8X1/VhfEZXiDngyKOCGBkTAAGpAo7wZOmnimmr0QKE1ozN
         LQJ5y1sHQk8ndUn3dyldCp/jEhMHD5V89LggCil53pS2bhwtPsiUanwq1VGcgyaYED
         LjZd5q/Sm5K9L/kOHgTtaWuQDHGkUpOUEW6g/7rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/79] cifs: Fix xid leak in cifs_copy_file_range()
Date:   Thu, 27 Oct 2022 18:55:47 +0200
Message-Id: <20221027165055.626493417@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 9a97df404a402fe1174d2d1119f87ff2a0ca2fe9 ]

If the file is used by swap, before return -EOPNOTSUPP, should
free the xid, otherwise, the xid will be leaked.

Fixes: 4e8aea30f775 ("smb3: enable swap on SMB3 mounts")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index bc957e6ca48b..f442ef8b65da 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1221,8 +1221,11 @@ static ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
 	ssize_t rc;
 	struct cifsFileInfo *cfile = dst_file->private_data;
 
-	if (cfile->swapfile)
-		return -EOPNOTSUPP;
+	if (cfile->swapfile) {
+		rc = -EOPNOTSUPP;
+		free_xid(xid);
+		return rc;
+	}
 
 	rc = cifs_file_copychunk_range(xid, src_file, off, dst_file, destoff,
 					len, flags);
-- 
2.35.1



