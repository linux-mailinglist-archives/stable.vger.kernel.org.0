Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAC8119B6F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfLJWHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:07:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728863AbfLJWE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:04:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9418920637;
        Tue, 10 Dec 2019 22:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015498;
        bh=09sbiJ3mvra8Nr6qRvwY9YfTmMuj4PlX8GJhh4fE1IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEdMAqvOtLQpSnZDjSQ0cuSUr1CnX/efNAconsxMd+9ixeJ535mFx+0w+8JzK5LwV
         wmRkNoOjitshTnEJtKAhTfhXhR5xoAKtFLuW5Uv9l4mIC0mg4x9cSeSwa1MsvChOrX
         RDAmQaWSmaXKfB2le/QlYqyT8sK8bIb/Jo7q+CBU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>, Joel Stanley <joel@jms.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsi@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 098/130] fsi: core: Fix small accesses and unaligned offsets via sysfs
Date:   Tue, 10 Dec 2019 17:02:29 -0500
Message-Id: <20191210220301.13262-98-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

[ Upstream commit 9f4c2b516b4f031e3cd0e45957f4150b3c1a083d ]

Subtracting the offset delta from four-byte alignment lead to wrapping
of the requested length where `count` is less than `off`. Generalise the
length handling to enable and optimise aligned access sizes for all
offset and size combinations. The new formula produces the following
results for given offset and count values:

    offset  count | length
    --------------+-------
    0       1     | 1
    0       2     | 2
    0       3     | 2
    0       4     | 4
    0       5     | 4
    1       1     | 1
    1       2     | 1
    1       3     | 1
    1       4     | 1
    1       5     | 1
    2       1     | 1
    2       2     | 2
    2       3     | 2
    2       4     | 2
    2       5     | 2
    3       1     | 1
    3       2     | 1
    3       3     | 1
    3       4     | 1
    3       5     | 1

We might need something like this for the cfam chardevs as well, for
example we don't currently implement any alignment restrictions /
handling in the hardware master driver.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20191108051945.7109-6-joel@jms.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-core.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/fsi/fsi-core.c b/drivers/fsi/fsi-core.c
index 4ea63d9bd1315..8feca59c1f6b0 100644
--- a/drivers/fsi/fsi-core.c
+++ b/drivers/fsi/fsi-core.c
@@ -419,6 +419,31 @@ static int fsi_slave_scan(struct fsi_slave *slave)
 	return 0;
 }
 
+static unsigned long aligned_access_size(size_t offset, size_t count)
+{
+	unsigned long offset_unit, count_unit;
+
+	/* Criteria:
+	 *
+	 * 1. Access size must be less than or equal to the maximum access
+	 *    width or the highest power-of-two factor of offset
+	 * 2. Access size must be less than or equal to the amount specified by
+	 *    count
+	 *
+	 * The access width is optimal if we can calculate 1 to be strictly
+	 * equal while still satisfying 2.
+	 */
+
+	/* Find 1 by the bottom bit of offset (with a 4 byte access cap) */
+	offset_unit = BIT(__builtin_ctzl(offset | 4));
+
+	/* Find 2 by the top bit of count */
+	count_unit = BIT(8 * sizeof(unsigned long) - 1 - __builtin_clzl(count));
+
+	/* Constrain the maximum access width to the minimum of both criteria */
+	return BIT(__builtin_ctzl(offset_unit | count_unit));
+}
+
 static ssize_t fsi_slave_sysfs_raw_read(struct file *file,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
 		loff_t off, size_t count)
@@ -434,8 +459,7 @@ static ssize_t fsi_slave_sysfs_raw_read(struct file *file,
 		return -EINVAL;
 
 	for (total_len = 0; total_len < count; total_len += read_len) {
-		read_len = min_t(size_t, count, 4);
-		read_len -= off & 0x3;
+		read_len = aligned_access_size(off, count - total_len);
 
 		rc = fsi_slave_read(slave, off, buf + total_len, read_len);
 		if (rc)
@@ -462,8 +486,7 @@ static ssize_t fsi_slave_sysfs_raw_write(struct file *file,
 		return -EINVAL;
 
 	for (total_len = 0; total_len < count; total_len += write_len) {
-		write_len = min_t(size_t, count, 4);
-		write_len -= off & 0x3;
+		write_len = aligned_access_size(off, count - total_len);
 
 		rc = fsi_slave_write(slave, off, buf + total_len, write_len);
 		if (rc)
-- 
2.20.1

