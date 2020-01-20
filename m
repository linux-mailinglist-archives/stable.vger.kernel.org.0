Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92875142780
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 10:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgATJmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 04:42:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgATJmv (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 Jan 2020 04:42:51 -0500
Received: from localhost (unknown [89.205.136.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88A242087E;
        Mon, 20 Jan 2020 09:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579513370;
        bh=DXODXE7M1rOOyJTc/ylMFnIM8Uw5bPRmqGEz9lRn+wc=;
        h=Subject:To:From:Date:From;
        b=gaXNiNf+V8Mp7xPjQnmN0VVz+f7p1mZIlVmHCMq1BEI4+P5/9cYBWjdAFscCluUj3
         f4GAhVlyaQSbgrqJfT+vD4pwNM3Cz94ELXj3MJBACbllETtt4Sr67a2GeJVbG1UqYB
         YWjBrWJM89S7W1LWqfvg6XGZ3fP3RbsYa0QCEMg8=
Subject: patch "iio: adc: stm32-dfsdm: fix single conversion" added to staging-next
To:     olivier.moysan@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, fabrice.gasnier@st.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jan 2020 10:42:08 +0100
Message-ID: <15795133287927@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: stm32-dfsdm: fix single conversion

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From dc26935fb60e8da8d59655dd2ec0de47b20d7d8f Mon Sep 17 00:00:00 2001
From: Olivier Moysan <olivier.moysan@st.com>
Date: Wed, 27 Nov 2019 14:07:29 +0100
Subject: iio: adc: stm32-dfsdm: fix single conversion

Apply data formatting to single conversion,
as this is already done in continuous and trigger modes.

Fixes: 102afde62937 ("iio: adc: stm32-dfsdm: manage data resolution in trigger mode")

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Cc: <Stable@vger.kernel.org>
Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/stm32-dfsdm-adc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/stm32-dfsdm-adc.c b/drivers/iio/adc/stm32-dfsdm-adc.c
index 74a2211bdff4..1c9b05d11dc5 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -1204,6 +1204,8 @@ static int stm32_dfsdm_single_conv(struct iio_dev *indio_dev,
 
 	stm32_dfsdm_stop_conv(adc);
 
+	stm32_dfsdm_process_data(adc, res);
+
 stop_dfsdm:
 	stm32_dfsdm_stop_dfsdm(adc->dfsdm);
 
-- 
2.25.0


