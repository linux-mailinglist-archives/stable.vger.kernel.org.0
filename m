Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B07D7F55A5
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387615AbfKHTDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:03:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732439AbfKHTDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:03:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAE9F2087E;
        Fri,  8 Nov 2019 19:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239825;
        bh=qHrXqXTGoipl8/RNConQPJh/ZF8X6C0g1hIwEtiH0vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvipFJvwnEL/+soM8x1t7HSRQSPmU0Op0eLbNAA3vQLJIrSokJ2HKpjg7REM1XMR6
         Lo7/r2J56BwdkxEA5JLCsu1052/B8plkhKWPKzCMZt0V0a3PmRik3tfH7kuAVgbV2G
         XASRWPd5RmdpW3ngO4psfnHlpgvqoT9XZBjnV2+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maxtram95@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 72/79] wireless: Skip directory when generating certificates
Date:   Fri,  8 Nov 2019 19:50:52 +0100
Message-Id: <20191108174824.968628501@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maxtram95@gmail.com>

[ Upstream commit 32b5a2c9950b9284000059d752f7afa164deb15e ]

Commit 715a12334764 ("wireless: don't write C files on failures") drops
the `test -f $$f` check. The list of targets contains the
CONFIG_CFG80211_EXTRA_REGDB_KEYDIR directory itself, and this check used
to filter it out. After the check was removed, the extra keydir option
no longer works, failing with the following message:

od: 'standard input': read error: Is a directory

This commit restores the check to make extra keydir work again.

Fixes: 715a12334764 ("wireless: don't write C files on failures")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -38,6 +38,7 @@ $(obj)/extra-certs.c: $(CONFIG_CFG80211_
 	@(set -e; \
 	  allf=""; \
 	  for f in $^ ; do \
+	      test -f $$f || continue;\
 	      # similar to hexdump -v -e '1/1 "0x%.2x," "\n"' \
 	      thisf=$$(od -An -v -tx1 < $$f | \
 	                   sed -e 's/ /\n/g' | \


