Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78A13DA4DE
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237986AbhG2N4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237966AbhG2N4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F16860F43;
        Thu, 29 Jul 2021 13:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627566995;
        bh=bcO26zBBEVdM3RxsdZaiijUs4gHzPrd1vfixM3/jTSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOrvtv9iXgDPXEsSFYj8/v0of9AUj/eB5BZ/XwitjEiGCPjV34Kmwcs8ifrDNZqVe
         2Gyb3zE5xdP2aW0sfJWx2FOAu1vJ8iua93tsbxr6hDV9APUBjZFUxuIW5kyePZsSD5
         oQOAydmvrrSSWjZbTpSQ4B+QA4TubA9AzZutKycs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruslan Babayev <ruslan@babayev.com>,
        xe-linux-external@cisco.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH 4.19 02/17] iio: dac: ds4422/ds4424 drop of_node check
Date:   Thu, 29 Jul 2021 15:54:03 +0200
Message-Id: <20210729135137.335923545@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
References: <20210729135137.260993951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruslan Babayev <ruslan@babayev.com>

commit a2d2010d95cd7ffe3773aba6eaee35d54e332c25 upstream.

The driver doesn't actually rely on any DT properties. Removing this
check makes it usable on ACPI based platforms.

Signed-off-by: Ruslan Babayev <ruslan@babayev.com>
Cc: xe-linux-external@cisco.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ds4424.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/iio/dac/ds4424.c
+++ b/drivers/iio/dac/ds4424.c
@@ -236,12 +236,6 @@ static int ds4424_probe(struct i2c_clien
 	indio_dev->dev.of_node = client->dev.of_node;
 	indio_dev->dev.parent = &client->dev;
 
-	if (!client->dev.of_node) {
-		dev_err(&client->dev,
-				"Not found DT.\n");
-		return -ENODEV;
-	}
-
 	data->vcc_reg = devm_regulator_get(&client->dev, "vcc");
 	if (IS_ERR(data->vcc_reg)) {
 		dev_err(&client->dev,


