Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964218D8E2
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbfHNRDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbfHNRDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:03:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 201B02084D;
        Wed, 14 Aug 2019 17:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802199;
        bh=5XY1jhNN1PSrUuRz6k03esqUoUOnMp2iMjXslguADsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDSgu6FvHKuL+8FO3nnLJoQZ6CFBN//1N+ABcxHUKc+xtpGQ4n8/Itx74ClyVDmuR
         EKn1ORcVsiK+gXLhOL9AigazwgiTnGEzjaB3oLLbVQjdaaWLWj2zJ9Zcc5bAwXRd5H
         xIEWLVo8icjnZR4+gJOWY2Wc1BXYh05rP9+eoBp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adham Abozaeid <adham.abozaeid@microchip.com>
Subject: [PATCH 5.2 008/144] staging: wilc1000: flush the workqueue before deinit the host
Date:   Wed, 14 Aug 2019 18:59:24 +0200
Message-Id: <20190814165759.834376274@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@microchip.com>

commit fb2b055b7e6e44efda737c7c92f46c0868bb04e5 upstream.

Before deinitializing the host interface, the workqueue should be flushed
to handle any pending deferred work

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190722213837.21952-1-adham.abozaeid@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1789,6 +1789,7 @@ void wilc_deinit_host_int(struct net_dev
 
 	priv->p2p_listen_state = false;
 
+	flush_workqueue(vif->wilc->hif_workqueue);
 	mutex_destroy(&priv->scan_req_lock);
 	ret = wilc_deinit(vif);
 


