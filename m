Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3826A2A523E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgKCUsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731648AbgKCUsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 598FD2242A;
        Tue,  3 Nov 2020 20:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436491;
        bh=GtkWJF9pzV0zi9XILsfhW7l8ZFg4k0EpSUF4Xj2UImA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfxCX8AhC6SIrckefnMuPAZ9r8hSMfFBe+nykIO3tnHF539iwDdCRviFBefo0Jocv
         4OfQBM+Js8lueHbFl5/i74TkHLkHiL7881V0gtvTpXHphqSB01fBa5mBnpI+14EFMX
         82fahfAFSVMliclKQYCvJlj+H88eHzMomNTRhGBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.9 274/391] iio: ad7292: Fix of_node refcounting
Date:   Tue,  3 Nov 2020 21:35:25 +0100
Message-Id: <20201103203405.522185815@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit b8a533f3c24b3b8f1fdbefc5ada6a7d5733d63e6 upstream.

When returning or breaking early from a
`for_each_available_child_of_node()` loop, we need to explicitly call
`of_node_put()` on the child node to possibly release the node.

Fixes: 506d2e317a0a0 ("iio: adc: Add driver support for AD7292")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200925091045.302-2-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ad7292.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7292.c
+++ b/drivers/iio/adc/ad7292.c
@@ -310,8 +310,10 @@ static int ad7292_probe(struct spi_devic
 
 	for_each_available_child_of_node(spi->dev.of_node, child) {
 		diff_channels = of_property_read_bool(child, "diff-channels");
-		if (diff_channels)
+		if (diff_channels) {
+			of_node_put(child);
 			break;
+		}
 	}
 
 	if (diff_channels) {


