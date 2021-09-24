Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB01F41749D
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345751AbhIXNIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:08:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346418AbhIXNGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:06:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B14E06124F;
        Fri, 24 Sep 2021 12:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488179;
        bh=0oFXmb1PiySXKj8yKb4GMJK0zD2bsQWZzTnGzjHOgC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SanSSmoWUVkotlI97CNv9ZL/AJ1YDRqVh0A7A6QwsF+5Irq4t4Tm4okHEM6v/CSbt
         ny8ogS9PQ3iQMWNlZ2sLr2wcOC0uCg2Wepg1HCkjEX10MWAyE7G9eiyIF2nYvZCr4V
         LHGW/DnVxhhsNzrt0QublxUBMs0TJYOCpnbPwbOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.10 15/63] um: virtio_uml: fix memory leak on init failures
Date:   Fri, 24 Sep 2021 14:44:15 +0200
Message-Id: <20210924124334.771760200@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
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
@@ -1113,7 +1113,7 @@ static int virtio_uml_probe(struct platf
 		rc = os_connect_socket(pdata->socket_path);
 	} while (rc == -EINTR);
 	if (rc < 0)
-		return rc;
+		goto error_free;
 	vu_dev->sock = rc;
 
 	spin_lock_init(&vu_dev->sock_lock);
@@ -1132,6 +1132,8 @@ static int virtio_uml_probe(struct platf
 
 error_init:
 	os_close_file(vu_dev->sock);
+error_free:
+	kfree(vu_dev);
 	return rc;
 }
 


