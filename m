Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4D0492A26
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346391AbiARQHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346337AbiARQHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:07:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1D7C061574;
        Tue, 18 Jan 2022 08:07:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79355CE1A33;
        Tue, 18 Jan 2022 16:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6729C00446;
        Tue, 18 Jan 2022 16:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522029;
        bh=KzOco6XDkn3nZuYUAC2TU6jALj8wYcBgTQhd1Ssl7dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdwQXSSW+gpiJeIsHDH6DvaqWBQlE2uXw6GYBaM32d4+Fce5LonTknsss+RrLdocq
         lBhFWJ3HKbls53pSXf7j6XUXkTko8olLVS7HhT66AYqfwONb4gojS9JCI7pKgYUifl
         eYPIMg763uoirwHgVEvKqjLMaU6UbVFtnCci8dyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jamie Hill-Daniel <jamie@hill-daniel.co.uk>,
        William Liu <willsroot@protonmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 04/15] vfs: fs_context: fix up param length parsing in legacy_parse_param
Date:   Tue, 18 Jan 2022 17:05:43 +0100
Message-Id: <20220118160450.209355294@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160450.062004175@linuxfoundation.org>
References: <20220118160450.062004175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jamie Hill-Daniel <jamie@hill-daniel.co.uk>

commit 722d94847de29310e8aa03fcbdb41fc92c521756 upstream.

The "PAGE_SIZE - 2 - size" calculation in legacy_parse_param() is an
unsigned type so a large value of "size" results in a high positive
value instead of a negative value as expected.  Fix this by getting rid
of the subtraction.

Signed-off-by: Jamie Hill-Daniel <jamie@hill-daniel.co.uk>
Signed-off-by: William Liu <willsroot@protonmail.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Tested-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs_context.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -585,7 +585,7 @@ static int legacy_parse_param(struct fs_
 			      param->key);
 	}
 
-	if (len > PAGE_SIZE - 2 - size)
+	if (size + len + 2 > PAGE_SIZE)
 		return invalf(fc, "VFS: Legacy: Cumulative options too large");
 	if (strchr(param->key, ',') ||
 	    (param->type == fs_value_is_string &&


