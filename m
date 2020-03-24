Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72126190F3A
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgCXNSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbgCXNSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:18:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59EB6208CA;
        Tue, 24 Mar 2020 13:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055921;
        bh=3xKCGL/877hOHYYGSIi4/wtE52CtmJLcJjSARUxwV4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKOZTK024uRLe744YfAMoYwdB93khYKWQV57LGWuOfRhtrfG/q+y2rdf2FZaO4hNG
         d7sofPwOgJMngreWxEo7RuZF4OVzBHo4cjx3ATYH6eSF0ntsOOlJ/6sN157VbHFuB8
         LyMF8Dq8bLzTOWqi5lF/+x09/eB7nSEprdSzz3Hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.4 068/102] CIFS: fiemap: do not return EINVAL if get nothing
Date:   Tue, 24 Mar 2020 14:11:00 +0100
Message-Id: <20200324130813.491114667@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murphy Zhou <jencce.kernel@gmail.com>

commit 979a2665eb6c603ddce0ab374041ab101827b2e7 upstream.

If we call fiemap on a truncated file with none blocks allocated,
it makes sense we get nothing from this call. No output means
no blocks have been counted, but the call succeeded. It's a valid
response.

Simple example reproducer:
xfs_io -f 'truncate 2M' -c 'fiemap -v' /cifssch/testfile
xfs_io: ioctl(FS_IOC_FIEMAP) ["/cifssch/testfile"]: Invalid argument

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3252,7 +3252,7 @@ static int smb3_fiemap(struct cifs_tcon
 	if (rc)
 		goto out;
 
-	if (out_data_len < sizeof(struct file_allocated_range_buffer)) {
+	if (out_data_len && out_data_len < sizeof(struct file_allocated_range_buffer)) {
 		rc = -EINVAL;
 		goto out;
 	}


