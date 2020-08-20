Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950EE24BD75
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgHTJis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbgHTJin (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7367620724;
        Thu, 20 Aug 2020 09:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916323;
        bh=VppUcPlONVni2nQ4Jyvp0d8kh+BKibzpQqi+FzoPaU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4dtkgnzQMluFf2reMpF3o2fr+bInYtuzxKveEiKIR8JBp1AVcdA0kacW7sD6VM+a
         q1cHGBr8uav4qYEylgrg/qQbXtlkcYdTzfNNatg3UfP2z0rK3CBDposPJyXpfOUNPo
         kNh1pw3xdWGwHZVsaMPioso3jMqutQKmyFLo3LT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jessica Yu <jeyu@kernel.org>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.7 087/204] module: Correctly truncate sysfs sections output
Date:   Thu, 20 Aug 2020 11:19:44 +0200
Message-Id: <20200820091610.686783667@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 11990a5bd7e558e9203c1070fc52fb6f0488e75b upstream.

The only-root-readable /sys/module/$module/sections/$section files
did not truncate their output to the available buffer size. While most
paths into the kernfs read handlers end up using PAGE_SIZE buffers,
it's possible to get there through other paths (e.g. splice, sendfile).
Actually limit the output to the "count" passed into the read function,
and report it back correctly. *sigh*

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/20200805002015.GE23458@shao2-debian
Fixes: ed66f991bb19 ("module: Refactor section attr into bin attribute")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1517,18 +1517,34 @@ struct module_sect_attrs {
 	struct module_sect_attr attrs[];
 };
 
+#define MODULE_SECT_READ_SIZE (3 /* "0x", "\n" */ + (BITS_PER_LONG / 4))
 static ssize_t module_sect_read(struct file *file, struct kobject *kobj,
 				struct bin_attribute *battr,
 				char *buf, loff_t pos, size_t count)
 {
 	struct module_sect_attr *sattr =
 		container_of(battr, struct module_sect_attr, battr);
+	char bounce[MODULE_SECT_READ_SIZE + 1];
+	size_t wrote;
 
 	if (pos != 0)
 		return -EINVAL;
 
-	return sprintf(buf, "0x%px\n",
-		       kallsyms_show_value(file->f_cred) ? (void *)sattr->address : NULL);
+	/*
+	 * Since we're a binary read handler, we must account for the
+	 * trailing NUL byte that sprintf will write: if "buf" is
+	 * too small to hold the NUL, or the NUL is exactly the last
+	 * byte, the read will look like it got truncated by one byte.
+	 * Since there is no way to ask sprintf nicely to not write
+	 * the NUL, we have to use a bounce buffer.
+	 */
+	wrote = scnprintf(bounce, sizeof(bounce), "0x%px\n",
+			 kallsyms_show_value(file->f_cred)
+				? (void *)sattr->address : NULL);
+	count = min(count, wrote);
+	memcpy(buf, bounce, count);
+
+	return count;
 }
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
@@ -1577,7 +1593,7 @@ static void add_sect_attrs(struct module
 			goto out;
 		sect_attrs->nsections++;
 		sattr->battr.read = module_sect_read;
-		sattr->battr.size = 3 /* "0x", "\n" */ + (BITS_PER_LONG / 4);
+		sattr->battr.size = MODULE_SECT_READ_SIZE;
 		sattr->battr.attr.mode = 0400;
 		*(gattr++) = &(sattr++)->battr;
 	}


