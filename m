Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7C431BD21
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhBOPkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231478AbhBOPhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD08764E9E;
        Mon, 15 Feb 2021 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403194;
        bh=KCAOwNu5ccPs1lCxAQElK+NUIAZY9kh3m8TN7iNIFtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IorEXmu2uICSl4Htz8c3gQPPSoyfmr4uC1L4iFEuYjB8/2qDr9qztBAuvMHGrY/cD
         e1R2jJTABGLzO4F5D5jAsGRFBqOZOxEctpCl/hqt2dmZPDQqJtgraJgogBu0DX7S4L
         TKI8CafQ6AoRzEp0pjySFx27QehRgFOygx/e/Tsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/104] net: ipa: set error code in gsi_channel_setup()
Date:   Mon, 15 Feb 2021 16:27:16 +0100
Message-Id: <20210215152721.510515900@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 1d23a56b0296d29e7047b41fe0a42a001036160d ]

In gsi_channel_setup(), we check to see if the configuration data
contains any information about channels that are not supported by
the hardware.  If one is found, we abort the setup process, but
the error code (ret) is not set in this case.  Fix this bug.

Fixes: 650d1603825d8 ("soc: qcom: ipa: the generic software interface")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20210204010655.15619-1-elder@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4a68da7115d19..2a65efd3e8da9 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1573,6 +1573,7 @@ static int gsi_channel_setup(struct gsi *gsi, bool legacy)
 		if (!channel->gsi)
 			continue;	/* Ignore uninitialized channels */
 
+		ret = -EINVAL;
 		dev_err(gsi->dev, "channel %u not supported by hardware\n",
 			channel_id - 1);
 		channel_id = gsi->channel_count;
-- 
2.27.0



