Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78521181E95
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 18:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgCKRCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 13:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729734AbgCKRCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 13:02:54 -0400
Received: from linux-8ccs.suse.de (p5B2812F9.dip0.t-ipconnect.de [91.40.18.249])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B72AD206BE;
        Wed, 11 Mar 2020 17:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583946174;
        bh=amUfcgSakdY7l26R+vimNifS5p83NM/XQAvGVR/k334=;
        h=From:To:Cc:Subject:Date:From;
        b=XB8m/z/xzXp5gGFex83FaswEmVj936r0IAW80OeX6P9zRS08ybz5LqY736RF6vIJ2
         NEdUjjdZmxMbVKFJRI/zy29SiEz2yoy154tSoIKA97paTgWuGwct/YCVTqejZLdd+c
         79xOE2K896MmtJBIP8vIcNsH2XK/pqnJcJ760pDY=
From:   Jessica Yu <jeyu@kernel.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Matthias Maennich <maennich@google.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH v2] modpost: move the namespace field in Module.symvers last
Date:   Wed, 11 Mar 2020 18:01:20 +0100
Message-Id: <20200311170120.12641-1-jeyu@kernel.org>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to preserve backwards compatability with kmod tools, we have to
move the namespace field in Module.symvers last, as the depmod -e -E
option looks at the first three fields in Module.symvers to check symbol
versions (and it's expected they stay in the original order of crc,
symbol, module).

In addition, update an ancient comment above read_dump() in modpost that
suggested that the export type field in Module.symvers was optional. I
suspect that there were historical reasons behind that comment that are
no longer accurate. We have been unconditionally printing the export
type since 2.6.18 (commit bd5cbcedf44), which is over a decade ago now.

Fix up read_dump() to treat each field as non-optional. I suspect the
original read_dump() code treated the export field as optional in order
to support pre <= 2.6.18 Module.symvers (which did not have the export
type field). Note that although symbol namespaces are optional, the
field will not be omitted from Module.symvers if a symbol does not have
a namespace. In this case, the field will simply be empty and the next
delimiter or end of line will follow.

Cc: stable@vger.kernel.org
Fixes: cb9b55d21fe0 ("modpost: add support for symbol namespaces")
Tested-by: Matthias Maennich <maennich@google.com>
Reviewed-by: Matthias Maennich <maennich@google.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
---
v2:

  - Explain the changes to read_dump() and the comment (and provide
    historical context) in the commit message. (Lucas De Marchi)

 Documentation/kbuild/modules.rst |  4 ++--
 scripts/export_report.pl         |  2 +-
 scripts/mod/modpost.c            | 24 ++++++++++++------------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/kbuild/modules.rst b/Documentation/kbuild/modules.rst
index 69fa48ee93d6..e0b45a257f21 100644
--- a/Documentation/kbuild/modules.rst
+++ b/Documentation/kbuild/modules.rst
@@ -470,9 +470,9 @@ build.
 
 	The syntax of the Module.symvers file is::
 
-	<CRC>       <Symbol>          <Namespace>  <Module>                         <Export Type>
+	<CRC>       <Symbol>         <Module>                         <Export Type>     <Namespace>
 
-	0xe1cc2a05  usb_stor_suspend  USB_STORAGE  drivers/usb/storage/usb-storage  EXPORT_SYMBOL_GPL
+	0xe1cc2a05  usb_stor_suspend drivers/usb/storage/usb-storage  EXPORT_SYMBOL_GPL USB_STORAGE
 
 	The fields are separated by tabs and values may be empty (e.g.
 	if no namespace is defined for an exported symbol).
diff --git a/scripts/export_report.pl b/scripts/export_report.pl
index 548330e8c4e7..feb3d5542a62 100755
--- a/scripts/export_report.pl
+++ b/scripts/export_report.pl
@@ -94,7 +94,7 @@ if (defined $opt{'o'}) {
 #
 while ( <$module_symvers> ) {
 	chomp;
-	my (undef, $symbol, $namespace, $module, $gpl) = split('\t');
+	my (undef, $symbol, $module, $gpl, $namespace) = split('\t');
 	$SYMBOL { $symbol } =  [ $module , "0" , $symbol, $gpl];
 }
 close($module_symvers);
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index a3d8370f9544..e1963ef8c07c 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2421,7 +2421,7 @@ static void write_if_changed(struct buffer *b, const char *fname)
 }
 
 /* parse Module.symvers file. line format:
- * 0x12345678<tab>symbol<tab>module[[<tab>export]<tab>something]
+ * 0x12345678<tab>symbol<tab>module<tab>export<tab>namespace
  **/
 static void read_dump(const char *fname, unsigned int kernel)
 {
@@ -2434,7 +2434,7 @@ static void read_dump(const char *fname, unsigned int kernel)
 		return;
 
 	while ((line = get_next_line(&pos, file, size))) {
-		char *symname, *namespace, *modname, *d, *export, *end;
+		char *symname, *namespace, *modname, *d, *export;
 		unsigned int crc;
 		struct module *mod;
 		struct symbol *s;
@@ -2442,16 +2442,16 @@ static void read_dump(const char *fname, unsigned int kernel)
 		if (!(symname = strchr(line, '\t')))
 			goto fail;
 		*symname++ = '\0';
-		if (!(namespace = strchr(symname, '\t')))
-			goto fail;
-		*namespace++ = '\0';
-		if (!(modname = strchr(namespace, '\t')))
+		if (!(modname = strchr(symname, '\t')))
 			goto fail;
 		*modname++ = '\0';
-		if ((export = strchr(modname, '\t')) != NULL)
-			*export++ = '\0';
-		if (export && ((end = strchr(export, '\t')) != NULL))
-			*end = '\0';
+		if (!(export = strchr(modname, '\t')))
+			goto fail;
+		*export++ = '\0';
+		if (!(namespace = strchr(export, '\t')))
+			goto fail;
+		*namespace++ = '\0';
+
 		crc = strtoul(line, &d, 16);
 		if (*symname == '\0' || *modname == '\0' || *d != '\0')
 			goto fail;
@@ -2502,9 +2502,9 @@ static void write_dump(const char *fname)
 				namespace = symbol->namespace;
 				buf_printf(&buf, "0x%08x\t%s\t%s\t%s\t%s\n",
 					   symbol->crc, symbol->name,
-					   namespace ? namespace : "",
 					   symbol->module->name,
-					   export_str(symbol->export));
+					   export_str(symbol->export),
+					   namespace ? namespace : "");
 			}
 			symbol = symbol->next;
 		}
-- 
2.16.4

