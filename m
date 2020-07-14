Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2221C21FB63
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731330AbgGNTAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731326AbgGNTAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 15:00:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60C1922507;
        Tue, 14 Jul 2020 19:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753203;
        bh=uCmkHrA9W1woj+zxRdjrTWe3xUJXJ9PDW2gEo6jLwxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyg95FYXd+M/5Ua9/Vt2YUvqdDY/3zrLtZPZgqZbsqHAsccVkHxyULTcSq8KKyuHY
         jMb0GBUwS+rd8yigFvaqGabnd5lPekFVEozn0PyQyRl9ZmFPPvqSLcNpevW1gbxMry
         DbzGPJwJITi64lXXEA/pW3NqGCarEHLRXDe6B9pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jessica Yu <jeyu@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.7 129/166] module: Refactor section attr into bin attribute
Date:   Tue, 14 Jul 2020 20:44:54 +0200
Message-Id: <20200714184122.010782230@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit ed66f991bb19d94cae5d38f77de81f96aac7813f upstream.

In order to gain access to the open file's f_cred for kallsym visibility
permission checks, refactor the module section attributes to use the
bin_attribute instead of attribute interface. Additionally removes the
redundant "name" struct member.

Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Jessica Yu <jeyu@kernel.org>
Acked-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |   45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1507,8 +1507,7 @@ static inline bool sect_empty(const Elf_
 }
 
 struct module_sect_attr {
-	struct module_attribute mattr;
-	char *name;
+	struct bin_attribute battr;
 	unsigned long address;
 };
 
@@ -1518,11 +1517,16 @@ struct module_sect_attrs {
 	struct module_sect_attr attrs[];
 };
 
-static ssize_t module_sect_show(struct module_attribute *mattr,
-				struct module_kobject *mk, char *buf)
+static ssize_t module_sect_read(struct file *file, struct kobject *kobj,
+				struct bin_attribute *battr,
+				char *buf, loff_t pos, size_t count)
 {
 	struct module_sect_attr *sattr =
-		container_of(mattr, struct module_sect_attr, mattr);
+		container_of(battr, struct module_sect_attr, battr);
+
+	if (pos != 0)
+		return -EINVAL;
+
 	return sprintf(buf, "0x%px\n", kptr_restrict < 2 ?
 		       (void *)sattr->address : NULL);
 }
@@ -1532,7 +1536,7 @@ static void free_sect_attrs(struct modul
 	unsigned int section;
 
 	for (section = 0; section < sect_attrs->nsections; section++)
-		kfree(sect_attrs->attrs[section].name);
+		kfree(sect_attrs->attrs[section].battr.attr.name);
 	kfree(sect_attrs);
 }
 
@@ -1541,42 +1545,41 @@ static void add_sect_attrs(struct module
 	unsigned int nloaded = 0, i, size[2];
 	struct module_sect_attrs *sect_attrs;
 	struct module_sect_attr *sattr;
-	struct attribute **gattr;
+	struct bin_attribute **gattr;
 
 	/* Count loaded sections and allocate structures */
 	for (i = 0; i < info->hdr->e_shnum; i++)
 		if (!sect_empty(&info->sechdrs[i]))
 			nloaded++;
 	size[0] = ALIGN(struct_size(sect_attrs, attrs, nloaded),
-			sizeof(sect_attrs->grp.attrs[0]));
-	size[1] = (nloaded + 1) * sizeof(sect_attrs->grp.attrs[0]);
+			sizeof(sect_attrs->grp.bin_attrs[0]));
+	size[1] = (nloaded + 1) * sizeof(sect_attrs->grp.bin_attrs[0]);
 	sect_attrs = kzalloc(size[0] + size[1], GFP_KERNEL);
 	if (sect_attrs == NULL)
 		return;
 
 	/* Setup section attributes. */
 	sect_attrs->grp.name = "sections";
-	sect_attrs->grp.attrs = (void *)sect_attrs + size[0];
+	sect_attrs->grp.bin_attrs = (void *)sect_attrs + size[0];
 
 	sect_attrs->nsections = 0;
 	sattr = &sect_attrs->attrs[0];
-	gattr = &sect_attrs->grp.attrs[0];
+	gattr = &sect_attrs->grp.bin_attrs[0];
 	for (i = 0; i < info->hdr->e_shnum; i++) {
 		Elf_Shdr *sec = &info->sechdrs[i];
 		if (sect_empty(sec))
 			continue;
+		sysfs_bin_attr_init(&sattr->battr);
 		sattr->address = sec->sh_addr;
-		sattr->name = kstrdup(info->secstrings + sec->sh_name,
-					GFP_KERNEL);
-		if (sattr->name == NULL)
+		sattr->battr.attr.name =
+			kstrdup(info->secstrings + sec->sh_name, GFP_KERNEL);
+		if (sattr->battr.attr.name == NULL)
 			goto out;
 		sect_attrs->nsections++;
-		sysfs_attr_init(&sattr->mattr.attr);
-		sattr->mattr.show = module_sect_show;
-		sattr->mattr.store = NULL;
-		sattr->mattr.attr.name = sattr->name;
-		sattr->mattr.attr.mode = S_IRUSR;
-		*(gattr++) = &(sattr++)->mattr.attr;
+		sattr->battr.read = module_sect_read;
+		sattr->battr.size = 3 /* "0x", "\n" */ + (BITS_PER_LONG / 4);
+		sattr->battr.attr.mode = 0400;
+		*(gattr++) = &(sattr++)->battr;
 	}
 	*gattr = NULL;
 
@@ -1666,7 +1669,7 @@ static void add_notes_attrs(struct modul
 			continue;
 		if (info->sechdrs[i].sh_type == SHT_NOTE) {
 			sysfs_bin_attr_init(nattr);
-			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
+			nattr->attr.name = mod->sect_attrs->attrs[loaded].battr.attr.name;
 			nattr->attr.mode = S_IRUGO;
 			nattr->size = info->sechdrs[i].sh_size;
 			nattr->private = (void *) info->sechdrs[i].sh_addr;


