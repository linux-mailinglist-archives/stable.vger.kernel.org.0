Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52FE431C1B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhJRNjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233000AbhJRNgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:36:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFDD1613B5;
        Mon, 18 Oct 2021 13:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563867;
        bh=o3SKVBWmzwExcDiq6bU4iIj+Ih/BOWbR68HrqV6HN28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqPhdNNepw4QCibbuFLo5VHI3zOrl35B6eOyOdTPCBP/cw/9IjvvWRcjXymJGcX/x
         L481VEcZULUTprlRbUMyockYzZswT5/vx8h1U+jPx8bMCED4UCN/o5khTtZvsGMqDx
         +mhT6J9pRIC5gEIW/wvz+DftcfMPulG+gMmeCmaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 44/69] iio: dac: ti-dac5571: fix an error code in probe()
Date:   Mon, 18 Oct 2021 15:24:42 +0200
Message-Id: <20211018132330.933098725@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f7a28df7db84eb3410e9eca37832efa5aed93338 upstream.

If we have an unexpected number of channels then return -EINVAL instead
of returning success.

Fixes: df38a4a72a3b ("iio: dac: add TI DAC5571 family support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20210816183954.GB2068@kili
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ti-dac5571.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/ti-dac5571.c
+++ b/drivers/iio/dac/ti-dac5571.c
@@ -352,6 +352,7 @@ static int dac5571_probe(struct i2c_clie
 		data->dac5571_pwrdwn = dac5571_pwrdwn_quad;
 		break;
 	default:
+		ret = -EINVAL;
 		goto err;
 	}
 


