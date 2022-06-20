Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFA65519D0
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244123AbiFTNEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244788AbiFTNEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9651AF31;
        Mon, 20 Jun 2022 05:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD0D4B81092;
        Mon, 20 Jun 2022 12:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11908C3411B;
        Mon, 20 Jun 2022 12:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729914;
        bh=//3TnK2oF9ccyJllNvDqoAXV3vpMCnk8UFstdNYtRLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5xhHEBbhWU5OTH3SI4j7tui4aoHDEOtKPgkPCf1dbl9srvyOOhIXku5vAAaBhMbt
         gOuNIZarN4GvPgdV0NKJqJwou7gD5844fgUyiSJTuBkBNB6D3cZTauiqo1BvmAVnQ/
         KLv2vJmeHdMKg52vcC5Ez+fJKc5N38ZuOG6DFQ8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Wu <michael@allwinnertech.com>,
        John Keeping <john@metanate.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH 5.18 114/141] usb: gadget: f_fs: change ep->ep safe in ffs_epfile_io()
Date:   Mon, 20 Jun 2022 14:50:52 +0200
Message-Id: <20220620124732.915311387@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linyu Yuan <quic_linyyuan@quicinc.com>

commit 0698f0209d8032e8869525aeb68f65ee7fde12ad upstream.

In ffs_epfile_io(), when read/write data in blocking mode, it will wait
the completion in interruptible mode, if task receive a signal, it will
terminate the wait, at same time, if function unbind occurs,
ffs_func_unbind() will kfree all eps, ffs_epfile_io() still try to
dequeue request by dereferencing ep which may become invalid.

Fix it by add ep spinlock and will not dereference ep if it is not valid.

Cc: <stable@vger.kernel.org> # 5.15
Reported-by: Michael Wu <michael@allwinnertech.com>
Tested-by: Michael Wu <michael@allwinnertech.com>
Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Link: https://lore.kernel.org/r/1654863478-26228-3-git-send-email-quic_linyyuan@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1080,6 +1080,11 @@ static ssize_t ffs_epfile_io(struct file
 		spin_unlock_irq(&epfile->ffs->eps_lock);
 
 		if (wait_for_completion_interruptible(&io_data->done)) {
+			spin_lock_irq(&epfile->ffs->eps_lock);
+			if (epfile->ep != ep) {
+				ret = -ESHUTDOWN;
+				goto error_lock;
+			}
 			/*
 			 * To avoid race condition with ffs_epfile_io_complete,
 			 * dequeue the request first then check
@@ -1087,6 +1092,7 @@ static ssize_t ffs_epfile_io(struct file
 			 * condition with req->complete callback.
 			 */
 			usb_ep_dequeue(ep->ep, req);
+			spin_unlock_irq(&epfile->ffs->eps_lock);
 			wait_for_completion(&io_data->done);
 			interrupted = io_data->status < 0;
 		}


