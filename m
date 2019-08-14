Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300CA8D8ED
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfHNRDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbfHNRDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:03:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27988216F4;
        Wed, 14 Aug 2019 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802222;
        bh=iOsVDNQPfrZ0hYynFDv7w/6/dURvtzUegbmqvaMMglM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmHQHlzknR9Vwyr92LZZT+My48kShbwz5K93OjoT004coDHO/wndXqW2vqSEXlDcm
         QVfmYClL+BHVjHpvIVYHYHoNO1o/OV2plfKFPx9VSgZjhcUl4V2F4fdaeT2H58lhYR
         eIINDTSnModiMFdKLdATIO0guY+Gf6sHR4HghxV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.2 042/144] usb: typec: tcpm: remove tcpm dir if no children
Date:   Wed, 14 Aug 2019 18:59:58 +0200
Message-Id: <20190814165801.591873667@linuxfoundation.org>
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
 drivers/usb/typec/tcpm/tcpm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -596,6 +596,10 @@ static void tcpm_debugfs_exit(struct tcp
 	mutex_unlock(&port->logbuffer_lock);
 
 	debugfs_remove(port->dentry);
+	if (list_empty(&rootdir->d_subdirs)) {
+		debugfs_remove(rootdir);
+		rootdir = NULL;
+	}
 }
 
 #else


