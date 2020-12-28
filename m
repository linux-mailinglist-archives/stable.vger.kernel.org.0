Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17A42E663A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388525AbgL1NXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:23:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732941AbgL1NXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47FFC207CF;
        Mon, 28 Dec 2020 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161775;
        bh=E/Z9LZvYqn6ru0ZTP8p5p0hAmmDNU8np5PX/xj12fY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHG9nTYcCND2uUwcW9c1NQoYsoSjV4GNxFI3BiHiK7v+2UGkAO44rF/f5VEzfE3RE
         NsyUc2akEua0+denqVHnCgqp98yi4Z2jM5nImp+qs73VwH4Z0XpfMCn1U1TI23adsZ
         3N+spaPtkxRiBHjKS1o4wWNtTvZWgEtkcv6NcFUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolin Chen <nicoleotsuka@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 4.19 077/346] soc/tegra: fuse: Fix index bug in get_process_id
Date:   Mon, 28 Dec 2020 13:46:36 +0100
Message-Id: <20201228124923.519471255@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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


