Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C350F1483EA
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbgAXLih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:38:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731011AbgAXLif (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:38:35 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D89B20708;
        Fri, 24 Jan 2020 11:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865914;
        bh=VdxanDx3tZ2T45WF9142dP2iIPEh6lF+y6oS2Qe0B/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MP7ZVRyAYf9ww+J4fY0Udis1rk+tkzg3hqznWtWpKp9sqsH1eOeXHwtoZwB6t35ss
         JQj8F+Ror42J1psADXkaXJwHN8dAMPIscjP5GG7n7DqA9ZHxw0PILbMvsLLjvI+rxQ
         W5NHcqkZkOtpig+xqflCvP+4rHYbKusToq14USyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 154/343] media: davinci-isif: avoid uninitialized variable use
Date:   Fri, 24 Jan 2020 10:29:32 +0100
Message-Id: <20200124092940.236537682@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0e633f97162c1c74c68e2eb20bbd9259dce87cd9 ]

clang warns about a possible variable use that gcc never
complained about:

drivers/media/platform/davinci/isif.c:982:32: error: variable 'frame_size' is uninitialized when used here
      [-Werror,-Wuninitialized]
                dm365_vpss_set_pg_frame_size(frame_size);
                                             ^~~~~~~~~~
drivers/media/platform/davinci/isif.c:887:2: note: variable 'frame_size' is declared here
        struct vpss_pg_frame_size frame_size;
        ^
1 error generated.

There is no initialization for this variable at all, and there
has never been one in the mainline kernel, so we really should
not put that stack data into an mmio register.

On the other hand, I suspect that gcc checks the condition
more closely and notices that the global
isif_cfg.bayer.config_params.test_pat_gen flag is initialized
to zero and never written to from any code path, so anything
depending on it can be eliminated.

To shut up the clang warning, just remove the dead code manually,
it has probably never been used because any attempt to do so
would have resulted in undefined behavior.

Fixes: 63e3ab142fa3 ("V4L/DVB: V4L - vpfe capture - source for ISIF driver on DM365")

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/isif.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index 90d0f13283ae9..12065ad1ac457 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -886,9 +886,7 @@ static int isif_set_hw_if_params(struct vpfe_hw_if_param *params)
 static int isif_config_ycbcr(void)
 {
 	struct isif_ycbcr_config *params = &isif_cfg.ycbcr;
-	struct vpss_pg_frame_size frame_size;
 	u32 modeset = 0, ccdcfg = 0;
-	struct vpss_sync_pol sync;
 
 	dev_dbg(isif_cfg.dev, "\nStarting isif_config_ycbcr...");
 
@@ -976,13 +974,6 @@ static int isif_config_ycbcr(void)
 		/* two fields are interleaved in memory */
 		regw(0x00000249, SDOFST);
 
-	/* Setup test pattern if enabled */
-	if (isif_cfg.bayer.config_params.test_pat_gen) {
-		sync.ccdpg_hdpol = params->hd_pol;
-		sync.ccdpg_vdpol = params->vd_pol;
-		dm365_vpss_set_sync_pol(sync);
-		dm365_vpss_set_pg_frame_size(frame_size);
-	}
 	return 0;
 }
 
-- 
2.20.1



