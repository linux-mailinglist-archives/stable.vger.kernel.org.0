Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C216E1A50C5
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgDKMVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbgDKMVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:21:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E2D20644;
        Sat, 11 Apr 2020 12:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607661;
        bh=ohEtPDNa21lPmwh4R3ce1rem5fhciGz8dc0mnmgu/Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nv6oYnrn7ufvRVJvPO7Wjaxma7CoXUCnzLrKkt4PSL0tgCkG6HiS+cFPFj9Sns47c
         X9rZFChxRKpakXSfeRRtzEJNCPnZnlaWO1jNBviDnbaV5+EmiLY2Qc0ors0Maewpy5
         1HStdm77g259YRAsG4/NT9KawlVHH+YzvdzvaON4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonghwan Choi <charlie.jh@kakaocorp.com>,
        Dan Murphy <dmurphy@ti.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.6 24/38] ASoC: tas2562: Fixed incorrect amp_level setting.
Date:   Sat, 11 Apr 2020 14:10:01 +0200
Message-Id: <20200411115502.387383878@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115459.324496182@linuxfoundation.org>
References: <20200411115459.324496182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonghwan Choi <charlie.jh@kakaocorp.com>

commit eedf8a126629bf9db8ad3a2a5dc9dc1798fb2302 upstream.

According to the tas2562 datasheet,the bits[5:1] represents the amp_level value.
So to set the amp_level value correctly,the shift value should be set to 1.

Signed-off-by: Jonghwan Choi <charlie.jh@kakaocorp.com>
Acked-by: Dan Murphy <dmurphy@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200319140043.GA6688@jhbirdchoi-MS-7B79
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/tas2562.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/tas2562.c
+++ b/sound/soc/codecs/tas2562.c
@@ -409,7 +409,7 @@ static const struct snd_kcontrol_new vse
 			1, 1);
 
 static const struct snd_kcontrol_new tas2562_snd_controls[] = {
-	SOC_SINGLE_TLV("Amp Gain Volume", TAS2562_PB_CFG1, 0, 0x1c, 0,
+	SOC_SINGLE_TLV("Amp Gain Volume", TAS2562_PB_CFG1, 1, 0x1c, 0,
 		       tas2562_dac_tlv),
 };
 


