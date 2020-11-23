Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA982C0882
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732811AbgKWMw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:52:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387641AbgKWMvl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AF09204EF;
        Mon, 23 Nov 2020 12:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135899;
        bh=R4wn6gK7iOkfdvgrwosRHQCHwNMuK+yF+5QHXGk5ato=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaFdWQXYjNH1necMN7jKs4wW60jyOcs2lDhoTcESxD9cxo/hpO1n3TyAx+7+5s/r9
         uQoknrRAwuTFc4T7ENm69kKixOck9OODHpxxEluptqB+xZVFkmblYmh66NqOhlKN91
         Br3pOp82uoyH8J313jPLCwZx6zZm9wFvb/dGQcjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 236/252] drm/amd/display: Add missing pflip irq for dcn2.0
Date:   Mon, 23 Nov 2020 13:23:06 +0100
Message-Id: <20201123121846.970271542@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 728321e53045d2668bf2b8627a8d61bc2c480d3b upstream.

If we have more than 4 displays we will run
into dummy irq calls or flip timout issues.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.c
@@ -299,8 +299,8 @@ irq_source_info_dcn20[DAL_IRQ_SOURCES_NU
 	pflip_int_entry(1),
 	pflip_int_entry(2),
 	pflip_int_entry(3),
-	[DC_IRQ_SOURCE_PFLIP5] = dummy_irq_entry(),
-	[DC_IRQ_SOURCE_PFLIP6] = dummy_irq_entry(),
+	pflip_int_entry(4),
+	pflip_int_entry(5),
 	[DC_IRQ_SOURCE_PFLIP_UNDERLAY0] = dummy_irq_entry(),
 	gpio_pad_int_entry(0),
 	gpio_pad_int_entry(1),


