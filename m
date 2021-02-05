Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADABA310F17
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 18:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhBEQHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 11:07:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233149AbhBEQF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 11:05:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F083564DDE;
        Fri,  5 Feb 2021 17:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612547226;
        bh=OHxAOM9wghGYWvZu0KjUzETkYLVVRtkJHqtK0BI2k9Y=;
        h=From:To:Cc:Subject:Date:From;
        b=D1v1DeOTrTEFR3hRML97oZxW0EOohvHLvvRmWdQFCFBMSlxkKCHWJwyFOQaFttvw1
         /I5Ax9ZUnnW1nJQMNwVTx9sANz2tHatsSc5Of8Jfx759soYGdqIAtEW+64WTUHNpjf
         Z8F20WjEi0uURd2JA8mCla9/WVFYP1NKljKRPgXo/ReyYapmnv2DMBKY7tt2Hm+VId
         peqi0kACEWxRYOIJT2m2u2XsevijoA4Ec4qLXiMsZGIfFY/N8lkYNYnw/X/I8HCYg8
         H1S2qdbZXS2wJHFZAz/y6xRbL6FliKgtOxOYfrFuCeIwzAcEW3okbc0aCCPyttbYhX
         7UBBkNPQJjFPg==
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, mathieu.desnoyers@efficios.com,
        willy@infradead.org, corbet@lwn.net, johannes.berg@intel.com,
        jariruusu@protonmail.com, jirislaby@kernel.org,
        David.Laight@aculab.com, linux-kernel.bfrz@manchmal.in-ulm.de,
        pavel@ucw.cz, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9, 4.4] stable: clamp SUBLEVEL in 4.4 and 4.9
Date:   Fri,  5 Feb 2021 12:47:02 -0500
Message-Id: <20210205174702.1904681-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
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
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 69af44d3dcd14..93f7ce06fc8c9 100644
--- a/Makefile
+++ b/Makefile
@@ -1141,7 +1141,7 @@ endef
 
 define filechk_version.h
 	(echo \#define LINUX_VERSION_CODE $(shell                         \
-	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
+	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 
-- 
2.27.0

