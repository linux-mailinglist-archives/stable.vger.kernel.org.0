Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB9C2E3766
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgL1MzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:55:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbgL1MzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:55:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 696A0208D5;
        Mon, 28 Dec 2020 12:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160063;
        bh=E/Z9LZvYqn6ru0ZTP8p5p0hAmmDNU8np5PX/xj12fY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Vd4PWF9NQzaclLz3lj96EylGSi0Rv6bPbeMqtsEkZ6N6FvpCx9DbbFQ+lrCGmI4A
         RBhNhGnrd/BbrgRkge8zuthsLa2karpp9gDGeu76Hk52kF3MjxvE8j36jpB1DL8dHy
         jYqIdzS4CHClvgZna3zQuWPvq6MGjsRS7341Ty08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolin Chen <nicoleotsuka@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 4.4 026/132] soc/tegra: fuse: Fix index bug in get_process_id
Date:   Mon, 28 Dec 2020 13:48:30 +0100
Message-Id: <20201228124847.671479907@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
@@ -105,7 +105,7 @@ static int get_process_id(int value, con
 	unsigned int i;
 
 	for (i = 0; i < num; i++)
-		if (value < speedos[num])
+		if (value < speedos[i])
 			return i;
 
 	return -EINVAL;


