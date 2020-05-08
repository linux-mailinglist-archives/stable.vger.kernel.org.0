Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D641CAFCF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgEHNUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728673AbgEHMkv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AA9D20731;
        Fri,  8 May 2020 12:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941650;
        bh=6n0ahUsSSAX0rdpWSQ18St5EorlUTtHxTcar9RoEJE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQvmR0cSEDX0r5xdki5zrqSUOrWb8JSQwyF+roR00akC+bAvkVnW/4FAvZpJSJAk6
         z1XhpuQrBn3kdxjuD7zwNudM5dUkcw4jqgIJfQX9ZWkZYJioAAbJBcQHnm6D6nHk5B
         K5lf+67F/3V2uecmuFNs5CUy+kvSxtlptR/nQqQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4.4 118/312] Drivers: hv: utils: use memdup_user in hvt_op_write
Date:   Fri,  8 May 2020 14:31:49 +0200
Message-Id: <20200508123132.763575979@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

commit b00359642c2427da89dc8f77daa2c9e8a84e6d76 upstream.

Use memdup_user to handle OOM.

Fixes: 14b50f80c32d ('Drivers: hv: util: introduce hv_utils_transport abstraction')

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/hv_utils_transport.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/hv/hv_utils_transport.c
+++ b/drivers/hv/hv_utils_transport.c
@@ -80,11 +80,10 @@ static ssize_t hvt_op_write(struct file
 
 	hvt = container_of(file->f_op, struct hvutil_transport, fops);
 
-	inmsg = kzalloc(count, GFP_KERNEL);
-	if (copy_from_user(inmsg, buf, count)) {
-		kfree(inmsg);
-		return -EFAULT;
-	}
+	inmsg = memdup_user(buf, count);
+	if (IS_ERR(inmsg))
+		return PTR_ERR(inmsg);
+
 	if (hvt->on_msg(inmsg, count))
 		return -EFAULT;
 	kfree(inmsg);


