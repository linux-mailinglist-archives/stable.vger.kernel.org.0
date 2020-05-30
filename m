Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327381E8F19
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 09:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgE3HmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 03:42:00 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:52350 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728807AbgE3Hl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 May 2020 03:41:59 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3B5C74094A;
        Sat, 30 May 2020 07:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1590824519; bh=i0WVMhfUe7X8jMr5woG6oawz62l16H5EjhMrkDwjGg8=;
        h=Date:From:Subject:To:Cc:From;
        b=VPbMjlWXvgSjBNwqy7YQhePBOiQSgSydqCzFtqv0n/Q5e8JeP8aE0F5+es/3+Q/ui
         7vgm+dJJMuLbIYqpSJQEnEdjpueKybjEOoUWMborNh2yY/8/FJUEL6kkykF9IO63iq
         gIgejJtRNGEAn3TzVo77Pg4IaNOg/cAVyE3dsNxniXjAWYZVUoIu3/VZCUd6Ll6hla
         MWP/IyabcGicImy3JjovjxVmdCpRuHju1WAktzisSph5SkRH888qfS96ehcVKCOaFQ
         KyhzamOKyQFjk0tzxQjdeX2DSRkCjfz+/HuR/3+belxA1Hi9KFiKWAH/CORiDBuEQc
         w89GN7e+veVHA==
Received: from hminas-z420 (hminas-z420.internal.synopsys.com [10.116.126.211])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 09A37A006F;
        Sat, 30 May 2020 07:41:53 +0000 (UTC)
Received: by hminas-z420 (sSMTP sendmail emulation); Sat, 30 May 2020 11:41:50 +0400
Date:   Sat, 30 May 2020 11:41:50 +0400
Message-Id: <01a67b314fa39b794847fc0c1758969931ca6177.1590822499.git.hminas@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH v2] usb: dwc2: Fix shutdown callback in platform
To:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org,
        "Heiko Stuebner" <heiko.stuebner@collabora.com>,
        Douglas Anderson <dianders@chromium.org>
Cc:     stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Frank Mori Hess <fmh6jj@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To avoid lot of interrupts from dwc2 core, which can be asserted in
specific conditions need to disable interrupts on HW level instead of
disable IRQs on Kernel level, because of IRQ can be shared between
drivers.

Cc: stable@vger.kernel.org
Fixes: a40a00318c7fc ("usb: dwc2: add shutdown callback to platform variant")
Tested-by: Frank Mori Hess <fmh6jj@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Frank Mori Hess <fmh6jj@gmail.com>
Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
---

Changes in V2:
- added synchronize_irq()

 drivers/usb/dwc2/platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index e571c8ae65ec..a6360f5f6cd4 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -342,7 +342,8 @@ static void dwc2_driver_shutdown(struct platform_device *dev)
 {
 	struct dwc2_hsotg *hsotg = platform_get_drvdata(dev);
 
-	disable_irq(hsotg->irq);
+	dwc2_disable_global_interrupts(hsotg);
+	synchronize_irq(hsotg->irq);
 }
 
 /**
-- 
2.11.0

