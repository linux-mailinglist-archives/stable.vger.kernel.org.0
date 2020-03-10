Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF18C17F503
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 11:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgCJK1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 06:27:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54887 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726100AbgCJK1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 06:27:03 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 44CBF21C57;
        Tue, 10 Mar 2020 06:27:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 10 Mar 2020 06:27:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/H/ve9
        NbiLklxpT3e4PVjpbfD/u+6b/NwnSd+1Lq8qE=; b=qm1/CjEpk316Nwm85HHrh3
        E4fvIyDYRNrWQNcvqpXqGkvBFRXi/WAOLkKM2EAi52n5irXlACEecnddVFWo1S+K
        1nRuoyVXP2j2d5vgK0jTztDeOChmfwwdYibRrQgZKqK7T88KMGU2lisEan9nC5Mq
        LeCbHecjaDM3HIkoNs+1xWcGgNxL26+VJcF2CWDFnG+0CyNPmyjG+GMjDbSXzhlS
        1o8aTUySy8upt3Av+KV00F8RwlROS5/sXppzD/izrWdSCtwfP5anjZ3KP+ILZK4q
        x4Xm3fCRSE6Z+XA6QgNadaI7/NYVULa07LEJktAwKiEJ6JjuMP0yRv0ZeqpEYYlg
        ==
X-ME-Sender: <xms:dmtnXsyG9wZykv9qRLsa7V_Gh7HznxJtYccpZvQyMFtQbmFsL2RSTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dmtnXhkG2CJ3QHJscRLjmIf82-MC0sUpzjjj77EGdprphiz19epqGg>
    <xmx:dmtnXgxWqwaom1QZXG8ncBdmO8QLzn9zdzr5d5yn0wK_P3F5zS34zA>
    <xmx:dmtnXgKrD8pnvdz3ZT_h1oNvah-2zAMBENuG42es_rg-vwMyGPfC3A>
    <xmx:dmtnXn8N8nA_Qn1G4UfEG6YvhRJunDQAyPpXSa8_Mko36RJ1zky3xw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BBE3C328005E;
        Tue, 10 Mar 2020 06:27:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] regulator: stm32-vrefbuf: fix a possible overshoot when" failed to apply to 4.14-stable tree
To:     fabrice.gasnier@st.com, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 11:27:00 +0100
Message-ID: <1583836020105116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 02fbabd5f4ed182d2c616e49309f5a3efd9ec671 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@st.com>
Date: Wed, 4 Mar 2020 09:55:32 +0100
Subject: [PATCH] regulator: stm32-vrefbuf: fix a possible overshoot when
 re-enabling

There maybe an overshoot, when disabling, then re-enabling vrefbuf
too quickly. VREFBUF is used by ADC/DAC on some boards. When re-enabling
too quickly, an overshoot on the reference voltage make the conversions
inaccurate for a short period of time.
- Don't put the VREFBUF in HiZ when disabling, to force an active
discharge.
- Enforce a 1ms OFF/ON delay

Fixes: 0cdbf481e927 ("regulator: Add support for stm32-vrefbuf")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Message-Id: <1583312132-20932-1-git-send-email-fabrice.gasnier@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/regulator/stm32-vrefbuf.c b/drivers/regulator/stm32-vrefbuf.c
index bdfaf7edb75a..992bc18101ef 100644
--- a/drivers/regulator/stm32-vrefbuf.c
+++ b/drivers/regulator/stm32-vrefbuf.c
@@ -88,7 +88,7 @@ static int stm32_vrefbuf_disable(struct regulator_dev *rdev)
 	}
 
 	val = readl_relaxed(priv->base + STM32_VREFBUF_CSR);
-	val = (val & ~STM32_ENVR) | STM32_HIZ;
+	val &= ~STM32_ENVR;
 	writel_relaxed(val, priv->base + STM32_VREFBUF_CSR);
 
 	pm_runtime_mark_last_busy(priv->dev);
@@ -175,6 +175,7 @@ static const struct regulator_desc stm32_vrefbuf_regu = {
 	.volt_table = stm32_vrefbuf_voltages,
 	.n_voltages = ARRAY_SIZE(stm32_vrefbuf_voltages),
 	.ops = &stm32_vrefbuf_volt_ops,
+	.off_on_delay = 1000,
 	.type = REGULATOR_VOLTAGE,
 	.owner = THIS_MODULE,
 };

