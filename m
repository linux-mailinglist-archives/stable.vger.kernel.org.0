Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A981E2E80
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391135AbgEZT3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391040AbgEZTCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:02:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9714720849;
        Tue, 26 May 2020 19:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519729;
        bh=vGmwZHpig1AFU6Fxkz5cwv3Zkugjp1Au9Ze6oLu3msg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIA7xXq02xX3+PR1HI99Wd63ZeMH6uxs/jQSLgg3u3X7M1AxmqOVi0QTV15xCj7rM
         6JM4bRPq1JXnPiJAphtdI/S2qDJioHZRsZ1+PVPcRijm9pi0CSC70s+wNrwoe33P0z
         9xNAGS6rIjydWiun+CpbMduCRZF73kPNEAjnrcws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 53/59] iio: dac: vf610: Fix an error handling path in vf610_dac_probe()
Date:   Tue, 26 May 2020 20:53:38 +0200
Message-Id: <20200526183923.164645221@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
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
@@ -235,6 +235,7 @@ static int vf610_dac_probe(struct platfo
 	return 0;
 
 error_iio_device_register:
+	vf610_dac_exit(info);
 	clk_disable_unprepare(info->clk);
 
 	return ret;


