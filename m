Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF492E1E06
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgLWPeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbgLWPeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECD4E23383;
        Wed, 23 Dec 2020 15:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737593;
        bh=cgvaEvUbZO/s3ntixqFDPhN+DSKY1SMEqwqPehHNPIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZq32TSBleWrzkpafZgmaZVtruMTihKi4s4Z5tw1oL5iNLOmjYfCRJWtrDsmeO9+F
         QhlLCjJWfvWLNZxiDTmVBgP2HnL44FtV5YGOEEkNVDVa76saIvfKbvR9suRgB+zkg5
         2n/MBlN3PGtXZHeUfhmgSdDcDkX1/L57tipYSanU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolin Chen <nicoleotsuka@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.10 04/40] soc/tegra: fuse: Fix index bug in get_process_id
Date:   Wed, 23 Dec 2020 16:33:05 +0100
Message-Id: <20201223150515.778051755@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolin Chen <nicoleotsuka@gmail.com>

commit b9ce9b0f83b536a4ac7de7567a265d28d13e5bea upstream.

This patch simply fixes a bug of referencing speedos[num] in every
for-loop iteration in get_process_id function.

Fixes: 0dc5a0d83675 ("soc/tegra: fuse: Add Tegra210 support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/tegra/fuse/speedo-tegra210.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/tegra/fuse/speedo-tegra210.c
+++ b/drivers/soc/tegra/fuse/speedo-tegra210.c
@@ -94,7 +94,7 @@ static int get_process_id(int value, con
 	unsigned int i;
 
 	for (i = 0; i < num; i++)
-		if (value < speedos[num])
+		if (value < speedos[i])
 			return i;
 
 	return -EINVAL;


