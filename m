Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E134521BC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348270AbhKPBGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245420AbhKOTUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22BDF61ACE;
        Mon, 15 Nov 2021 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001252;
        bh=HYYexdyaP5ieWXOXOwAYrUfbidGrJngZ6RFA6swgzLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmzk/VxxsHuXKw/DBO88cidvE0EOBOGU330uwYhosC4ITv3Y0EECWmfP0OFo4moxz
         VCRFOCFi6QrhD5JZiy6n6lxLwgO+oCDIPa8we91/6/5ddJoaJGYmlNV2D0chHA6jYS
         ujAb2KN2RSCEhihBUh+yD7UrndQxWWK9Fb+NiNC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 119/917] iio: core: fix double free in iio_device_unregister_sysfs()
Date:   Mon, 15 Nov 2021 17:53:34 +0100
Message-Id: <20211115165432.781199882@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 19833c40d0415d6fe4340b5b9c46239abbf718f6 upstream.

I got the double free report:

BUG: KASAN: double-free or invalid-free in kfree+0xce/0x390
 iio_device_unregister_sysfs+0x108/0x13b [industrialio]
 iio_dev_release+0x9e/0x10e [industrialio]
 device_release+0xa5/0x240

If __iio_device_register() fails, iio_dev_opaque->groups will be freed
in error path in iio_device_unregister_sysfs(), then iio_dev_release()
will call iio_device_unregister_sysfs() again, it causes double free.
Set iio_dev_opaque->groups to NULL when it's freed to fix this double free.

Not this is a local work around for a more general mess around life time
management that will get cleaned up and should make this handling
unnecesarry.

Fixes: 32f171724e5c ("iio: core: rework iio device group creation")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211013030532.956133-1-yangyingliang@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1600,6 +1600,7 @@ static void iio_device_unregister_sysfs(
 	kfree(iio_dev_opaque->chan_attr_group.attrs);
 	iio_dev_opaque->chan_attr_group.attrs = NULL;
 	kfree(iio_dev_opaque->groups);
+	iio_dev_opaque->groups = NULL;
 }
 
 static void iio_dev_release(struct device *device)


