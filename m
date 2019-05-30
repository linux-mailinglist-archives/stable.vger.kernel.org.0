Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72BDC2F4BA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbfE3ElB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729033AbfE3DM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:28 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCCC923F4C;
        Thu, 30 May 2019 03:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185947;
        bh=D+5N3J0AABMuG8rp/HgB9iUEugWCO/ru35dHsRfNSgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjmUKD18fgWlNs03AyisZetkl+XoTgLm8CYiXMnrnfoVMjVXHU8BDvEigb4N/Dg1B
         58UWP2ovgQ+gKJdwriUFKfqdOlazQhSQgEaghqUQNewDhs+yPmqfKh4+WMNmZc83Po
         ZjZUu1kTwyE+1PkPPqkPj1EDOn8tAk3pc1ZfPer0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 358/405] media: imx: vdic: Restore default case to prepare_vdi_in_buffers()
Date:   Wed, 29 May 2019 20:05:56 -0700
Message-Id: <20190530030558.736222920@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ce3c2433b074eb9d569a0f63a15d6fd5dbc87f02 ]

Restore a default case to prepare_vdi_in_buffers() to fix the following
smatch errors:

drivers/staging/media/imx/imx-media-vdic.c:236 prepare_vdi_in_buffers() error: uninitialized symbol 'prev_phys'.
drivers/staging/media/imx/imx-media-vdic.c:237 prepare_vdi_in_buffers() error: uninitialized symbol 'curr_phys'.
drivers/staging/media/imx/imx-media-vdic.c:238 prepare_vdi_in_buffers() error: uninitialized symbol 'next_phys'.

Fixes: 6e537b58de772 ("media: imx: vdic: rely on VDIC for correct field order")

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-vdic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 8a9af4688fd41..8cdd3daa6c5f0 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -231,6 +231,12 @@ static void __maybe_unused prepare_vdi_in_buffers(struct vdic_priv *priv,
 		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
 		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + is;
 		break;
+	default:
+		/*
+		 * can't get here, priv->fieldtype can only be one of
+		 * the above. This is to quiet smatch errors.
+		 */
+		return;
 	}
 
 	ipu_cpmem_set_buffer(priv->vdi_in_ch_p, 0, prev_phys);
-- 
2.20.1



