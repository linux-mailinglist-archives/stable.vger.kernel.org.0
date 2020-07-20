Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EF12268B6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387672AbgGTQKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387656AbgGTQK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:10:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 081D42065E;
        Mon, 20 Jul 2020 16:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261425;
        bh=fvKTvQppfJjOPm9ev9R0LLaRbKSdKwZuxaEYJ+Ekcjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXbZnC8n4w50Cy4shKIIZ+oZ/0Jm5OusJ6anO9Dc/B3iWobqY5rDcuMiZLAZnTCoV
         CvCe4XDV/tCuQIiz/Rh0gz/qHaE5a70e42uzXUuUwmWoi2UDni0Eex7npP1pkkR0Va
         klUVRpnF/Y446u0jqJAVNfKIYMitxVM93t8fhDFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 081/244] soundwire: intel: fix memory leak with devm_kasprintf
Date:   Mon, 20 Jul 2020 17:35:52 +0200
Message-Id: <20200720152829.695257062@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit bf6d6e68d2028a2d82f4c106f50ec75cc1e6ef89 ]

The dais are allocated with devm_kcalloc() but their name isn't
resourced managed and never freed. Fix by also using devm_ for the dai
names as well.

Fixes: c46302ec554c5 ('soundwire: intel: Add audio DAI ops')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@gmail.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20200617163536.17401-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 3c83e76c6bf90..cab425070e641 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -930,8 +930,9 @@ static int intel_create_dai(struct sdw_cdns *cdns,
 
 	 /* TODO: Read supported rates/formats from hardware */
 	for (i = off; i < (off + num); i++) {
-		dais[i].name = kasprintf(GFP_KERNEL, "SDW%d Pin%d",
-					 cdns->instance, i);
+		dais[i].name = devm_kasprintf(cdns->dev, GFP_KERNEL,
+					      "SDW%d Pin%d",
+					      cdns->instance, i);
 		if (!dais[i].name)
 			return -ENOMEM;
 
-- 
2.25.1



