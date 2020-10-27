Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420AA29BC75
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1809996AbgJ0Qcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802492AbgJ0Ptj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:49:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D709422453;
        Tue, 27 Oct 2020 15:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813775;
        bh=TbvKyiIsY8u3aNEGtQ4lzndNOknupo3iNqO8vf8zft4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxI5MI3MP2ecXqXFCj7BCdD86SGTw/EZj5TGqPyW48035xin1xSu5TjsFAo1T603/
         hhJWzTg3JQLs4lDzqT+F9WIMtdaO5fUCdO5Gd+n9GDN0Y4QOaZCUYaYl+uyIGFv4BF
         kl1wif2harKxwtRN/rIgYeRFjOyuVzyAjBsq1x/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 666/757] media: saa7134: avoid a shift overflow
Date:   Tue, 27 Oct 2020 14:55:16 +0100
Message-Id: <20201027135521.780785688@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 15a36aae1ec1c1f17149b6113b92631791830740 ]

As reported by smatch:
	drivers/media/pci/saa7134//saa7134-tvaudio.c:686 saa_dsp_writel() warn: should 'reg << 2' be a 64 bit type?

On a 64-bits Kernel, the shift might be bigger than 32 bits.

In real, this should never happen, but let's shut up the warning.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7134/saa7134-tvaudio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index 79e1afb710758..5cc4ef21f9d37 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -683,7 +683,8 @@ int saa_dsp_writel(struct saa7134_dev *dev, int reg, u32 value)
 {
 	int err;
 
-	audio_dbg(2, "dsp write reg 0x%x = 0x%06x\n", reg << 2, value);
+	audio_dbg(2, "dsp write reg 0x%x = 0x%06x\n",
+		  (reg << 2) & 0xffffffff, value);
 	err = saa_dsp_wait_bit(dev,SAA7135_DSP_RWSTATE_WRR);
 	if (err < 0)
 		return err;
-- 
2.25.1



