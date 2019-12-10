Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E561192FF
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfLJVFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:05:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbfLJVEq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1BE42465C;
        Tue, 10 Dec 2019 21:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011885;
        bh=pG19F23Ng3dfKisEuzyv6YuvWsbpkjojpMZZsXuxVgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIqtHUdlII9Y/GsydmjFZ3jHMBNmyE4VauZTwryC/QOVjcPnkKSXK+c2AEx32AsLQ
         nv4E9RaeZ+njYZ5q7EZzckEi8osVgS6Z4k5kLaE1YKQStOWfrB1IRk3G9Gp/QR1H5z
         6NvhjaqDv2+tutv1IpdqOtMCr5WfoueR83lzzQl8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 036/350] media: seco-cec: Add a missing 'release_region()' in an error handling path
Date:   Tue, 10 Dec 2019 15:58:48 -0500
Message-Id: <20191210210402.8367-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a9cc4cbcdfd378b65fd4e398800cfa14e3855042 ]

At the beginning of the probe function, we have a call to
'request_muxed_region(BRA_SMB_BASE_ADDR, 7, "CEC00001")()'

A corresponding 'release_region()' is performed in the remove function but
is lacking in the error handling path.

Add it.

Fixes: b03c2fb97adc ("media: add SECO cec driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/seco-cec/seco-cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/seco-cec/seco-cec.c b/drivers/media/platform/seco-cec/seco-cec.c
index 9cd60fe1867c9..a86b6e8f91969 100644
--- a/drivers/media/platform/seco-cec/seco-cec.c
+++ b/drivers/media/platform/seco-cec/seco-cec.c
@@ -675,6 +675,7 @@ err_notifier:
 err_delete_adapter:
 	cec_delete_adapter(secocec->cec_adap);
 err:
+	release_region(BRA_SMB_BASE_ADDR, 7);
 	dev_err(dev, "%s device probe failed\n", dev_name(dev));
 
 	return ret;
-- 
2.20.1

