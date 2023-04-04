Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42ED56D597B
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 09:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbjDDHZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 03:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbjDDHZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 03:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC9C10D3;
        Tue,  4 Apr 2023 00:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6919461D8E;
        Tue,  4 Apr 2023 07:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE31DC433D2;
        Tue,  4 Apr 2023 07:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680593145;
        bh=KrpEnfXrN/ILXoJPn/Dt8b528GB6V4SV+63rAt0irQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sepDq3Z8l/XByMhI2fKijIQx1dPOlFmgxe69kiRmQ+cuFs8RLh/ZW45N5dRSH2xWv
         G262nYdA3W/c6xMbUsneyyUZqiRXVmoKg9h2pNkKAZrWwGgmLboVADDzd6mtSYOJbI
         CshFGH8ZsUCtZld0WZRtL3xhnXEDzVBiqr2+XotFwt+OfDF9MOnmnK0DCXzK0cWSFc
         MjP5huxKD8/KIVaAEttY3xk6qeXy5LzX+ORD7Lw48avk/PQa1gfGdh4szD+lxSpRzA
         h/9PpwApdGOxBqsY3tpza8raZNe1/2bkrntT3Q8S4//cqORin10UNtHV/YUShFK5LP
         c8LtBvnahjTzw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pjb3U-0004xS-OF; Tue, 04 Apr 2023 09:26:12 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Li Jun <jun.li@nxp.com>
Subject: [PATCH 02/11] USB: dwc3: fix runtime pm imbalance on unbind
Date:   Tue,  4 Apr 2023 09:25:15 +0200
Message-Id: <20230404072524.19014-3-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404072524.19014-1-johan+linaro@kernel.org>
References: <20230404072524.19014-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to balance the runtime PM usage count on driver unbind by
adding back the pm_runtime_allow() call that had been erroneously
removed.

Fixes: 266d0493900a ("usb: dwc3: core: don't trigger runtime pm when remove driver")
Cc: stable@vger.kernel.org	# 5.9
Cc: Li Jun <jun.li@nxp.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/usb/dwc3/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 5058bd8d56ca..9f8c988c25cb 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1979,6 +1979,7 @@ static int dwc3_remove(struct platform_device *pdev)
 	dwc3_core_exit(dwc);
 	dwc3_ulpi_exit(dwc);
 
+	pm_runtime_allow(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
-- 
2.39.2

