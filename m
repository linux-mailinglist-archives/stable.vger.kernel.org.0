Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD70CAA80
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391897AbfJCRHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404489AbfJCQgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:36:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F662070B;
        Thu,  3 Oct 2019 16:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120613;
        bh=VaJEsh5UkLakPlc6ctisliyWBlDu3TrANxzQLBFR4vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=My9ykIW2xcrintFEYHXd76kAVeK9q0/qPCKA/VM1eIok5Jn5nPsPJsQdgaF6vAvTF
         LVAaE65HSvHVnC6o5l0CwCz4+SlLhjDEr3fePKRnDBLCHpYf4zEx4o4IudN9rwYVrF
         syXIh8V0zoKE30O7Devg1zOQQCl5aE8N0W0qD8sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.2 249/313] spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when its not ours
Date:   Thu,  3 Oct 2019 17:53:47 +0200
Message-Id: <20191003154557.580679284@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

commit d41f36a6464a85c06ad920703d878e4491d2c023 upstream.

The DSPI interrupt can be shared between two controllers at least on the
LX2160A. In that case, the driver for one controller might misbehave and
consume the other's interrupt. Fix this by actually checking if any of
the bits in the status register have been asserted.

Fixes: 13aed2392741 ("spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20190822212450.21420-2-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-dspi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -886,9 +886,11 @@ static irqreturn_t dspi_interrupt(int ir
 					trans_mode);
 			}
 		}
+
+		return IRQ_HANDLED;
 	}
 
-	return IRQ_HANDLED;
+	return IRQ_NONE;
 }
 
 static const struct of_device_id fsl_dspi_dt_ids[] = {


