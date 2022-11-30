Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89D263DFE2
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbiK3Svi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiK3SvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:51:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE7398945
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:51:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08D6961D73
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A05C433D6;
        Wed, 30 Nov 2022 18:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834275;
        bh=IGfc3huId5qOMyetTW/u9r7KFkfVoZ2BdocA7qanh1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5zGjxAmH/FxxIhqVd2ovHZIcyNWFLWGN5kf3zk66BNO3oAlJJxfmPujBHMukiAZ9
         S3b1TimrJN+34HWoESf7tE7yNL4AB3B2FYPwQN3ATVM8Hsld1kIGFCU2jXHqCGe3vS
         trxZM8nexqqA4JEITsbvD0nU/w/uiJj3/xR5rcx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 193/289] usb: dwc3: gadget: Return -ESHUTDOWN on ep disable
Date:   Wed, 30 Nov 2022 19:22:58 +0100
Message-Id: <20221130180548.498957859@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit ffb9da4a04c69567bad717707b6fdfbc4c216ef4 ]

The usb_request API clearly noted that removed requests due to disabled
endpoint should have -ESHUTDOWN status returned. Don't change this
behavior.

Fixes: b44c0e7fef51 ("usb: dwc3: gadget: conditionally remove requests")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3421859485cb32d77e2068549679a6c07a7797bc.1667875427.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f90f5afd5083 ("usb: dwc3: gadget: Clear ep descriptor last")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index ffff6f41d2ac..448c8e6bc99d 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1022,7 +1022,7 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 		dep->endpoint.desc = NULL;
 	}
 
-	dwc3_remove_requests(dwc, dep, -ECONNRESET);
+	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 
 	dep->stream_capable = false;
 	dep->type = 0;
-- 
2.35.1



