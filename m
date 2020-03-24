Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9457719100E
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgCXNY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729153AbgCXNYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D343C20775;
        Tue, 24 Mar 2020 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056273;
        bh=Wb3XSpW7sXPdIm66GfIkxYb52Eo0vBHkMz/ezQ2dpBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZR5jrml/2kyW2oOtUNC1OY3mb2gf4X7jjmqGgnERMtd5hBbXRME58QG6i19W2zvL
         ODmUnY/ugW/GGyFMuK6QQyRvTedVs48yWZSweQ3Q8vN++H8UHYPgbrZaHLu6NqjL+a
         gWp9AkWE4/SB+V8A2q32zUP1cydOcv3IKa2CseKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.5 076/119] CIFS: fiemap: do not return EINVAL if get nothing
Date:   Tue, 24 Mar 2020 14:11:01 +0100
Message-Id: <20200324130816.018090229@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
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
@@ -3315,7 +3315,7 @@ static int smb3_fiemap(struct cifs_tcon
 	if (rc)
 		goto out;
 
-	if (out_data_len < sizeof(struct file_allocated_range_buffer)) {
+	if (out_data_len && out_data_len < sizeof(struct file_allocated_range_buffer)) {
 		rc = -EINVAL;
 		goto out;
 	}


