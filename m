Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2289217FA41
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgCJND7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730676AbgCJND6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:03:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAF442468C;
        Tue, 10 Mar 2020 13:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845438;
        bh=gFrqrhLXjpT3HEcrR0Q1T7zy75R4tXeetSmrWR2ertU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVYieRd1xTLkAdTM4mvEdFlXv6o56A6Y8MJGr89UgXRfm25b/61A0rqqqx9Hwu65L
         0oO4sIS7yQ09sD1H8Nx18MIzXLPBERXr9XrdeNp3hmxiGntbtWG7sadgpwVzHTp4W4
         VpQshCb/K71wz59MSVrXohVDNuaNj2ZSnpFsmPhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.5 182/189] bus: ti-sysc: Fix 1-wire reset quirk
Date:   Tue, 10 Mar 2020 13:40:19 +0100
Message-Id: <20200310123657.946101947@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit aec551c7a00fb7eae049c0c4cc3208ca53e26355 upstream.

Because of the i2c quirk we have the reset quirks named in a confusing
way. Let's fix the 1-wire quirk accordinlyg. Then let's switch to using
better naming later on.

Fixes: 4e23be473e30 ("bus: ti-sysc: Add support for module specific reset quirks")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/ti-sysc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1406,7 +1406,7 @@ static void sysc_init_revision_quirks(st
 }
 
 /* 1-wire needs module's internal clocks enabled for reset */
-static void sysc_clk_enable_quirk_hdq1w(struct sysc *ddata)
+static void sysc_pre_reset_quirk_hdq1w(struct sysc *ddata)
 {
 	int offset = 0x0c;	/* HDQ_CTRL_STATUS */
 	u16 val;
@@ -1494,7 +1494,7 @@ static void sysc_init_module_quirks(stru
 		return;
 
 	if (ddata->cfg.quirks & SYSC_MODULE_QUIRK_HDQ1W) {
-		ddata->clk_enable_quirk = sysc_clk_enable_quirk_hdq1w;
+		ddata->clk_disable_quirk = sysc_pre_reset_quirk_hdq1w;
 
 		return;
 	}


