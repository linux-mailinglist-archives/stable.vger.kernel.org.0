Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A331C1383
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgEANaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728916AbgEANaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:30:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B738D20757;
        Fri,  1 May 2020 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339815;
        bh=nGTL1wh7egZT7n+lqj36JrU0NugYFFSPPXaJzaJsVU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMOZT6zOfGxeSbhEKVWcwLDmB3DakeuP9hKNxKq2O3VkZDqjbtAp1NTla533XpOAB
         fxJx3e4apras6mI0UzNEWAIvZDvp1rUnuyz5e99R0Q5ozeupSESW3qyt+S4vf3XnLH
         jykflUaYLs2aSEY+pbzxkKwN1LHuhdQ9eiApuR5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Udipto Goswami <ugoswami@codeaurora.org>,
        Sriharsha Allenki <sallenki@codeaurora.org>,
        Manu Gautam <mgautam@codeaurora.org>
Subject: [PATCH 4.9 58/80] usb: f_fs: Clear OS Extended descriptor counts to zero in ffs_data_reset()
Date:   Fri,  1 May 2020 15:21:52 +0200
Message-Id: <20200501131531.023129637@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Udipto Goswami <ugoswami@codeaurora.org>

commit 1c2e54fbf1da5e5445a0ab132c862b02ccd8d230 upstream.

For userspace functions using OS Descriptors, if a function also supplies
Extended Property descriptors currently the counts and lengths stored in
the ms_os_descs_ext_prop_{count,name_len,data_len} variables are not
getting reset to 0 during an unbind or when the epfiles are closed. If
the same function is re-bound and the descriptors are re-written, this
results in those count/length variables to monotonically increase
causing the VLA allocation in _ffs_func_bind() to grow larger and larger
at each bind/unbind cycle and eventually fail to allocate.

Fix this by clearing the ms_os_descs_ext_prop count & lengths to 0 in
ffs_data_reset().

Fixes: f0175ab51993 ("usb: gadget: f_fs: OS descriptors support")
Cc: stable@vger.kernel.org
Signed-off-by: Udipto Goswami <ugoswami@codeaurora.org>
Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
Reviewed-by: Manu Gautam <mgautam@codeaurora.org>
Link: https://lore.kernel.org/r/20200402044521.9312-1-sallenki@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_fs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1701,6 +1701,10 @@ static void ffs_data_reset(struct ffs_da
 	ffs->state = FFS_READ_DESCRIPTORS;
 	ffs->setup_state = FFS_NO_SETUP;
 	ffs->flags = 0;
+
+	ffs->ms_os_descs_ext_prop_count = 0;
+	ffs->ms_os_descs_ext_prop_name_len = 0;
+	ffs->ms_os_descs_ext_prop_data_len = 0;
 }
 
 


