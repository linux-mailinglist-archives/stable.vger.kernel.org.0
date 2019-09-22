Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71725BA985
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395544AbfIVTQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389533AbfIVS4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:56:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DAE921907;
        Sun, 22 Sep 2019 18:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178570;
        bh=lAXoCvK9UQCg0kKCfkhoaIjzPBFySSpdewTqTsr5tNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fo9renCPJtrB0dV/9djV+G/Jyh/6oN8XLwZaH6inEc5UnUxsarAmzC4ZV2xaLvMsp
         ZVMPWPfdn9n8Pa3H1A7AJ1ZB78CKiKQ0q0MUBAEKEoWCFytEGZNjbaBaB0znfJS2/w
         VHf8mHuvqnJmLQqCy2Ezie8EABa+rxogRKGBnlqc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 082/128] media: ov9650: add a sanity check
Date:   Sun, 22 Sep 2019 14:53:32 -0400
Message-Id: <20190922185418.2158-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

[ Upstream commit 093347abc7a4e0490e3c962ecbde2dc272a8f708 ]

As pointed by cppcheck:

	[drivers/media/i2c/ov9650.c:706]: (error) Shifting by a negative value is undefined behaviour
	[drivers/media/i2c/ov9650.c:707]: (error) Shifting by a negative value is undefined behaviour
	[drivers/media/i2c/ov9650.c:721]: (error) Shifting by a negative value is undefined behaviour

Prevent mangling with gains with invalid values.

As pointed by Sylvester, this should never happen in practice,
as min value of V4L2_CID_GAIN control is 16 (gain is always >= 16
and m is always >= 0), but it is too hard for a static analyzer
to get this, as the logic with validates control min/max is
elsewhere inside V4L2 core.

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov9650.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 5bea31cd41aa1..33a21d585dc9c 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -716,6 +716,11 @@ static int ov965x_set_gain(struct ov965x *ov965x, int auto_gain)
 		for (m = 6; m >= 0; m--)
 			if (gain >= (1 << m) * 16)
 				break;
+
+		/* Sanity check: don't adjust the gain with a negative value */
+		if (m < 0)
+			return -EINVAL;
+
 		rgain = (gain - ((1 << m) * 16)) / (1 << m);
 		rgain |= (((1 << m) - 1) << 4);
 
-- 
2.20.1

