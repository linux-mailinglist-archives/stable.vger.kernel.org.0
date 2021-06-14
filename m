Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEA33A6442
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbhFNLWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236057AbhFNLUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9B746124B;
        Mon, 14 Jun 2021 10:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667896;
        bh=M+mp2mty580h+8V6h5y5VU36PuJpZXnftEuPQHDzZyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjF/2eSFaHAW8bi6MpWKwglTYCq2nuTJ7IFegW4AV/g75jVLup9dBEvKoiO1+usFX
         +TQYC1mxfSbrVJZC8h0tMlCYhuNXCQzjskNtFmqLtgwVUeheleBpeR02NKIbOpK+kN
         ZKuuZUIxweGDxBoU91SsdZyS1U6Y5KvK3u6eNsiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.12 099/173] usb: gadget: f_fs: Ensure io_completion_wq is idle during unbind
Date:   Mon, 14 Jun 2021 12:27:11 +0200
Message-Id: <20210614102701.455627186@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

commit 6fc1db5e6211e30fbb1cee8d7925d79d4ed2ae14 upstream.

During unbind, ffs_func_eps_disable() will be executed, resulting in
completion callbacks for any pending USB requests.  When using AIO,
irrespective of the completion status, io_data work is queued to
io_completion_wq to evaluate and handle the completed requests.  Since
work runs asynchronously to the unbind() routine, there can be a
scenario where the work runs after the USB gadget has been fully
removed, resulting in accessing of a resource which has been already
freed. (i.e. usb_ep_free_request() accessing the USB ep structure)

Explicitly drain the io_completion_wq, instead of relying on the
destroy_workqueue() (in ffs_data_put()) to make sure no pending
completion work items are running.

Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1621644261-1236-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -3567,6 +3567,9 @@ static void ffs_func_unbind(struct usb_c
 		ffs->func = NULL;
 	}
 
+	/* Drain any pending AIO completions */
+	drain_workqueue(ffs->io_completion_wq);
+
 	if (!--opts->refcnt)
 		functionfs_unbind(ffs);
 


