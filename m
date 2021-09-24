Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FD141732F
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344118AbhIXMzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344195AbhIXMxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:53:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DE4661368;
        Fri, 24 Sep 2021 12:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487802;
        bh=pxc+We+YD5GuoLQIZECSW/U46cRzeH1dG8DF32lVsfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0iaTrBtKa3rgYtdAg0azKCKZ99xhuZMlPYRGJo1DvOUmQWu0Dwuf4c6ec2kGyDtlQ
         wLHD9tfv5d8rLvc1kXmaWh7tzrrkt5AXSe9HvLcp7eOIfSHBF2le7x0AIAIbsmErpz
         CBIc6greV3dAKHwqhL5kbm2+V3unM43op6CmTLiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 18/50] um: virtio_uml: fix memory leak on init failures
Date:   Fri, 24 Sep 2021 14:44:07 +0200
Message-Id: <20210924124332.851446386@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 7ad28e0df7ee9dbcb793bb88dd81d4d22bb9a10e upstream.

If initialization fails, e.g. because the connection failed,
we leak the 'vu_dev'. Fix that. Reported by smatch.

Fixes: 5d38f324993f ("um: drivers: Add virtio vhost-user driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/virtio_uml.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -994,7 +994,7 @@ static int virtio_uml_probe(struct platf
 		rc = os_connect_socket(pdata->socket_path);
 	} while (rc == -EINTR);
 	if (rc < 0)
-		return rc;
+		goto error_free;
 	vu_dev->sock = rc;
 
 	rc = vhost_user_init(vu_dev);
@@ -1010,6 +1010,8 @@ static int virtio_uml_probe(struct platf
 
 error_init:
 	os_close_file(vu_dev->sock);
+error_free:
+	kfree(vu_dev);
 	return rc;
 }
 


