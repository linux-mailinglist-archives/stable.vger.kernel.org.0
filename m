Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DC347AC3D
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhLTOme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbhLTOlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:41:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857D6C061D60;
        Mon, 20 Dec 2021 06:40:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D81D2CE1095;
        Mon, 20 Dec 2021 14:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9573C36AE7;
        Mon, 20 Dec 2021 14:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011243;
        bh=8GZUxbKs2oVAziEpKLCZHOFTP7mkuVlMcXbg9bnpeYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRjQwVTZ3/NXF5HiniVfYQnbyvd4h9myVAUvjmDmW9POGzZgQLCa73ykoBt/BbD25
         613/Fc2NXW5tlodCp/gqkN2/f/940SKc+CViSumW0NfAvGYwioWgZhW2zGPs4hW0Ya
         ZlkPHQppCl8szWc9r8uZ0c1Rph712jy9jW4yjMnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/56] stable: clamp SUBLEVEL in 4.19
Date:   Mon, 20 Dec 2021 15:33:54 +0100
Message-Id: <20211220143023.499990463@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Levin <sashal@kernel.org>

In a few months, SUBLEVEL will overflow, and some userspace may start
treating 4.19.256 as 4.20. While out of tree modules have different ways
of extracting the version number (and we're generally ok with breaking
them), we do care about breaking userspace and it would appear that this
overflow might do just that.

Our rules around userspace ABI in the stable kernel are pretty simple:
we don't break it. Thus, while userspace may be checking major/minor, it
shouldn't be doing anything with sublevel.

This patch applies a big band-aid to the 4.19 kernel in the form of
clamping the sublevel to 255.

The clamp is done for the purpose of LINUX_VERSION_CODE only, and
extracting the version number from the Makefile or "make kernelversion"
will continue to work as intended.

We might need to do it later in newer trees, but maybe we'll have a
better solution by then, so I'm ignoring that problem for now.

Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1158,7 +1158,7 @@ endef
 
 define filechk_version.h
 	(echo \#define LINUX_VERSION_CODE $(shell                         \
-	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
+	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 


