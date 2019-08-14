Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804288DAF6
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbfHNRJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729815AbfHNRJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:09:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB0D3214DA;
        Wed, 14 Aug 2019 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802559;
        bh=OFzmwpL4JVybjBd4phqcIQBzgJKO/UOgRpoyGWd93n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiKhm+VF80edib2mdiTNRx6oRi7ae8iPn5o+wpJSJNLYZO/c6QzD66tHhU4AomPlU
         zUwqjw/E7Tilvjh/To8KJ5PIPhD3WrqTGptxY5SlsBJ1x97pUj5e8fTjUgxeqN/1V8
         T9EonzsxgAGKpjMBaK1xOba9eB14vL//gJqhzSQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 28/91] usb: typec: tcpm: remove tcpm dir if no children
Date:   Wed, 14 Aug 2019 19:00:51 +0200
Message-Id: <20190814165750.887935126@linuxfoundation.org>
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

commit 12ca7297b8855c0af1848503d37196159b24e6b9 upstream.

If config tcpm as module, module unload will not remove tcpm dir,
then the next module load will have problem: the rootdir is NULL
but tcpm dir is still there, so tcpm_debugfs_init() will create
tcpm dir again with failure, fix it by remove the tcpm dir if no
children.

Cc: stable@vger.kernel.org # v4.15+
Fixes: 4b4e02c83167 ("typec: tcpm: Move out of staging")
Signed-off-by: Li Jun <jun.li@nxp.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20190717080646.30421-2-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/tcpm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/typec/tcpm.c
+++ b/drivers/usb/typec/tcpm.c
@@ -595,6 +595,10 @@ static void tcpm_debugfs_exit(struct tcp
 	mutex_unlock(&port->logbuffer_lock);
 
 	debugfs_remove(port->dentry);
+	if (list_empty(&rootdir->d_subdirs)) {
+		debugfs_remove(rootdir);
+		rootdir = NULL;
+	}
 }
 
 #else


