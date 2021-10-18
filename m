Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92A8431E28
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbhJRN6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234474AbhJRN4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:56:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8222761A07;
        Mon, 18 Oct 2021 13:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564428;
        bh=fwWc1vHc++P7U8++KRpjhEkjrQAy4ulOHvPESQ1xhfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y81LCEA6RAuFm6f/IX599cR4aKiaG296Ao0W0rBahl8aUG6sMQuOe7I9LzJXcTcHq
         1+513bCrZdY67ITMiSisz2+v08LFrLIYcnmPf5SaCnrCLoZ7oBuS835pDfLl9Ohoct
         GsuQIfI9J7X7hWQ/Le5H76IG0/XKO4iz10BPIIMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 086/151] iio: dac: ti-dac5571: fix an error code in probe()
Date:   Mon, 18 Oct 2021 15:24:25 +0200
Message-Id: <20211018132343.488553361@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
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
@@ -350,6 +350,7 @@ static int dac5571_probe(struct i2c_clie
 		data->dac5571_pwrdwn = dac5571_pwrdwn_quad;
 		break;
 	default:
+		ret = -EINVAL;
 		goto err;
 	}
 


