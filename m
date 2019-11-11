Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2783F7B84
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfKKSg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbfKKSg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:36:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53E61204FD;
        Mon, 11 Nov 2019 18:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497418;
        bh=foS21jyDG7+AiNiYalDNGoY+ubZ8bYGRS1cP3+yOoZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yprp1LpjgkZXf8TpUJX1wUMChql5DAq0ea54pv+0Q2fZ5f76t3Hn+5Hpl1XeVes1q
         +KqtoqhanYtMBaGmi+UV2wElBWtFMDidBUl+AgUOPazSTGndfGfmQAx4ph+g5IdyLN
         OmXZrJy3QwW/VsltHjBKpCBoPQp4/XMym9ApUsBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.14 040/105] configfs: Fix bool initialization/comparison
Date:   Mon, 11 Nov 2019 19:28:10 +0100
Message-Id: <20191111181440.327081692@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
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


