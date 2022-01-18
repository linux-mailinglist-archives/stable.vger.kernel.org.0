Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E757B492A6D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346826AbiARQJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346909AbiARQI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:08:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FD2C0613E5;
        Tue, 18 Jan 2022 08:08:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AB638CE1A2C;
        Tue, 18 Jan 2022 16:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713B2C00446;
        Tue, 18 Jan 2022 16:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522125;
        bh=f8m5zd6+t0NtYDf+2diGU7u8RWwohWgr45WnihyzkUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miI56waalbr+jkuIn7j6T+ML2doOK7Zp7yem/fH8ZxFeyOKcgy1g9JL/iiU4meLt5
         7+tNRFNYUYGEf4cOvWkU/JV+Y7Muy3cnH6xwbNIGRfogTyiKA3d6ICBqJTTER2r9M/
         okJ/OMUhq+f7U0uN4YFUPvntEAL3sdkWLi56LJmM=
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
Subject: [PATCH 5.10 05/23] vfs: fs_context: fix up param length parsing in legacy_parse_param
Date:   Tue, 18 Jan 2022 17:05:45 +0100
Message-Id: <20220118160451.425876269@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
References: <20220118160451.233828401@linuxfoundation.org>
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
@@ -530,7 +530,7 @@ static int legacy_parse_param(struct fs_
 			      param->key);
 	}
 
-	if (len > PAGE_SIZE - 2 - size)
+	if (size + len + 2 > PAGE_SIZE)
 		return invalf(fc, "VFS: Legacy: Cumulative options too large");
 	if (strchr(param->key, ',') ||
 	    (param->type == fs_value_is_string &&


