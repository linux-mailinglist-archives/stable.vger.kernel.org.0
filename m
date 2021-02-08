Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E93931360F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhBHPF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232876AbhBHPD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:03:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58E7F64EB7;
        Mon,  8 Feb 2021 15:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796606;
        bh=5n1+5pAYKydUCiYwImBD9lr7EVtVsDVK+XpcP8nmQNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmvpBhnPW7osq9RSpeWmaGTnObtvBCAOAjz4Mm2tRei4w6gvevo8KXmX6EsZj75p/
         ws1YATvSLdGKYEull7SYQBMRTyS8UdKgj9hvLwNb6o/FXBVVc12bVf2gZ8YeCCMdgD
         Da21R9Lz1uu6YO4mZIKRDzAlg632Jbcd/VLlNqZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/38] stable: clamp SUBLEVEL in 4.4 and 4.9
Date:   Mon,  8 Feb 2021 16:00:37 +0100
Message-Id: <20210208145805.898658055@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
References: <20210208145805.279815326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Right now SUBLEVEL is overflowing, and some userspace may start treating
4.9.256 as 4.10. While out of tree modules have different ways of
  extracting the version number (and we're generally ok with breaking
them), we do care about breaking userspace and it would appear that this
overflow might do just that.

Our rules around userspace ABI in the stable kernel are pretty simple:
we don't break it. Thus, while userspace may be checking major/minor, it
shouldn't be doing anything with sublevel.

This patch applies a big band-aid to the 4.9 and 4.4 kernels in the form
of clamping their sublevel to 255.

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
@@ -1068,7 +1068,7 @@ endef
 
 define filechk_version.h
 	(echo \#define LINUX_VERSION_CODE $(shell                         \
-	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
+	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 


