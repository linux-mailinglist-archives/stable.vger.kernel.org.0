Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB473A03E3
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhFHTWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238780AbhFHTUD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:20:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77FD761437;
        Tue,  8 Jun 2021 18:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178343;
        bh=DvuOgeutVAc7nrNpiNyLeazw54aCJqawR0IwjpXkAK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNU1Be0Nk0BkfusjYddeHYswLEQJ0tgC4ePNZ9L9GQE3rhtVlBAeJYplmmRZMyGbJ
         gdc/xSoLXj7Jtz89z7LKkMfAMEWUMj27pHJHqpRj4RLnMVtkwI82nS+xTJW4daYonc
         2gYbp28QUJFW42GuTW3o5gIWjZ4DyXc/ePyW64UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.12 160/161] xen-netback: take a reference to the RX task thread
Date:   Tue,  8 Jun 2021 20:28:10 +0200
Message-Id: <20210608175950.858927838@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

commit 107866a8eb0b664675a260f1ba0655010fac1e08 upstream.

Do this in order to prevent the task from being freed if the thread
returns (which can be triggered by the frontend) before the call to
kthread_stop done as part of the backend tear down. Not taking the
reference will lead to a use-after-free in that scenario. Such
reference was taken before but dropped as part of the rework done in
2ac061ce97f4.

Reintroduce the reference taking and add a comment this time
explaining why it's needed.

This is XSA-374 / CVE-2021-28691.

Fixes: 2ac061ce97f4 ('xen/netback: cleanup init and deinit code')
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/interface.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -684,6 +684,7 @@ static void xenvif_disconnect_queue(stru
 {
 	if (queue->task) {
 		kthread_stop(queue->task);
+		put_task_struct(queue->task);
 		queue->task = NULL;
 	}
 
@@ -745,6 +746,11 @@ int xenvif_connect_data(struct xenvif_qu
 	if (IS_ERR(task))
 		goto kthread_err;
 	queue->task = task;
+	/*
+	 * Take a reference to the task in order to prevent it from being freed
+	 * if the thread function returns before kthread_stop is called.
+	 */
+	get_task_struct(task);
 
 	task = kthread_run(xenvif_dealloc_kthread, queue,
 			   "%s-dealloc", queue->name);


