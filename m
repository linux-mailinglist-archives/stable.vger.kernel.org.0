Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113E129C703
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827710AbgJ0S05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1746942AbgJ0OAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:00:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C8062068D;
        Tue, 27 Oct 2020 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807219;
        bh=fqJxabfMkz6RU154unbmDzgV5qtAy8Ka4yXuq2UqcNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POGnz1tzj+GlCQG2FreSyvrTy+4VqjN5xHJNU5T3w583PkRplQFUQeJalVqcxr1OO
         dEzleq+MFDMQWTEjI4nrGsjq57AB/+SIYYDgk+QB/WFhpllPFTa4Rm0/dZGU0jjt0U
         RA8f5sUkuqWOOTfiSq9c7jWPvPmET5POcQgyaiEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 086/112] media: saa7134: avoid a shift overflow
Date:   Tue, 27 Oct 2020 14:49:56 +0100
Message-Id: <20201027134904.611920108@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
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
index 21a579309575d..02407983ce236 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -696,7 +696,8 @@ int saa_dsp_writel(struct saa7134_dev *dev, int reg, u32 value)
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



