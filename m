Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815F545248B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242885AbhKPBjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:39:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241959AbhKOSbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:31:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C31D63210;
        Mon, 15 Nov 2021 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999147;
        bh=kYgEVs0fAOvf9AfDDiC3CMedu3j9nZzeDkHIU1KLcJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrR+OB9c9n8DvFxTexjl8U8E7HtVm3pLByxtBGWd86rplpTV4V+xRcXKMouIIC/fO
         9t3codmWJpn4tnxAsZ/91zBZ9/mLk9TLe4POcDZa2Y/9kYkSz0CD5SUuodvlr/Obnp
         /zLPyQWkewXfYWZqnTo7JixY6ACufEadWhsHYpmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 193/849] iio: buffer: Fix memory leak in iio_buffer_register_legacy_sysfs_groups()
Date:   Mon, 15 Nov 2021 17:54:36 +0100
Message-Id: <20211115165426.725514047@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 604faf9a2ecd1addcc0c10a47e5aaef3c4d4fd6b upstream.

If the second iio_device_register_sysfs_group() fails,
'legacy_buffer_group.attrs' need be freed too or it will
cause memory leak:

unreferenced object 0xffff888003618280 (size 64):
  comm "xrun", pid 357, jiffies 4294907259 (age 22.296s)
  hex dump (first 32 bytes):
    80 f6 8c 03 80 88 ff ff 80 fb 8c 03 80 88 ff ff  ................
    00 f9 8c 03 80 88 ff ff 80 fc 8c 03 80 88 ff ff  ................
  backtrace:
    [<00000000076bfd43>] __kmalloc+0x1a3/0x2f0
    [<00000000c32e4886>] iio_buffers_alloc_sysfs_and_mask+0xc31/0x1290 [industrialio]

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d9a625744ed0 ("iio: core: merge buffer/ & scan_elements/ attributes")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211013144242.1685060-1-yangyingliang@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1366,10 +1366,10 @@ static int iio_buffer_register_legacy_sy
 
 	return 0;
 
-error_free_buffer_attrs:
-	kfree(iio_dev_opaque->legacy_buffer_group.attrs);
 error_free_scan_el_attrs:
 	kfree(iio_dev_opaque->legacy_scan_el_group.attrs);
+error_free_buffer_attrs:
+	kfree(iio_dev_opaque->legacy_buffer_group.attrs);
 
 	return ret;
 }


