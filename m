Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DD06D4886
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbjDCO30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbjDCO3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:29:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108013500E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:29:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0C8C61DDB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6575C433EF;
        Mon,  3 Apr 2023 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532159;
        bh=L0ppsVkM3L1IhzDIY/wbSoHkSWthJizIcAiKa9RNvfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abTJ23rvtMrGr0cPXOAvfNwiJTa/Mk1Jg9/28KALi246Nym6KkZYgD1toaeMO0Fzm
         XITe566pih3XtsH1hYIhWDkM/emAEKCGulKVVaKwnmXTJi06mqjCFntuDjUTsOtvlZ
         ggexuj60gFQMOQFpilDG3t7b9hctheHiX0u9Eo3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Chen <harperchen1110@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/173] fbdev: nvidia: Fix potential divide by zero
Date:   Mon,  3 Apr 2023 16:08:54 +0200
Message-Id: <20230403140418.315234213@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Chen <harperchen1110@gmail.com>

[ Upstream commit 92e2a00f2987483e1f9253625828622edd442e61 ]

variable var->pixclock can be set by user. In case it
equals to zero, divide by zero would occur in nvidiafb_set_par.

Similar crashes have happened in other fbdev drivers. There
is no check and modification on var->pixclock along the call
chain to nvidia_check_var and nvidiafb_set_par. We believe it
could also be triggered in driver nvidia from user site.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/nvidia/nvidia.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index a372a183c1f01..f9c388a8c10e3 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -763,6 +763,8 @@ static int nvidiafb_check_var(struct fb_var_screeninfo *var,
 	int pitch, err = 0;
 
 	NVTRACE_ENTER();
+	if (!var->pixclock)
+		return -EINVAL;
 
 	var->transp.offset = 0;
 	var->transp.length = 0;
-- 
2.39.2



