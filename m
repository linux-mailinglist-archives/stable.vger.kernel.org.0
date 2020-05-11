Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7771CD312
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 09:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgEKHmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 03:42:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:52652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgEKHmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 03:42:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 15307AC90;
        Mon, 11 May 2020 07:42:37 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] xen/pvcalls-back: test for errors when calling backend_connect()
Date:   Mon, 11 May 2020 09:42:31 +0200
Message-Id: <20200511074231.19794-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

backend_connect() can fail, so switch the device to connected only if
no error occurred.

Fixes: 0a9c75c2c7258f2 ("xen/pvcalls: xenbus state handling")
Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/pvcalls-back.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
index cf4ce3e9358d..41a18ece029a 100644
--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -1088,7 +1088,8 @@ static void set_backend_state(struct xenbus_device *dev,
 		case XenbusStateInitialised:
 			switch (state) {
 			case XenbusStateConnected:
-				backend_connect(dev);
+				if (backend_connect(dev))
+					return;
 				xenbus_switch_state(dev, XenbusStateConnected);
 				break;
 			case XenbusStateClosing:
-- 
2.26.1

