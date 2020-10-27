Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C98D29B3B9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780330AbgJ0Oyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762782AbgJ0Oo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:44:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D554521527;
        Tue, 27 Oct 2020 14:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809867;
        bh=BdAJ4MjlzbJj6K5lFc8PuQNl8sUHh1kH3DZ5xn5jEHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0biU/cGmQkJh3XWjekfKM/AWcvC2IB80yhrth8CRgWqbJ48ZmPIaTpM6sSLGauF5V
         X2HUeUtW2Cx+WYX9zuIlT5b6PXHbC3Rd9GLJ4gMppKSIUq6olgRLpsYaFL8Q1/qsQq
         cd4a5oo9depcYyQMns1PJh1hWsBszz4Iu/1uRkSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 316/408] lightnvm: fix out-of-bounds write to array devices->info[]
Date:   Tue, 27 Oct 2020 14:54:14 +0100
Message-Id: <20201027135509.690511278@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit a48faebe65b0db55a73b9220c3d919eee849bb79 ]

There is an off-by-one array check that can lead to a out-of-bounds
write to devices->info[i].  Fix this by checking by using >= rather
than > for the size check. Also replace hard-coded array size limit
with ARRAY_SIZE on the array.

Addresses-Coverity: ("Out-of-bounds write")
Fixes: cd9e9808d18f ("lightnvm: Support for Open-Channel SSDs")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
index 7543e395a2c64..a2ebc75af8c79 100644
--- a/drivers/lightnvm/core.c
+++ b/drivers/lightnvm/core.c
@@ -1316,8 +1316,9 @@ static long nvm_ioctl_get_devices(struct file *file, void __user *arg)
 		strlcpy(info->bmname, "gennvm", sizeof(info->bmname));
 		i++;
 
-		if (i > 31) {
-			pr_err("max 31 devices can be reported.\n");
+		if (i >= ARRAY_SIZE(devices->info)) {
+			pr_err("max %zd devices can be reported.\n",
+			       ARRAY_SIZE(devices->info));
 			break;
 		}
 	}
-- 
2.25.1



