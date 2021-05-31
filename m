Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1415239600F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhEaOWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233237AbhEaOQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:16:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAFBB61483;
        Mon, 31 May 2021 13:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468603;
        bh=P5J+fU+9gaBNgUgKE/RpVtOa9cecFo5mxU4RJjIqx6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3RdRscCwhFWNmPBpePRzLP6eEUs4C8n6XOk5YnKIr3RPnvP5ec+jF4TK2sg2aQ0Y
         vTnFuTTXcHJOKlqNoPHcSV4X3i2EZpFhhLE0J3+lcfCrutWdkk+CgM9KaiRoPEtLg5
         DBdi4ar0cm+T6f+6cnTvezPA51NRxPGDmiMQrVKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <aardelean@deviqon.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.4 047/177] iio: adc: ad7124: Fix potential overflow due to non sequential channel numbers
Date:   Mon, 31 May 2021 15:13:24 +0200
Message-Id: <20210531130649.545479156@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit f2a772c51206b0c3f262e4f6a3812c89a650191b upstream.

Channel numbering must start at 0 and then not have any holes, or
it is possible to overflow the available storage.  Note this bug was
introduced as part of a fix to ensure we didn't rely on the ordering
of child nodes.  So we need to support arbitrary ordering but they all
need to be there somewhere.

Note I hit this when using qemu to test the rest of this series.
Arguably this isn't the best fix, but it is probably the most minimal
option for backporting etc.

Alexandru's sign-off is here because he carried this patch in a larger
set that Jonathan then applied.

Fixes: d7857e4ee1ba6 ("iio: adc: ad7124: Fix DT channel configuration")
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Alexandru Ardelean <aardelean@deviqon.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -473,6 +473,13 @@ static int ad7124_of_parse_channel_confi
 		if (ret)
 			goto err;
 
+		if (channel >= indio_dev->num_channels) {
+			dev_err(indio_dev->dev.parent,
+				"Channel index >= number of channels\n");
+			ret = -EINVAL;
+			goto err;
+		}
+
 		ret = of_property_read_u32_array(child, "diff-channels",
 						 ain, 2);
 		if (ret)


