Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67EC4B4C7E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbiBNKmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:42:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348972AbiBNKko (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:40:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503F666CB2;
        Mon, 14 Feb 2022 02:04:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98374B80DA6;
        Mon, 14 Feb 2022 10:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93976C340E9;
        Mon, 14 Feb 2022 10:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644833059;
        bh=cfRNTzRBRWZmlfr+OlmF4r/V5ZSQ1qauyvLgImIoMlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtuKCft/j+X+XPr1NgyhkJmfOq9BvYR5qBvLtPK4PLaYGvRIZPX/8/kIHlKHeD4D1
         0s9kL1uC8eNgwLKldc41d3mOs54U1vpWbkMMfqCmlakexV/L7M5HxjJdn31Dj/mA9w
         lyhhhIKTj1lu8JT+caSZUhj2esLnYa9p7T4E2h4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Nuno Sa <Nuno.Sa@analog.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mathias Krause <minipli@grsecurity.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.16 184/203] iio: buffer: Fix file related error handling in IIO_BUFFER_GET_FD_IOCTL
Date:   Mon, 14 Feb 2022 10:27:08 +0100
Message-Id: <20220214092516.498129131@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Krause <minipli@grsecurity.net>

commit c72ea20503610a4a7ba26c769357d31602769c01 upstream.

If we fail to copy the just created file descriptor to userland, we
try to clean up by putting back 'fd' and freeing 'ib'. The code uses
put_unused_fd() for the former which is wrong, as the file descriptor
was already published by fd_install() which gets called internally by
anon_inode_getfd().

This makes the error handling code leaving a half cleaned up file
descriptor table around and a partially destructed 'file' object,
allowing userland to play use-after-free tricks on us, by abusing
the still usable fd and making the code operate on a dangling
'file->private_data' pointer.

Instead of leaving the kernel in a partially corrupted state, don't
attempt to explicitly clean up and leave this to the process exit
path that'll release any still valid fds, including the one created
by the previous call to anon_inode_getfd(). Simply return -EFAULT to
indicate the error.

Fixes: f73f7f4da581 ("iio: buffer: add ioctl() to support opening extra buffers for IIO device")
Cc: stable@kernel.org
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Alexandru Ardelean <ardeleanalex@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Nuno Sa <Nuno.Sa@analog.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1569,9 +1569,17 @@ static long iio_device_buffer_getfd(stru
 	}
 
 	if (copy_to_user(ival, &fd, sizeof(fd))) {
-		put_unused_fd(fd);
-		ret = -EFAULT;
-		goto error_free_ib;
+		/*
+		 * "Leak" the fd, as there's not much we can do about this
+		 * anyway. 'fd' might have been closed already, as
+		 * anon_inode_getfd() called fd_install() on it, which made
+		 * it reachable by userland.
+		 *
+		 * Instead of allowing a malicious user to play tricks with
+		 * us, rely on the process exit path to do any necessary
+		 * cleanup, as in releasing the file, if still needed.
+		 */
+		return -EFAULT;
 	}
 
 	return 0;


