Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7826D4719
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjDCORH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbjDCORG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:17:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003DE27831
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A28B6B81B8A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3D3C433EF;
        Mon,  3 Apr 2023 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531423;
        bh=K0x3SRRa4HXHn+EKwSF6/erKOQgcKi+VGbc7NR6slpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUKD5+MglZYb5z5GRZ+8usaAbybx4ej/EJ219aZtNQtylbVsmrv7wxD18YOVHa71/
         /nY9psvLTX4OxmHckUjd9KPhmzs1ZLkDKstSfEJKy0wa+m+p1B/6Wt/fdRJS8DhY/f
         78LJebui6sOvpnV0KYEXP4MOqF/ywr8e0pG2LTvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Chen <harperchen1110@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 57/84] fbdev: nvidia: Fix potential divide by zero
Date:   Mon,  3 Apr 2023 16:08:58 +0200
Message-Id: <20230403140355.388761058@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index fbeeed5afe350..aa502b3ba25ae 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -766,6 +766,8 @@ static int nvidiafb_check_var(struct fb_var_screeninfo *var,
 	int pitch, err = 0;
 
 	NVTRACE_ENTER();
+	if (!var->pixclock)
+		return -EINVAL;
 
 	var->transp.offset = 0;
 	var->transp.length = 0;
-- 
2.39.2



