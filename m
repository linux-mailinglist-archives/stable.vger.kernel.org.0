Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750FB540B5A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351062AbiFGS2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352720AbiFGSVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:21:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F462CE16;
        Tue,  7 Jun 2022 10:54:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AC6ECCE2428;
        Tue,  7 Jun 2022 17:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909A4C34115;
        Tue,  7 Jun 2022 17:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624435;
        bh=QcTT9tWSEZAh16mynkwIDPHeS0sPX5L9CulWKauULAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIxwjnRsNRvzmA2toRYrovEuVlnN4fHoDiY90bw6eg/Ht58kd0W7MjbEuxFcRt7Wa
         7k/eqqSHa38GBu+pFDX63shXqD4GNKoPJW8Onek11Exs0IUBK34Wf+aZwJWVMcCQEX
         ONZxNBfOSEgeoB3BmZZvXXHWql9na2XxKtG9UVKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Rodin <mrodin@de.adit-jv.com>,
        LUU HOAI <hoai.luu.ub@renesas.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 326/667] media: vsp1: Fix offset calculation for plane cropping
Date:   Tue,  7 Jun 2022 18:59:51 +0200
Message-Id: <20220607164944.547278101@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Rodin <mrodin@de.adit-jv.com>

[ Upstream commit 5f25abec8f21b7527c1223a354d23c270befddb3 ]

The vertical subsampling factor is currently not considered in the
offset calculation for plane cropping done in rpf_configure_partition.
This causes a distortion (shift of the color plane) when formats with
the vsub factor larger than 1 are used (e.g. NV12, see
vsp1_video_formats in vsp1_pipe.c). This commit considers vsub factor
for all planes except plane 0 (luminance).

Drop generalization of the offset calculation to reduce the binary size.

Fixes: e5ad37b64de9 ("[media] v4l: vsp1: Add cropping support")
Signed-off-by: Michael Rodin <mrodin@de.adit-jv.com>
Signed-off-by: LUU HOAI <hoai.luu.ub@renesas.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vsp1/vsp1_rpf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 85587c1b6a37..75083cb234fe 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -291,11 +291,11 @@ static void rpf_configure_partition(struct vsp1_entity *entity,
 		     + crop.left * fmtinfo->bpp[0] / 8;
 
 	if (format->num_planes > 1) {
+		unsigned int bpl = format->plane_fmt[1].bytesperline;
 		unsigned int offset;
 
-		offset = crop.top * format->plane_fmt[1].bytesperline
-		       + crop.left / fmtinfo->hsub
-		       * fmtinfo->bpp[1] / 8;
+		offset = crop.top / fmtinfo->vsub * bpl
+		       + crop.left / fmtinfo->hsub * fmtinfo->bpp[1] / 8;
 		mem.addr[1] += offset;
 		mem.addr[2] += offset;
 	}
-- 
2.35.1



