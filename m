Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA2538D449
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 09:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhEVHvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 03:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230111AbhEVHvp (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 22 May 2021 03:51:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 751986120D;
        Sat, 22 May 2021 07:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621669820;
        bh=yZkohx4DpRNx2E/ecAcuASe/9eKV/88FqPJLYmJnPyQ=;
        h=Subject:To:From:Date:From;
        b=a0mQb4rre5BabAJn/SsJp1O/BobA/n4Xp8Ok0UdDZwQomvlJcjLmJSRxd8DKURw42
         ui1ISKj7JB64JxTrxOAIas87sF5yReXrCiZYn9zG4VWg6ZqeJ/j0RY/wE3ezRLohs8
         XTIsYHXHGk46dekKLuWF6nWcDtXot4Wc0S9aJsHo=
Subject: patch "iio: adc: ad7124: Fix potential overflow due to non sequential" added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        aardelean@deviqon.com, ardeleanalex@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 May 2021 09:50:17 +0200
Message-ID: <162166981710224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7124: Fix potential overflow due to non sequential

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f2a772c51206b0c3f262e4f6a3812c89a650191b Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Thu, 13 May 2021 15:07:42 +0300
Subject: iio: adc: ad7124: Fix potential overflow due to non sequential
 channel numbers

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
---
 drivers/iio/adc/ad7124.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index 437116a07cf1..a27db78ea13e 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -771,6 +771,13 @@ static int ad7124_of_parse_channel_config(struct iio_dev *indio_dev,
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
-- 
2.31.1


