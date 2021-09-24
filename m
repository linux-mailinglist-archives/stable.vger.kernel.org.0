Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10304173E8
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345099AbhIXNAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345740AbhIXM66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63867613AD;
        Fri, 24 Sep 2021 12:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487984;
        bh=BVrxyoIWLerfsADKDOwLAvQ/JSj6zi0IMSjtdI+6jBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJI/FvLvTRfo3Xhn9p4Xo6JZwLQO5oVTpHQnXOVvpIuxw1gyjcnDs9NgMXD8nwwqT
         PXcQAFcW5j9x5DdCt4Ei0uu2Ls5SixDIt2bVYxDsPQKNr5wRGguHePsx2Nr6Sr57tJ
         EuOXPZQBf9DYFdYxgXZ9rMICU7WJAvjUugu2LiQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.14 007/100] um: virtio_uml: fix memory leak on init failures
Date:   Fri, 24 Sep 2021 14:43:16 +0200
Message-Id: <20210924124341.712073214@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
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
@@ -1139,7 +1139,7 @@ static int virtio_uml_probe(struct platf
 		rc = os_connect_socket(pdata->socket_path);
 	} while (rc == -EINTR);
 	if (rc < 0)
-		return rc;
+		goto error_free;
 	vu_dev->sock = rc;
 
 	spin_lock_init(&vu_dev->sock_lock);
@@ -1160,6 +1160,8 @@ static int virtio_uml_probe(struct platf
 
 error_init:
 	os_close_file(vu_dev->sock);
+error_free:
+	kfree(vu_dev);
 	return rc;
 }
 


