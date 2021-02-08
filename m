Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBEF3136E7
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhBHPRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233271AbhBHPMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:12:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82F4A64F03;
        Mon,  8 Feb 2021 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796958;
        bh=n8e4KDMTUgBJGCkluNV1ps2kzCVAbIdfze3YYt15lOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7uFjAo56t48lCIanK1pA8+jg/66HvumgAfJ7CjTk9Wfmr5f1THPSmI9y0T+FCLc5
         Va3PP2MHforiUbyg/3VYwMSOHyqtpkcgyys70fT0UyBKIeV+FQ89qKyJfcEQm6DJLb
         PAnlbozo4EVndR5ptc0H/nwhOWsjm9yGFr2fuVvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/65] um: virtio: free vu_dev only with the contained struct device
Date:   Mon,  8 Feb 2021 16:00:42 +0100
Message-Id: <20210208145810.635083551@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f4172b084342fd3f9e38c10650ffe19eac30d8ce ]

Since struct device is refcounted, we shouldn't free the vu_dev
immediately when it's removed from the platform device, but only
when the references actually all go away. Move the freeing to
the release to accomplish that.

Fixes: 5d38f324993f ("um: drivers: Add virtio vhost-user driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 179b41ad63baf..18618af3835f9 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -959,6 +959,7 @@ static void virtio_uml_release_dev(struct device *d)
 	}
 
 	os_close_file(vu_dev->sock);
+	kfree(vu_dev);
 }
 
 /* Platform device */
@@ -977,7 +978,7 @@ static int virtio_uml_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -EINVAL;
 
-	vu_dev = devm_kzalloc(&pdev->dev, sizeof(*vu_dev), GFP_KERNEL);
+	vu_dev = kzalloc(sizeof(*vu_dev), GFP_KERNEL);
 	if (!vu_dev)
 		return -ENOMEM;
 
-- 
2.27.0



