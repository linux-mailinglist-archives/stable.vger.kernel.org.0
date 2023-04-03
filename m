Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E468E6D4717
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjDCORD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbjDCORB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:17:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90AE2BEC5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92247B81B85
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3CFC433D2;
        Mon,  3 Apr 2023 14:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531418;
        bh=0vnA3WU9n71Hksc/Fk2ECnvm3tBZSD5qLPZsrYMfSA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7pmmxpLBD59b3q6Pj0cDjZPjHZ/105zdNd9kPpzRYPzDEw0JvUa11q050OZF6L+x
         KAVvK1x+qZMEVv66+6+W5bLphZxlRBV64nK7M9THadkN+6I6Tg+uwGuNUkXuDPfHQy
         otu5OREr7Kxo2eEqGxoYrDka8qzM4VLRTwbaRxFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Chen <harperchen1110@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/84] fbdev: tgafb: Fix potential divide by zero
Date:   Mon,  3 Apr 2023 16:08:56 +0200
Message-Id: <20230403140355.311986370@linuxfoundation.org>
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

[ Upstream commit f90bd245de82c095187d8c2cabb8b488a39eaecc ]

fb_set_var would by called when user invokes ioctl with cmd
FBIOPUT_VSCREENINFO. User-provided data would finally reach
tgafb_check_var. In case var->pixclock is assigned to zero,
divide by zero would occur when checking whether reciprocal
of var->pixclock is too high.

Similar crashes have happened in other fbdev drivers. There
is no check and modification on var->pixclock along the call
chain to tgafb_check_var. We believe it could also be triggered
in driver tgafb from user site.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/tgafb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/tgafb.c b/drivers/video/fbdev/tgafb.c
index 65ba9921506e2..9d2912947eef6 100644
--- a/drivers/video/fbdev/tgafb.c
+++ b/drivers/video/fbdev/tgafb.c
@@ -166,6 +166,9 @@ tgafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct tga_par *par = (struct tga_par *)info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (par->tga_type == TGA_TYPE_8PLANE) {
 		if (var->bits_per_pixel != 8)
 			return -EINVAL;
-- 
2.39.2



