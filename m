Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D088D985
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbfHNRJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729542AbfHNRJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:09:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 623CD2084D;
        Wed, 14 Aug 2019 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802556;
        bh=TYFy08fBWSEElyvDyVwKiGkMT0KMuV3TrvCCJW8HtAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWIk+DLYZ9wcnFHTO3MyO9ENLPKio9y9/GEz6Y5knCVdOgmTcD48+9FTvpae7P4AT
         tjlQ3nnC0hq0Q72vy07WRNijrh/hWtBEwNzKVl+fWbq44aUx8V2Zex6fl7PFBlYYp0
         LoDszyMaFhul1i8EzVHsvX5C6mUjzEFVctqmoQZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 27/91] usb: typec: tcpm: free log buf memory when remove debug file
Date:   Wed, 14 Aug 2019 19:00:50 +0200
Message-Id: <20190814165750.843608582@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

commit fd5da3e2cc61b4a7c877172fdc9348c82cf6ccfc upstream.

The logbuffer memory should be freed when remove debug file.

Cc: stable@vger.kernel.org # v4.15+
Fixes: 4b4e02c83167 ("typec: tcpm: Move out of staging")
Signed-off-by: Li Jun <jun.li@nxp.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20190717080646.30421-1-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/tcpm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/typec/tcpm.c
+++ b/drivers/usb/typec/tcpm.c
@@ -585,6 +585,15 @@ static void tcpm_debugfs_init(struct tcp
 
 static void tcpm_debugfs_exit(struct tcpm_port *port)
 {
+	int i;
+
+	mutex_lock(&port->logbuffer_lock);
+	for (i = 0; i < LOG_BUFFER_ENTRIES; i++) {
+		kfree(port->logbuffer[i]);
+		port->logbuffer[i] = NULL;
+	}
+	mutex_unlock(&port->logbuffer_lock);
+
 	debugfs_remove(port->dentry);
 }
 


