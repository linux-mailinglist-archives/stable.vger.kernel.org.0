Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3EF353F6C
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbhDEJMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238884AbhDEJLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:11:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CA9B613AB;
        Mon,  5 Apr 2021 09:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613867;
        bh=haH7sI2EGSZtheaOsNp651WNMOn+77njKdVy78W2CKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zccvegwl7unmAasSmQf0cU2f7UMYFk7tyHvSFUk20QFU+edO796466VPB7kEivAAJ
         mZZ65tmSC69h8zEt5cgdzBX0LcAjdNXAXC+V97woqjfwC38FfLcKjKlN0IHiVC4yBp
         JHNhzXwrHwmgkEl8FhSGKwjtQwsRyG51IkJXJiac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: [PATCH 5.10 122/126] driver core: clear deferred probe reason on probe retry
Date:   Mon,  5 Apr 2021 10:54:44 +0200
Message-Id: <20210405085035.070556504@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

commit f0acf637d60ffcef3ccb6e279f743e587b3c7359 upstream.

When retrying a deferred probe, any old defer reason string should be
discarded. Otherwise, if the probe is deferred again at a different spot,
but without setting a message, the now incorrect probe reason will remain.

This was observed with the i.MX I2C driver, which ultimately failed
to probe due to lack of the GPIO driver. The probe defer for GPIO
doesn't record a message, but a previous probe defer to clock_get did.
This had the effect that /sys/kernel/debug/devices_deferred listed
a misleading probe deferral reason.

Cc: stable <stable@vger.kernel.org>
Fixes: d090b70ede02 ("driver core: add deferring probe reason to devices_deferred property")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20210319110459.19966-1-a.fatoum@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -97,6 +97,9 @@ static void deferred_probe_work_func(str
 
 		get_device(dev);
 
+		kfree(dev->p->deferred_probe_reason);
+		dev->p->deferred_probe_reason = NULL;
+
 		/*
 		 * Drop the mutex while probing each device; the probe path may
 		 * manipulate the deferred list


