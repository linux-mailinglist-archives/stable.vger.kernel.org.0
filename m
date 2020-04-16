Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B1C1AC7D6
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394863AbgDPO7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898842AbgDPNy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3797620732;
        Thu, 16 Apr 2020 13:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045268;
        bh=ANSD2u3/K3xPERFTROi+5GI/z9ygn+ET+7Z0B9/Zw8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhlHmoFug+oH/Hi12AcrhPBN0cIjiUNBNhtlFI2Yeng4gG0NVKh141XGTDhfD2F+e
         ePom69FFSB4RkdyWLLO2RgqXbm/Aw5n+qSRRa1SLcgP6qa0NEBx0AP3AbL1qlNjqLq
         dqXqpF9H38Kr6FJeZ6zutGRnoqxPFjEPMgVvJ3r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gyeongtaek Lee <gt82.lee@samsung.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.6 066/254] ASoC: fix regwmask
Date:   Thu, 16 Apr 2020 15:22:35 +0200
Message-Id: <20200416131334.157769601@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 이경택 <gt82.lee@samsung.com>

commit 0ab070917afdc93670c2d0ea02ab6defb6246a7c upstream.

If regwshift is 32 and the selected architecture compiles '<<' operator
for signed int literal into rotating shift, '1<<regwshift' became 1 and
it makes regwmask to 0x0.
The literal is set to unsigned long to get intended regwmask.

Signed-off-by: Gyeongtaek Lee <gt82.lee@samsung.com>
Link: https://lore.kernel.org/r/001001d60665$db7af3e0$9270dba0$@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-ops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -825,7 +825,7 @@ int snd_soc_get_xr_sx(struct snd_kcontro
 	unsigned int regbase = mc->regbase;
 	unsigned int regcount = mc->regcount;
 	unsigned int regwshift = component->val_bytes * BITS_PER_BYTE;
-	unsigned int regwmask = (1<<regwshift)-1;
+	unsigned int regwmask = (1UL<<regwshift)-1;
 	unsigned int invert = mc->invert;
 	unsigned long mask = (1UL<<mc->nbits)-1;
 	long min = mc->min;
@@ -874,7 +874,7 @@ int snd_soc_put_xr_sx(struct snd_kcontro
 	unsigned int regbase = mc->regbase;
 	unsigned int regcount = mc->regcount;
 	unsigned int regwshift = component->val_bytes * BITS_PER_BYTE;
-	unsigned int regwmask = (1<<regwshift)-1;
+	unsigned int regwmask = (1UL<<regwshift)-1;
 	unsigned int invert = mc->invert;
 	unsigned long mask = (1UL<<mc->nbits)-1;
 	long max = mc->max;


