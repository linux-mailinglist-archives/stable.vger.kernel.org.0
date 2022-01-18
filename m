Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0245492AB4
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347089AbiARQMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:12:37 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41990 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347401AbiARQLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:11:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2E9ECE1A4E;
        Tue, 18 Jan 2022 16:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F20C00446;
        Tue, 18 Jan 2022 16:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522259;
        bh=dnJnBqqXqjmuHagT1/YZePw1qawm1NKxJlMD0JTwrhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBxGwnfgQVme841JypALmS+63AJ2TneZAXyWWPLmp6wyeKk29qAt9jJYXAcxDzxX1
         O4/GeP76chNxm0rvM0s/bEshVclK+Ez3fBmk2aa1dUl5kFJ0ncQ9XTyC1vc6koGQ7u
         yqbutikfOZgbByPQGGZKKBYnDdFCoWOlvtKP5OBk=
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
Subject: [PATCH 5.16 05/28] vfs: fs_context: fix up param length parsing in legacy_parse_param
Date:   Tue, 18 Jan 2022 17:06:00 +0100
Message-Id: <20220118160452.579694934@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
References: <20220118160452.384322748@linuxfoundation.org>
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
@@ -548,7 +548,7 @@ static int legacy_parse_param(struct fs_
 			      param->key);
 	}
 
-	if (len > PAGE_SIZE - 2 - size)
+	if (size + len + 2 > PAGE_SIZE)
 		return invalf(fc, "VFS: Legacy: Cumulative options too large");
 	if (strchr(param->key, ',') ||
 	    (param->type == fs_value_is_string &&


