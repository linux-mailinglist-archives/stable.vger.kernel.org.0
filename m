Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B6D2EB4E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbfE3DLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728611AbfE3DLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:36 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3198244C4;
        Thu, 30 May 2019 03:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185895;
        bh=uaRMoL5wlZ6kDLSuDyHVPV2xn/4AO4FX8g0HIPN9Oco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gotRDag4lMpDOT9OIKt6QtpWG6hqX/CA0PWVqQO64listEz1b/TkJyzWePU+9FnLt
         MJURzEiq3KMV1fDzGLrY51o2BFZEl71DkUJCBj+6oufDXEUTLSY6HM8HyKkFjN/hSI
         eODHCM869PRhCLfDei22m/wEYwBQFuW3rM9w9qj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Yannick=20Fertr=C3=A9?= <yannick.fertre@st.com>,
        Philippe Cornu <philippe.cornu@st.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 260/405] drm/panel: otm8009a: Add delay at the end of initialization
Date:   Wed, 29 May 2019 20:04:18 -0700
Message-Id: <20190530030554.110483946@linuxfoundation.org>
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

[ Upstream commit 0084c3c71126fc878c6dab8a6ab8ecc484c2be02 ]

At the end of initialization, a delay is required by the panel. Without
this delay, the panel could received a frame early & generate a crash of
panel (black screen).

Signed-off-by: Yannick Fertré <yannick.fertre@st.com>
Reviewed-by: Philippe Cornu <philippe.cornu@st.com>
Tested-by: Philippe Cornu <philippe.cornu@st.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1553155445-13407-1-git-send-email-yannick.fertre@st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-orisetech-otm8009a.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c b/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
index 87fa316e1d7b0..58ccf648b70fb 100644
--- a/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
+++ b/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
@@ -248,6 +248,9 @@ static int otm8009a_init_sequence(struct otm8009a *ctx)
 	/* Send Command GRAM memory write (no parameters) */
 	dcs_write_seq(ctx, MIPI_DCS_WRITE_MEMORY_START);
 
+	/* Wait a short while to let the panel be ready before the 1st frame */
+	mdelay(10);
+
 	return 0;
 }
 
-- 
2.20.1



