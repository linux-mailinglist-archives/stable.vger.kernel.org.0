Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0E3101307
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKSFVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:21:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbfKSFVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:21:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E80B2231E;
        Tue, 19 Nov 2019 05:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140901;
        bh=M9UiyZVMeccIddzvbT2WqNFNT1gmpQNvIV7+pEG7gUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PloEHpR6lj+jNoA+YXZcKsPpC1thSZOUyLvhxuaPrEQ5o5eaV6azPnuYZoKlBqrx3
         yQLb9BMulleizjNGKwfdQ9YgsXkNdvo45G+rRKjAgiZj+lCvlcanaBFB6SESF/Qqfv
         6KIT4nJHZ7Rvns19ojzjVXaTWoQ1CT6tdVZZXyBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.3 25/48] Input: synaptics-rmi4 - destroy F54 poller workqueue when removing
Date:   Tue, 19 Nov 2019 06:19:45 +0100
Message-Id: <20191119051008.063903320@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit ba60cf9f78f0d7c8e73c7390608f7f818ee68aa0 upstream.

The driver forgets to destroy workqueue in remove() similarly to what is
done when probe() fails. Add a call to destroy_workqueue() to fix it.

Since unregistration will wait for the work to finish, we do not need to
cancel/flush the work instance in remove().

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191114023405.31477-1-hslester96@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/rmi4/rmi_f54.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/rmi4/rmi_f54.c
+++ b/drivers/input/rmi4/rmi_f54.c
@@ -730,6 +730,7 @@ static void rmi_f54_remove(struct rmi_fu
 
 	video_unregister_device(&f54->vdev);
 	v4l2_device_unregister(&f54->v4l2);
+	destroy_workqueue(f54->workqueue);
 }
 
 struct rmi_function_handler rmi_f54_handler = {


