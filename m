Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4E621F9E7
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbgGNSrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729723AbgGNSri (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:47:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FB4D22B2C;
        Tue, 14 Jul 2020 18:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752457;
        bh=FrW5svSSOMr6F6SuCMiGrVaNwk3DE5YpZW0VtD3OlHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaAvRnONvkZemAES5cErBf7B17PMwaZv8yv6/REzpstNAH20gDcQ/L7uBPrxcIXd+
         fnj2GaBIOPKSreUWqbh4fUDIU94JDFrXgVgmSrFhu5uruc1/eFLd/e3iTlrJWxfEzu
         T0zHmpntsdlRu1CN+09lzW/kQJvKAbjlLK8KMGZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        Jessica Yu <jeyu@kernel.org>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.19 49/58] module: Do not expose section addresses to non-CAP_SYSLOG
Date:   Tue, 14 Jul 2020 20:44:22 +0200
Message-Id: <20200714184058.596597029@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit b25a7c5af9051850d4f3d93ca500056ab6ec724b upstream.

The printing of section addresses in /sys/module/*/sections/* was not
using the correct credentials to evaluate visibility.

Before:

 # cat /sys/module/*/sections/.*text
 0xffffffffc0458000
 ...
 # capsh --drop=CAP_SYSLOG -- -c "cat /sys/module/*/sections/.*text"
 0xffffffffc0458000
 ...

After:

 # cat /sys/module/*/sections/*.text
 0xffffffffc0458000
 ...
 # capsh --drop=CAP_SYSLOG -- -c "cat /sys/module/*/sections/.*text"
 0x0000000000000000
 ...

Additionally replaces the existing (safe) /proc/modules check with
file->f_cred for consistency.

Reported-by: Dominik Czarnota <dominik.czarnota@trailofbits.com>
Fixes: be71eda5383f ("module: Fix display of wrong module .text address")
Cc: stable@vger.kernel.org
Tested-by: Jessica Yu <jeyu@kernel.org>
Acked-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1471,8 +1471,8 @@ static ssize_t module_sect_read(struct f
 	if (pos != 0)
 		return -EINVAL;
 
-	return sprintf(buf, "0x%px\n", kptr_restrict < 2 ?
-		       (void *)sattr->address : NULL);
+	return sprintf(buf, "0x%px\n",
+		       kallsyms_show_value(file->f_cred) ? (void *)sattr->address : NULL);
 }
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
@@ -4260,7 +4260,7 @@ static int modules_open(struct inode *in
 
 	if (!err) {
 		struct seq_file *m = file->private_data;
-		m->private = kallsyms_show_value(current_cred()) ? NULL : (void *)8ul;
+		m->private = kallsyms_show_value(file->f_cred) ? NULL : (void *)8ul;
 	}
 
 	return err;


