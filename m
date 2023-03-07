Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE9B6AF51C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbjCGTWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbjCGTV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:21:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C21DC6E59
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:06:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C7A261535
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC26C433D2;
        Tue,  7 Mar 2023 19:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216012;
        bh=VgJrCC+0Y6y2sUlpxGFNj8ynHSGMr7Hf4DF1G68plp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHSG5VHNQJ7pd8B4e0THsR8t4zJO77lsXwh2HPl0+jGxSB+mFtTv1dxbyJaZC4q2R
         dwzOqehKKo5ZOTfsKir6I/eqFk1igIOeeqzwVNMcGqOEa0DkxEx0BpYxotRx94EneG
         fsJOfGUlo9ZbxSo/3T4CpGJiQ0lSuvXlwxS3pNsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yugui <wangyugui@e16-tech.com>,
        Yuezhang Mo <Yuezhang.Mo@sony.com>, Andy Wu <Andy.Wu@sony.com>,
        Aoyama Wataru <wataru.aoyama@sony.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.15 447/567] exfat: fix unexpected EOF while reading dir
Date:   Tue,  7 Mar 2023 18:03:03 +0100
Message-Id: <20230307165925.282471290@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit 6cb5d1a16a51d080fbc1649a5144cbc5ca7d6f88 upstream.

If the position is not aligned with the dentry size, the return
value of readdir() will be NULL and errno is 0, which means the
end of the directory stream is reached.

If the position is aligned with dentry size, but there is no file
or directory at the position, exfat_readdir() will continue to
get dentry from the next dentry. So the dentry gotten by readdir()
may not be at the position.

After this commit, if the position is not aligned with the dentry
size, round the position up to the dentry size and continue to get
the dentry.

Fixes: ca06197382bd ("exfat: add directory operations")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Andy Wu <Andy.Wu@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -237,10 +237,7 @@ static int exfat_iterate(struct file *fi
 		fake_offset = 1;
 	}
 
-	if (cpos & (DENTRY_SIZE - 1)) {
-		err = -ENOENT;
-		goto unlock;
-	}
+	cpos = round_up(cpos, DENTRY_SIZE);
 
 	/* name buffer should be allocated before use */
 	err = exfat_alloc_namebuf(nb);


