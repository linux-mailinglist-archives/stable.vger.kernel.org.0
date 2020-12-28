Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284D22E4218
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437085AbgL1ODK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:03:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437080AbgL1ODK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:03:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AA2520731;
        Mon, 28 Dec 2020 14:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164174;
        bh=2pvhYvUzwcybc2jQ10HmamX+/mZrNl18i/D1YMlQHWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfgg3QwAjlCRdYTBki5QDVy/bLqFtrIn1tBzFd/Ec/LbkprWB2MZE5gkr3MPPjw9b
         Em99QBuNZWiHodi9BospNp4OITgBlHTRf05+fcoWoM8eV1zEGoPz2zzQdBl2MXI7iV
         H0iS52SjVJqMK05n+u6aFkuVxGCRVc1ZYGddO93M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/717] firmware: tegra: fix strncpy()/strncat() confusion
Date:   Mon, 28 Dec 2020 13:41:26 +0100
Message-Id: <20201228125025.195144057@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9294996f0be40e9da818ed891c82397ab63c00d0 ]

The way that bpmp_populate_debugfs_inband() uses strncpy()
and strncat() makes no sense since the size argument for
the first is insufficient to contain the trailing '/'
and the second passes the length of the input rather than
the output, which triggers a warning:

In function 'strncat',
    inlined from 'bpmp_populate_debugfs_inband' at ../drivers/firmware/tegra/bpmp-debugfs.c:422:4:
include/linux/string.h:289:30: warning: '__builtin_strncat' specified bound depends on the length of the source argument [-Wstringop-overflow=]
  289 | #define __underlying_strncat __builtin_strncat
      |                              ^
include/linux/string.h:367:10: note: in expansion of macro '__underlying_strncat'
  367 |   return __underlying_strncat(p, q, count);
      |          ^~~~~~~~~~~~~~~~~~~~
drivers/firmware/tegra/bpmp-debugfs.c: In function 'bpmp_populate_debugfs_inband':
include/linux/string.h:288:29: note: length computed here
  288 | #define __underlying_strlen __builtin_strlen
      |                             ^
include/linux/string.h:321:10: note: in expansion of macro '__underlying_strlen'
  321 |   return __underlying_strlen(p);

Simplify this to use an snprintf() instead.

Fixes: 5e37b9c137ee ("firmware: tegra: Add support for in-band debug")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/tegra/bpmp-debugfs.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/firmware/tegra/bpmp-debugfs.c b/drivers/firmware/tegra/bpmp-debugfs.c
index c1bbba9ee93a3..440d99c63638b 100644
--- a/drivers/firmware/tegra/bpmp-debugfs.c
+++ b/drivers/firmware/tegra/bpmp-debugfs.c
@@ -412,16 +412,12 @@ static int bpmp_populate_debugfs_inband(struct tegra_bpmp *bpmp,
 				goto out;
 			}
 
-			len = strlen(ppath) + strlen(name) + 1;
+			len = snprintf(pathbuf, pathlen, "%s%s/", ppath, name);
 			if (len >= pathlen) {
 				err = -EINVAL;
 				goto out;
 			}
 
-			strncpy(pathbuf, ppath, pathlen);
-			strncat(pathbuf, name, strlen(name));
-			strcat(pathbuf, "/");
-
 			err = bpmp_populate_debugfs_inband(bpmp, dentry,
 							   pathbuf);
 			if (err < 0)
-- 
2.27.0



