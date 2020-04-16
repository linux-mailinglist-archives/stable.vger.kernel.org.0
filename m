Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130801AC714
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394716AbgDPOtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729446AbgDPN6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:58:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2BEE217D8;
        Thu, 16 Apr 2020 13:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045520;
        bh=oLa9ZCMXCNwNPdswBzANyD/1hXfKDvp9bSGTKy6lpvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSboMxJtAa6CMpKrGWGVDNCZXCiwoYAO8Oh10IyZcqpwGnjXLjMiWZtNbmjz3rzQ2
         A5H4wgUuWHrmXwUf7phJ0JCXvzERfQO5TGgurs9uCyBXyi0uOskSUOkpoNCd+hih7U
         Xy9R2TW4CxxD22xY/ZqhKaXzYOMXy5G+GK3MKnZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.6 141/254] CIFS: check new file size when extending file by fallocate
Date:   Thu, 16 Apr 2020 15:23:50 +0200
Message-Id: <20200416131344.104090672@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murphy Zhou <jencce.kernel@gmail.com>

commit ef4a632ccc1c7d3fb71a5baae85b79af08b7f94b upstream.

xfstests generic/228 checks if fallocate respect RLIMIT_FSIZE.
After fallocate mode 0 extending enabled, we can hit this failure.
Fix this by check the new file size with vfs helper, return
error if file size is larger then RLIMIT_FSIZE(ulimit -f).

This patch has been tested by LTP/xfstests aginst samba and
Windows server.

Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3248,6 +3248,10 @@ static long smb3_simple_falloc(struct fi
 	 * Extending the file
 	 */
 	if ((keep_size == false) && i_size_read(inode) < off + len) {
+		rc = inode_newsize_ok(inode, off + len);
+		if (rc)
+			goto out;
+
 		if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 


