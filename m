Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC3C6AEC55
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjCGRyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjCGRxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:53:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9ED455047
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:48:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76898614B5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762B2C433EF;
        Tue,  7 Mar 2023 17:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211320;
        bh=E6z6rz0dQnw2nsSMO4qKxHhvPbdDUHaJhcMXbG3YpsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfdI1BkwftFz50iRThWLAdlCyRBBefPsYUXQhAw62a76LhJ0RjXKhygi2khuP3vOQ
         /mGMYrZR5q0GHX0t6OzWSUsJ0oajvONWXoPZ9kY4ybpM3shm/Nf0wEK+i17RyJ7925
         1CYxoqsTOPV33Bb4E1IUDXh3hpLlYuTpXhJN0m+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuezhang Mo <Yuezhang.Mo@sony.com>,
        Andy Wu <Andy.Wu@sony.com>,
        Aoyama Wataru <wataru.aoyama@sony.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.2 0793/1001] exfat: fix reporting fs error when reading dir beyond EOF
Date:   Tue,  7 Mar 2023 17:59:25 +0100
Message-Id: <20230307170056.164448205@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit 706fdcac002316893434d753be8cfb549fe1d40d upstream.

Since seekdir() does not check whether the position is valid, the
position may exceed the size of the directory. We found that for
a directory with discontinuous clusters, if the position exceeds
the size of the directory and the excess size is greater than or
equal to the cluster size, exfat_readdir() will return -EIO,
causing a file system error and making the file system unavailable.

Reproduce this bug by:

seekdir(dir, dir_size + cluster_size);
dirent = readdir(dir);

The following log will be printed if mount with 'errors=remount-ro'.

[11166.712896] exFAT-fs (sdb1): error, invalid access to FAT (entry 0xffffffff)
[11166.712905] exFAT-fs (sdb1): Filesystem has been set read-only

Fixes: 1e5654de0f51 ("exfat: handle wrong stream entry size in exfat_readdir()")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Andy Wu <Andy.Wu@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -100,7 +100,7 @@ static int exfat_readdir(struct inode *i
 			clu.dir = ei->hint_bmap.clu;
 		}
 
-		while (clu_offset > 0) {
+		while (clu_offset > 0 && clu.dir != EXFAT_EOF_CLUSTER) {
 			if (exfat_get_next_cluster(sb, &(clu.dir)))
 				return -EIO;
 


