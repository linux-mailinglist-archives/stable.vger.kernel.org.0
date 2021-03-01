Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EDA328D33
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241025AbhCATHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240857AbhCATBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:01:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCB4365106;
        Mon,  1 Mar 2021 17:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618150;
        bh=Pv9NNrYFiFCPxUMNwvBOzdGcfEdBNLjqcJM0rtlmYlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5Tpf2qbmCk/xfDa3dcSZIDsXf9Kj48OPcTCKMiQoZ4/tIp5xe7P3Sa+AAqUdov4k
         ZJ93C2Laiuvk5kNkKmpucRgvb5LzPD2V4BIByZdbrIqHrpg0Jq/f73TqV/hCNT2MrO
         k5qYIK9x54ih3rhCibMANp+5glELRivTYne7fEnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.4 294/340] watchdog: mei_wdt: request stop on unregister
Date:   Mon,  1 Mar 2021 17:13:58 +0100
Message-Id: <20210301161102.768536559@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 740c0a57b8f1e36301218bf549f3c9cc833a60be upstream.

The MEI bus has a special behavior on suspend it destroys
all the attached devices, this is due to the fact that also
firmware context is not persistent across power flows.

If watchdog on MEI bus is ticking before suspending the firmware
times out and reports that the OS is missing watchdog tick.
Send the stop command to the firmware on watchdog unregistered
to eliminate the false event on suspend.
This does not make the things worse from the user-space perspective
as a user-space should re-open watchdog device after
suspending before this patch.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20210124114938.373885-1-tomas.winkler@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/mei_wdt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/watchdog/mei_wdt.c
+++ b/drivers/watchdog/mei_wdt.c
@@ -382,6 +382,7 @@ static int mei_wdt_register(struct mei_w
 
 	watchdog_set_drvdata(&wdt->wdd, wdt);
 	watchdog_stop_on_reboot(&wdt->wdd);
+	watchdog_stop_on_unregister(&wdt->wdd);
 
 	ret = watchdog_register_device(&wdt->wdd);
 	if (ret)


