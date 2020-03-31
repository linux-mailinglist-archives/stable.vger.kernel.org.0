Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D80C619914E
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731643AbgCaJS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731991AbgCaJSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:18:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF56020787;
        Tue, 31 Mar 2020 09:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646333;
        bh=i54h0PpoMrZjEXGvANY6FaJbACna+TsoRHILdEn6CI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDPYGwlyYlh3k5laWTnOhtkJMILBuWm3rUzsXzzUPlapM9KNzQzjF6g06K2GMUZdP
         EHmq94ehPiRT0yLYpRyKzRfOMJInM5GCOrYFlc+abS/AR3vOkBM43TbfEJQ3ZBEfwF
         Z6OwthbMMuWv/2vgMDeyr24KBkGHQ2Apyr2P23DA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 155/155] media: v4l2-core: fix a use-after-free bug of sd->devnode
Date:   Tue, 31 Mar 2020 10:59:55 +0200
Message-Id: <20200331085435.385893149@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

commit 6990570f7e0a6078e11b9c5dc13f4b6e3f49a398 upstream.

sd->devnode is released after calling
v4l2_subdev_release. Therefore it should be set
to NULL so that the subdev won't hold a pointer
to a released object. This fixes a reference
after free bug in function
v4l2_device_unregister_subdev

Fixes: 0e43734d4c46e ("media: v4l2-subdev: add release() internal op")

Cc: stable@vger.kernel.org
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/v4l2-device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -179,6 +179,7 @@ static void v4l2_subdev_release(struct v
 
 	if (sd->internal_ops && sd->internal_ops->release)
 		sd->internal_ops->release(sd);
+	sd->devnode = NULL;
 	module_put(owner);
 }
 


