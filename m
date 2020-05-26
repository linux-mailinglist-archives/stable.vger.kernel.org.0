Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6474B1E2E0C
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391482AbgEZTFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:05:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391478AbgEZTFQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:05:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26809208B8;
        Tue, 26 May 2020 19:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519915;
        bh=iJEzzmF0Ft5H2GY7TTk0kkGMH07ZfnxhaYQX2yvZEUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQ/eAYKyg37gZ4UI8EVocSaoNOsnAC3+5/SyB7qqr9xh8c0CcIvx/A0XpIqvVXnM9
         7TNT4OnKUJLZRZ689Bn4oaab9k6K5DU7rADs9OkxeI4Wwyuk2rRCeRwB4YFC3b3b4c
         OGuks/zYAGP/76la0prQ0CcubY6MoLWB6zckxd6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 68/81] iio: dac: vf610: Fix an error handling path in vf610_dac_probe()
Date:   Tue, 26 May 2020 20:53:43 +0200
Message-Id: <20200526183934.600440442@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit aad4742fbf0a560c25827adb58695a4497ffc204 upstream.

A call to 'vf610_dac_exit()' is missing in an error handling path.

Fixes: 1b983bf42fad ("iio: dac: vf610_dac: Add IIO DAC driver for Vybrid SoC")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/dac/vf610_dac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/vf610_dac.c
+++ b/drivers/iio/dac/vf610_dac.c
@@ -234,6 +234,7 @@ static int vf610_dac_probe(struct platfo
 	return 0;
 
 error_iio_device_register:
+	vf610_dac_exit(info);
 	clk_disable_unprepare(info->clk);
 
 	return ret;


