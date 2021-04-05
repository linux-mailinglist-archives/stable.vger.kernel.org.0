Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34586353CE3
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhDEI5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233095AbhDEI5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19B426139C;
        Mon,  5 Apr 2021 08:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613027;
        bh=6pcHRfI5R4NBY0ubQePnRZ6ZlMG4Z9EX1kB/F6XP+j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wVDJ93FLW8qPE8LF/B2x5vt31MTiqVDzHlooDjgJ+LO/dICkd5Ngmc9dBYc1K5pga
         XUhgxtNbb20Oi4oPZj2hQ6U0+rv7Vc5U/nJaM0ni4sZNfMPp6OJu9HeaB2ciVbXNax
         n+3KzIzTzRH+O2GxMdr8ZzxtttFHpQgTdDzwIcJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 25/35] extcon: Fix error handling in extcon_dev_register
Date:   Mon,  5 Apr 2021 10:54:00 +0200
Message-Id: <20210405085019.673324065@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit d3bdd1c3140724967ca4136755538fa7c05c2b4e ]

When devm_kcalloc() fails, we should execute device_unregister()
to unregister edev->dev from system.

Fixes: 046050f6e623e ("extcon: Update the prototype of extcon_register_notifier() with enum extcon")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/extcon.c b/drivers/extcon/extcon.c
index d0e367959c91..20e24d4b917a 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -1200,6 +1200,7 @@ int extcon_dev_register(struct extcon_dev *edev)
 			sizeof(*edev->nh) * edev->max_supported, GFP_KERNEL);
 	if (!edev->nh) {
 		ret = -ENOMEM;
+		device_unregister(&edev->dev);
 		goto err_dev;
 	}
 
-- 
2.30.2



