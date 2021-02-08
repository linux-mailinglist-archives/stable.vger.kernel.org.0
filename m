Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00486313638
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhBHPHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231273AbhBHPFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:05:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9989064ECD;
        Mon,  8 Feb 2021 15:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796655;
        bh=1Iqggc9G5mQwV+jkC6xopaFwm8dIdmlYT/CSiKci0vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/rGMYu8Xp9R8uFUDSn+wQAhO/PkQ8lmmAtgFrhNCAnroSxKBPmQWTTF1HzHZrPR8
         glwntQ+paRN/O2PTi4nHihAwXEDMz7B72unJOUBfxmfLHpyFz/m5vEyksuyxcsfKX8
         cbSZqrngnvM+mq2ZV9zteqCITopWdF4HZiK/wSlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 18/43] stable: clamp SUBLEVEL in 4.4 and 4.9
Date:   Mon,  8 Feb 2021 16:00:44 +0100
Message-Id: <20210208145807.048896363@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
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
@@ -1141,7 +1141,7 @@ endef
 
 define filechk_version.h
 	(echo \#define LINUX_VERSION_CODE $(shell                         \
-	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
+	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 


