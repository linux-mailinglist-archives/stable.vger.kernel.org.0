Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D534637874C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbhEJLPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236262AbhEJLHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD59561950;
        Mon, 10 May 2021 10:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644359;
        bh=VLE268kWePSI0MiZDfGsv3AHUcVG9PKYagKrLdX4TgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTqj4D6Gvz3F9JhRL8W5t/IKEBcNaoPMBWz5A9JuBY4TztY3bBXBlU/Mm8kFq0UfE
         wFnEBd5SrqD1EpExfkp+qJiRip6bnnU9BA994U5U/cOxZ49QBV74rjO+3lPWaGVQnb
         MS9cQl8br1/fbsoUAGC3/JjZbHJ+/YLRKcs6kfJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Aurich <paul@darkrain42.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.12 051/384] cifs: Return correct error code from smb2_get_enc_key
Date:   Mon, 10 May 2021 12:17:20 +0200
Message-Id: <20210510102016.562151159@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Aurich <paul@darkrain42.org>

commit 83728cbf366e334301091d5b808add468ab46b27 upstream.

Avoid a warning if the error percolates back up:

[440700.376476] CIFS VFS: \\otters.example.com crypt_message: Could not get encryption key
[440700.386947] ------------[ cut here ]------------
[440700.386948] err = 1
[440700.386977] WARNING: CPU: 11 PID: 2733 at /build/linux-hwe-5.4-p6lk6L/linux-hwe-5.4-5.4.0/lib/errseq.c:74 errseq_set+0x5c/0x70
...
[440700.397304] CPU: 11 PID: 2733 Comm: tar Tainted: G           OE     5.4.0-70-generic #78~18.04.1-Ubuntu
...
[440700.397334] Call Trace:
[440700.397346]  __filemap_set_wb_err+0x1a/0x70
[440700.397419]  cifs_writepages+0x9c7/0xb30 [cifs]
[440700.397426]  do_writepages+0x4b/0xe0
[440700.397444]  __filemap_fdatawrite_range+0xcb/0x100
[440700.397455]  filemap_write_and_wait+0x42/0xa0
[440700.397486]  cifs_setattr+0x68b/0xf30 [cifs]
[440700.397493]  notify_change+0x358/0x4a0
[440700.397500]  utimes_common+0xe9/0x1c0
[440700.397510]  do_utimes+0xc5/0x150
[440700.397520]  __x64_sys_utimensat+0x88/0xd0

Fixes: 61cfac6f267d ("CIFS: Fix possible use after free in demultiplex thread")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
CC: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4178,7 +4178,7 @@ smb2_get_enc_key(struct TCP_Server_Info
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	return 1;
+	return -EAGAIN;
 }
 /*
  * Encrypt or decrypt @rqst message. @rqst[0] has the following format:


