Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7833148115
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390419AbgAXLQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:16:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390429AbgAXLQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:16:53 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83A2A20708;
        Fri, 24 Jan 2020 11:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864613;
        bh=rXkUQd+1JMRl8DPvb2RiWzCJ4fupfzrGRgRAtFXg/Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2YF/RXjH0Bl3KD1nBUdFbZDGe16xudoI//pP3SEOy3QyAyUvE0uoN3XE4/AsfkuG
         DTe0DljpvNJEAVZhiGxy774JohVJe0gWuhVck6W+4wXipo4G3iDCWRIl0HhQmDNJzc
         nVydi6jE4ZWYU4vjg5Edm1d9U/4V64NeHPva3Mxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 302/639] firmware: arm_scmi: fix of_node leak in scmi_mailbox_check
Date:   Fri, 24 Jan 2020 10:27:52 +0100
Message-Id: <20200124093124.784142120@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

[ Upstream commit fa7fe29a645b4da08efe8ff2392898b88f9ded9f ]

of_parse_phandle_with_args() requires the caller to call of_node_put() on
the returned args->np pointer. Otherwise the reference count will remain
incremented.

However, in this case, since we don't actually use the returned pointer,
we can simply pass in NULL.

Fixes: aa4f886f3893f ("firmware: arm_scmi: add basic driver infrastructure for SCMI")
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 09119e3f5c018..effc4c17e0fb9 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -662,9 +662,7 @@ static int scmi_xfer_info_init(struct scmi_info *sinfo)
 
 static int scmi_mailbox_check(struct device_node *np)
 {
-	struct of_phandle_args arg;
-
-	return of_parse_phandle_with_args(np, "mboxes", "#mbox-cells", 0, &arg);
+	return of_parse_phandle_with_args(np, "mboxes", "#mbox-cells", 0, NULL);
 }
 
 static int scmi_mbox_free_channel(int id, void *p, void *data)
-- 
2.20.1



