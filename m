Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A577E5EAE95
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiIZRuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiIZRt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:49:56 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A248D9F0EE
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 10:22:37 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id s18so4529706qtx.6
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 10:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=wSnaf9X31rqUR/i4TLmY1YgzBh+QW0Cs+/Xi8zBeRvc=;
        b=FgR6M/f4PaEmuXMWXgOWUvGOcJZHp51CVTeSexuWG4e4pyP1WV83CWYwkRmQWHemkp
         aYdCBfRCVczmYg7pgfTjbJsXxRZYm4l1jRqlMtmerAcgeqSEJtuPCcTLv/CxHln+EfAg
         WqE8ESkSKjiMx5M2SsPKMXQKlw9QZBgQVPv2rsP7n30dJITmA6Mzzvv6xnisiM9l8pdM
         Sz7mPROjQ+mr/vwM6JVf5vZbUY/03ntghzxs4n0nVHqj4VGcJeoqnyQhg4teYF7BhkjL
         5CpqnDXSe3ewvHylTeiz0FwwFn5E1OGzSQIFGbnOxWHBCfHJLAROCeJQZXh5Lh+msAwX
         8AUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=wSnaf9X31rqUR/i4TLmY1YgzBh+QW0Cs+/Xi8zBeRvc=;
        b=KykvQ3fnBMv0T1Eahz97dgzHOjZrtfCaWEa0ryPS0onR4EWv4iyVcr2hM5db3lNjpc
         XHjQNulfFiQ/zvXkkQrciUUr1iBC84zbXZNG+8GgtqUQPRX4ThMo6gFvMHswL20irA+G
         9oFgxt2GPHsjMQS+JRZ5hnhz/p0oV9pT1OoAsmIZuvxxIVAVJQB3obMnmQDTeBmmanAl
         mM9XEDu8kKawA8fuMhqunQHzsSMQJxcDCOPDYBK/vzMeiQUxvihCoIvnxjp5JIfSl7CJ
         kPJD6yp0ruXnJDOGFQ0kFDECJmKyfQhGk1d8y5xNyyjfPE+KcH3ZxCbB77Z8/eLlN/LR
         huLQ==
X-Gm-Message-State: ACrzQf16CABDxZzxNzKaih94usFKg3PBEWw2fKb5nW3OzN3Sx60pGVvC
        bdl5pSVNUQ6DqBmMY2+p3uvoBNv5BkxotQ==
X-Google-Smtp-Source: AMsMyM4nqkj9V8bf6qrxadn4C81Ee4xA3MrkAWdxVChfhjkd9X+IW7VFI+moY9mJnaMdnjtnY0M34g==
X-Received: by 2002:a05:622a:11c8:b0:35c:e912:a8ea with SMTP id n8-20020a05622a11c800b0035ce912a8eamr19109223qtk.17.1664212956590;
        Mon, 26 Sep 2022 10:22:36 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id h22-20020a05622a171600b0035ba366cc90sm12177368qtk.15.2022.09.26.10.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 10:22:36 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     stable@vger.kernel.org
Cc:     William Breathitt Gray <william.gray@linaro.org>,
        stable <stable@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] counter: 104-quad-8: Fix skipped IRQ lines during events configuration
Date:   Mon, 26 Sep 2022 12:02:27 -0400
Message-Id: <20220926160227.6142-1-william.gray@linaro.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2bc54aaa65d2126ae629919175708a28ce7ef06e upstream.

IRQ trigger configuration is skipped if it has already been set before;
however, the IRQ line still needs to be OR'd to irq_enabled because
irq_enabled is reset for every events_configure call. This patch moves
the irq_enabled OR operation update to before the irq_trigger check so
that IRQ line enablement is not skipped.

Fixes: c95cc0d95702 ("counter: 104-quad-8: Fix persistent enabled events bug")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220815122301.2750-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/179eed11eaf225dbd908993b510df0c8f67b1230.1663844776.git.william.gray@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
This is a backport for the 5.19-stable tree; just a simple context
adjustment to get it to apply cleanly.

Link: https://lore.kernel.org/r/16640913585139@kroah.com/
---
 drivers/counter/104-quad-8.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index a17e51d65aca..4e3f88f0e0a4 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -426,6 +426,9 @@ static int quad8_events_configure(struct counter_device *counter)
 			return -EINVAL;
 		}
 
+		/* Enable IRQ line */
+		irq_enabled |= BIT(event_node->channel);
+
 		/* Skip configuration if it is the same as previously set */
 		if (priv->irq_trigger[event_node->channel] == next_irq_trigger)
 			continue;
@@ -439,9 +442,6 @@ static int quad8_events_configure(struct counter_device *counter)
 			  priv->irq_trigger[event_node->channel] << 3;
 		base_offset = priv->base + 2 * event_node->channel + 1;
 		outb(QUAD8_CTR_IOR | ior_cfg, base_offset);
-
-		/* Enable IRQ line */
-		irq_enabled |= BIT(event_node->channel);
 	}
 
 	outb(irq_enabled, priv->base + QUAD8_REG_INDEX_INTERRUPT);
-- 
2.37.3

