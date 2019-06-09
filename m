Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8795A3AADC
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbfFIQoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbfFIQop (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:44:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46CDE20840;
        Sun,  9 Jun 2019 16:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098683;
        bh=Ogzjc3C2xWfFhaXTGfD5u07gvhsn1/HdRtF5KCmyYXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i34JSH9IULshw/jPOoWPYaJyNLYJIam5IevcOJNqkmu6faQtZhnyjJgk2SujuaqvA
         XWVFSq/gNUzcgLkqdEtLArb1OGMWRRgNjZCWylkoNmYwuwwWQ6s2zTg3ioFIV/cYyf
         C/cb7rMtl2otBDEL3yF/Q/gDiybZS2fjHfgxcjYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Oded Gabbay <oded.gabbay@gmail.com>
Subject: [PATCH 5.1 23/70] habanalabs: fix debugfs code
Date:   Sun,  9 Jun 2019 18:41:34 +0200
Message-Id: <20190609164128.965284718@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 8438846cce61e284a22316c13aa4b63772963070 upstream.

This fixes multiple things in the habanalabs debugfs code, in particular:

 - mmu_write() was unnecessarily verbose, copying around between multiple
   buffers
 - mmu_write() could write a user-specified, unbounded amount of userspace
   memory into a kernel buffer (out-of-bounds write)
 - multiple debugfs read handlers ignored the user-supplied count,
   potentially corrupting out-of-bounds userspace data
 - hl_device_read() was unnecessarily verbose
 - hl_device_write() could read uninitialized stack memory
 - multiple debugfs read handlers copied terminating null characters to
   userspace

Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/habanalabs/debugfs.c |   60 +++++++++++---------------------------
 1 file changed, 18 insertions(+), 42 deletions(-)

--- a/drivers/misc/habanalabs/debugfs.c
+++ b/drivers/misc/habanalabs/debugfs.c
@@ -459,41 +459,31 @@ static ssize_t mmu_write(struct file *fi
 	struct hl_debugfs_entry *entry = s->private;
 	struct hl_dbg_device_entry *dev_entry = entry->dev_entry;
 	struct hl_device *hdev = dev_entry->hdev;
-	char kbuf[MMU_KBUF_SIZE], asid_kbuf[MMU_ASID_BUF_SIZE],
-		addr_kbuf[MMU_ADDR_BUF_SIZE];
+	char kbuf[MMU_KBUF_SIZE];
 	char *c;
 	ssize_t rc;
 
 	if (!hdev->mmu_enable)
 		return count;
 
-	memset(kbuf, 0, sizeof(kbuf));
-	memset(asid_kbuf, 0, sizeof(asid_kbuf));
-	memset(addr_kbuf, 0, sizeof(addr_kbuf));
-
+	if (count > sizeof(kbuf) - 1)
+		goto err;
 	if (copy_from_user(kbuf, buf, count))
 		goto err;
-
-	kbuf[MMU_KBUF_SIZE - 1] = 0;
+	kbuf[count] = 0;
 
 	c = strchr(kbuf, ' ');
 	if (!c)
 		goto err;
+	*c = '\0';
 
-	memcpy(asid_kbuf, kbuf, c - kbuf);
-
-	rc = kstrtouint(asid_kbuf, 10, &dev_entry->mmu_asid);
+	rc = kstrtouint(kbuf, 10, &dev_entry->mmu_asid);
 	if (rc)
 		goto err;
 
-	c = strstr(kbuf, " 0x");
-	if (!c)
+	if (strncmp(c+1, "0x", 2))
 		goto err;
-
-	c += 3;
-	memcpy(addr_kbuf, c, (kbuf + count) - c);
-
-	rc = kstrtoull(addr_kbuf, 16, &dev_entry->mmu_addr);
+	rc = kstrtoull(c+3, 16, &dev_entry->mmu_addr);
 	if (rc)
 		goto err;
 
@@ -525,10 +515,8 @@ static ssize_t hl_data_read32(struct fil
 	}
 
 	sprintf(tmp_buf, "0x%08x\n", val);
-	rc = simple_read_from_buffer(buf, strlen(tmp_buf) + 1, ppos, tmp_buf,
-			strlen(tmp_buf) + 1);
-
-	return rc;
+	return simple_read_from_buffer(buf, count, ppos, tmp_buf,
+			strlen(tmp_buf));
 }
 
 static ssize_t hl_data_write32(struct file *f, const char __user *buf,
@@ -559,7 +547,6 @@ static ssize_t hl_get_power_state(struct
 	struct hl_dbg_device_entry *entry = file_inode(f)->i_private;
 	struct hl_device *hdev = entry->hdev;
 	char tmp_buf[200];
-	ssize_t rc;
 	int i;
 
 	if (*ppos)
@@ -574,10 +561,8 @@ static ssize_t hl_get_power_state(struct
 
 	sprintf(tmp_buf,
 		"current power state: %d\n1 - D0\n2 - D3hot\n3 - Unknown\n", i);
-	rc = simple_read_from_buffer(buf, strlen(tmp_buf) + 1, ppos, tmp_buf,
-			strlen(tmp_buf) + 1);
-
-	return rc;
+	return simple_read_from_buffer(buf, count, ppos, tmp_buf,
+			strlen(tmp_buf));
 }
 
 static ssize_t hl_set_power_state(struct file *f, const char __user *buf,
@@ -630,8 +615,8 @@ static ssize_t hl_i2c_data_read(struct f
 	}
 
 	sprintf(tmp_buf, "0x%02x\n", val);
-	rc = simple_read_from_buffer(buf, strlen(tmp_buf) + 1, ppos, tmp_buf,
-			strlen(tmp_buf) + 1);
+	rc = simple_read_from_buffer(buf, count, ppos, tmp_buf,
+			strlen(tmp_buf));
 
 	return rc;
 }
@@ -720,18 +705,9 @@ static ssize_t hl_led2_write(struct file
 static ssize_t hl_device_read(struct file *f, char __user *buf,
 					size_t count, loff_t *ppos)
 {
-	char tmp_buf[200];
-	ssize_t rc;
-
-	if (*ppos)
-		return 0;
-
-	sprintf(tmp_buf,
-		"Valid values: disable, enable, suspend, resume, cpu_timeout\n");
-	rc = simple_read_from_buffer(buf, strlen(tmp_buf) + 1, ppos, tmp_buf,
-			strlen(tmp_buf) + 1);
-
-	return rc;
+	static const char *help =
+		"Valid values: disable, enable, suspend, resume, cpu_timeout\n";
+	return simple_read_from_buffer(buf, count, ppos, help, strlen(help));
 }
 
 static ssize_t hl_device_write(struct file *f, const char __user *buf,
@@ -739,7 +715,7 @@ static ssize_t hl_device_write(struct fi
 {
 	struct hl_dbg_device_entry *entry = file_inode(f)->i_private;
 	struct hl_device *hdev = entry->hdev;
-	char data[30];
+	char data[30] = {0};
 
 	/* don't allow partial writes */
 	if (*ppos != 0)


