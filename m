Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8510F7F4C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfKKSc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:32:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfKKScx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:32:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CAAB20674;
        Mon, 11 Nov 2019 18:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497172;
        bh=foS21jyDG7+AiNiYalDNGoY+ubZ8bYGRS1cP3+yOoZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbcIsA1VAfQR+ycg9PQQfpgBUZEGbh34YVJgHaHHpFbY2JtGchbCRuvgDEYBDMbqD
         OETS6pblHM2WRC4Xjtmv7WRn4+uMkju/fmdMHh55UVJLJoPW3oHuNDaQPzw3qk6kHH
         WvDK4yKFbUSwSsC+CMOax72IWVHVFraXsi8kxxZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.9 27/65] configfs: Fix bool initialization/comparison
Date:   Mon, 11 Nov 2019 19:28:27 +0100
Message-Id: <20191111181346.107117626@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

commit 3f6928c347707a65cee10a9f54b85ad5fb078b3f upstream.

Bool initializations should use true and false. Bool tests don't need
comparisons.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/configfs/file.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -166,7 +166,7 @@ configfs_read_bin_file(struct file *file
 		retval = -ETXTBSY;
 		goto out;
 	}
-	buffer->read_in_progress = 1;
+	buffer->read_in_progress = true;
 
 	if (buffer->needs_read_fill) {
 		/* perform first read with buf == NULL to get extent */
@@ -325,7 +325,7 @@ configfs_write_bin_file(struct file *fil
 		len = -ETXTBSY;
 		goto out;
 	}
-	buffer->write_in_progress = 1;
+	buffer->write_in_progress = true;
 
 	/* buffer grows? */
 	if (*ppos + count > buffer->bin_buffer_size) {
@@ -429,8 +429,8 @@ static int check_perm(struct inode * ino
 	}
 	mutex_init(&buffer->mutex);
 	buffer->needs_read_fill = 1;
-	buffer->read_in_progress = 0;
-	buffer->write_in_progress = 0;
+	buffer->read_in_progress = false;
+	buffer->write_in_progress = false;
 	buffer->ops = ops;
 	file->private_data = buffer;
 	goto Done;
@@ -488,10 +488,10 @@ static int configfs_release_bin_file(str
 	ssize_t len = 0;
 	int ret;
 
-	buffer->read_in_progress = 0;
+	buffer->read_in_progress = false;
 
 	if (buffer->write_in_progress) {
-		buffer->write_in_progress = 0;
+		buffer->write_in_progress = false;
 
 		len = bin_attr->write(item, buffer->bin_buffer,
 				buffer->bin_buffer_size);


