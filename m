Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D8661590B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiKBDEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiKBDDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:03:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087D5233A4
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98F2061729
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E63BC433D7;
        Wed,  2 Nov 2022 03:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358192;
        bh=9DV1yBJbFWDjW+tyYTl5Kfb31hddeO5JFrbBrE8sxLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtGvqizuFwE402TYpLb2qersarEn333FcEBzLaZC1r0nd3Ivk8pW8g7jpEP8k0j96
         doDXzojm2X5Bt//t7dsvwuJc/s2a/DbzaNEXMXBmbt+d/40cPxeGzW0o2tOafFmlH7
         i2hFw6j7fbU6dyqYwPm4VVUiCqr+f7q/UCw/wjuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/132] media: atomisp: prevent integer overflow in sh_css_set_black_frame()
Date:   Wed,  2 Nov 2022 03:32:43 +0100
Message-Id: <20221102022101.111391316@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 3ad290194bb06979367622e47357462836c1d3b4 ]

The "height" and "width" values come from the user so the "height * width"
multiplication can overflow.

Link: https://lore.kernel.org/r/YxBBCRnm3mmvaiuR@kili

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/sh_css_params.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/sh_css_params.c b/drivers/staging/media/atomisp/pci/sh_css_params.c
index ccc007879564..deecffd438ae 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -962,8 +962,8 @@ sh_css_set_black_frame(struct ia_css_stream *stream,
 		params->fpn_config.data = NULL;
 	}
 	if (!params->fpn_config.data) {
-		params->fpn_config.data = kvmalloc(height * width *
-						   sizeof(short), GFP_KERNEL);
+		params->fpn_config.data = kvmalloc(array3_size(height, width, sizeof(short)),
+						   GFP_KERNEL);
 		if (!params->fpn_config.data) {
 			IA_CSS_ERROR("out of memory");
 			IA_CSS_LEAVE_ERR_PRIVATE(-ENOMEM);
-- 
2.35.1



