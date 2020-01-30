Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253FC14E2BE
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgA3SyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:54:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729951AbgA3Sk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:40:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F0032082E;
        Thu, 30 Jan 2020 18:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409626;
        bh=IEY2DK0mVd3QRoS/LYnosAPqfWr7Mx1laUopAzlAE6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAouV2QIW3DkCf3j1WW/AvOrbke1CbITAi5fuGUvVwTWRo/Jnn72DSjRUcNqUqC89
         MFkqC0YdYryJgpfH/xZsHHzGQ33L6cd5loIRuCa296iSeXvnD8s608dNLcGNWd74Bd
         /2sVVb+7n/FLWcWpYOBXC8hFZxqFnPwN8YhTvWR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.5 25/56] iio: adc: stm32-dfsdm: fix single conversion
Date:   Thu, 30 Jan 2020 19:38:42 +0100
Message-Id: <20200130183613.744768597@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit dc26935fb60e8da8d59655dd2ec0de47b20d7d8f upstream.

Apply data formatting to single conversion,
as this is already done in continuous and trigger modes.

Fixes: 102afde62937 ("iio: adc: stm32-dfsdm: manage data resolution in trigger mode")

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Cc: <Stable@vger.kernel.org>
Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/stm32-dfsdm-adc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -1204,6 +1204,8 @@ static int stm32_dfsdm_single_conv(struc
 
 	stm32_dfsdm_stop_conv(adc);
 
+	stm32_dfsdm_process_data(adc, res);
+
 stop_dfsdm:
 	stm32_dfsdm_stop_dfsdm(adc->dfsdm);
 


