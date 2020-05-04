Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4481C4468
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbgEDSHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732069AbgEDSHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02EB520721;
        Mon,  4 May 2020 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615625;
        bh=fLIVL3sjse+37SzZ0JN8pjVguV51V/e7QehVdNR5FHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqAZCIXSpqrlfa2VKwh346yokR0Do1KovWfB+RdlzqdusMqd4IR9AuH9XcASqBOZi
         AlgK3MOKzgb/vZqLey478JZ5+PzC2fmL3YeTEuknQKj6X7JD7i/5/u1J0zyF33eyX/
         MsiJN6TOmGoNcTIVOS7yXwhS+HPgPG1pFPi0c5BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.6 57/73] dmaengine: ti: k3-psil: fix deadlock on error path
Date:   Mon,  4 May 2020 19:58:00 +0200
Message-Id: <20200504165509.601260333@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

commit 172d59ecd61b89f535ad99a7e531c0f111453b9a upstream.

The mutex_unlock() is missed on error path of psil_get_ep_config()
which causes deadlock, so add missed mutex_unlock().

Fixes: 8c6bb62f6b4a ("dmaengine: ti: k3 PSI-L remote endpoint configuration")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200408185501.30776-1-grygorii.strashko@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/ti/k3-psil.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma/ti/k3-psil.c
+++ b/drivers/dma/ti/k3-psil.c
@@ -27,6 +27,7 @@ struct psil_endpoint_config *psil_get_ep
 			soc_ep_map = &j721e_ep_map;
 		} else {
 			pr_err("PSIL: No compatible machine found for map\n");
+			mutex_unlock(&ep_map_mutex);
 			return ERR_PTR(-ENOTSUPP);
 		}
 		pr_debug("%s: Using map for %s\n", __func__, soc_ep_map->name);


