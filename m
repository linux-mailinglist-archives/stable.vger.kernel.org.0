Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463653E258B
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244267AbhHFIUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243136AbhHFITp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3CBD61131;
        Fri,  6 Aug 2021 08:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237970;
        bh=/1rvwdDxaYdDSPUX7l2VGsQveUviF0T/6kVQQgn0Wns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0htH57Pbp3XeBA8TcB2WVpURVoj977kY9LANxJHms6bu0k/waQmNvx8/GeysCryPN
         zKOImAIgefD9VRJM0AWqp2opUgwuUbZBdR+bAru/ruxQbeNDICnNduK0f5p+jaTUeF
         T3XKlfBM1IkiZhP62zlfQLg49xsCxeo/9IkZ8zKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.10 23/30] firmware: arm_scmi: Add delayed response status check
Date:   Fri,  6 Aug 2021 10:17:01 +0200
Message-Id: <20210806081113.919744983@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

commit f1748b1ee1fa0fd1a074504045b530b62f949188 upstream.

A successfully received delayed response could anyway report a failure at
the protocol layer in the message status field.

Add a check also for this error condition.

Link: https://lore.kernel.org/r/20210608103056.3388-1-cristian.marussi@arm.com
Fixes: 58ecdf03dbb9 ("firmware: arm_scmi: Add support for asynchronous commands and delayed response")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/driver.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -436,8 +436,12 @@ int scmi_do_xfer_with_response(const str
 	xfer->async_done = &async_response;
 
 	ret = scmi_do_xfer(handle, xfer);
-	if (!ret && !wait_for_completion_timeout(xfer->async_done, timeout))
-		ret = -ETIMEDOUT;
+	if (!ret) {
+		if (!wait_for_completion_timeout(xfer->async_done, timeout))
+			ret = -ETIMEDOUT;
+		else if (xfer->hdr.status)
+			ret = scmi_to_linux_errno(xfer->hdr.status);
+	}
 
 	xfer->async_done = NULL;
 	return ret;


