Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D431910E2
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgCXNTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbgCXNTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:19:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F4E2206F6;
        Tue, 24 Mar 2020 13:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055947;
        bh=5erQp7S9Ai6F7JoLyZX4Q1MogFFhHZTrNuPftQOXQk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWZA/w93Eg8bHN1VBvD4ayQLlqqJt1TBaDFbimnqOpspCTlZkka4Otj+bdvqIOUtR
         xgdgHCeP4ECh4f5rd/a3ujlUwFcp5rLziNJ9/vZXyTCsVhK6/2SGgUwzFu9NBoL67L
         FaeB9RDs4wPGN2AHws+EFPcfkQltzbzg0QNJ68O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Maennich <maennich@google.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Jessica Yu <jeyu@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 076/102] modpost: move the namespace field in Module.symvers last
Date:   Tue, 24 Mar 2020 14:11:08 +0100
Message-Id: <20200324130814.241308606@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jessica Yu <jeyu@kernel.org>

commit 5190044c2965514a973184ca68ef5fad57a24670 upstream.

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
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/kbuild/modules.rst |    4 ++--
 scripts/export_report.pl         |    2 +-
 scripts/mod/modpost.c            |   24 ++++++++++++------------
 3 files changed, 15 insertions(+), 15 deletions(-)

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
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2434,7 +2434,7 @@ static void write_if_changed(struct buff
 }
 
 /* parse Module.symvers file. line format:
- * 0x12345678<tab>symbol<tab>module[[<tab>export]<tab>something]
+ * 0x12345678<tab>symbol<tab>module<tab>export<tab>namespace
  **/
 static void read_dump(const char *fname, unsigned int kernel)
 {
@@ -2447,7 +2447,7 @@ static void read_dump(const char *fname,
 		return;
 
 	while ((line = get_next_line(&pos, file, size))) {
-		char *symname, *namespace, *modname, *d, *export, *end;
+		char *symname, *namespace, *modname, *d, *export;
 		unsigned int crc;
 		struct module *mod;
 		struct symbol *s;
@@ -2455,16 +2455,16 @@ static void read_dump(const char *fname,
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
@@ -2516,9 +2516,9 @@ static void write_dump(const char *fname
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


