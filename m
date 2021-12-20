Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A980B47AD52
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbhLTOvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbhLTOtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:49:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEC3C0698E1;
        Mon, 20 Dec 2021 06:45:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A237EB80EDE;
        Mon, 20 Dec 2021 14:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D724EC36AE7;
        Mon, 20 Dec 2021 14:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011552;
        bh=V4GqflV3AlP32vlL9/+C6LHJfIAGH73xS3RdViezQrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlVW953gjHLV5L1MA+7yVhA2mpIZwsE1mokf24EOuB0EIJb2Wjv5dum6G1eUUAkrR
         d7cRgN8YBXld7ulP87rik4l4v/47xebHNXhYFXTgkLi8aR6R+UScMzGMgH6fpAN+Hn
         sUrYstTAudz3LcdBPW/DK5U2np8wA3o5HPhBU0hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+9f747458f5990eaa8d43@syzkaller.appspotmail.com
Subject: [PATCH 5.4 60/71] fuse: annotate lock in fuse_reverse_inval_entry()
Date:   Mon, 20 Dec 2021 15:34:49 +0100
Message-Id: <20211220143027.712243254@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit bda9a71980e083699a0360963c0135657b73f47a upstream.

Add missing inode lock annotatation; found by syzbot.

Reported-and-tested-by: syzbot+9f747458f5990eaa8d43@syzkaller.appspotmail.com
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1032,7 +1032,7 @@ int fuse_reverse_inval_entry(struct supe
 	if (!parent)
 		return -ENOENT;
 
-	inode_lock(parent);
+	inode_lock_nested(parent, I_MUTEX_PARENT);
 	if (!S_ISDIR(parent->i_mode))
 		goto unlock;
 


