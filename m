Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECD92F7A24
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbhAOMpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:45:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388101AbhAOMh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0AB223356;
        Fri, 15 Jan 2021 12:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714264;
        bh=GbJMei26G0fohQC1A0d9GCVGqqy5+C27u+N9uVZyxMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhHkqNRV8NKttmG6fZyqetSyciPVSkmNSeckRNlsTqbpHZOtRcZ4pyekXSRIkbBiH
         CnEKVbS1cgch3sDePGTq2sgPx0yK0oSNpD0nDpGYPddS/vuAXtz2SkI21XUKv3V9yW
         vB48Bqcx3b/HxkgOb9QU1Fh9FTrkswFRf8kFkxDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 057/103] can: m_can: m_can_class_unregister(): remove erroneous m_can_clk_stop()
Date:   Fri, 15 Jan 2021 13:27:50 +0100
Message-Id: <20210115122008.809554974@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit c4aec381ab98c9189d47b935832541d520f1f67f upstream.

In m_can_class_register() the clock is started, but stopped on exit. When
calling m_can_class_unregister(), the clock is stopped a second time.

This patch removes the erroneous m_can_clk_stop() in  m_can_class_unregister().

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Sriram Dash <sriram.dash@samsung.com>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215103238.524029-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/m_can/m_can.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1914,8 +1914,6 @@ EXPORT_SYMBOL_GPL(m_can_class_resume);
 void m_can_class_unregister(struct m_can_classdev *m_can_dev)
 {
 	unregister_candev(m_can_dev->net);
-
-	m_can_clk_stop(m_can_dev);
 }
 EXPORT_SYMBOL_GPL(m_can_class_unregister);
 


