Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EEF422225
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhJEJXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233771AbhJEJXe (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1E4461165;
        Tue,  5 Oct 2021 09:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425704;
        bh=Qs6YIN5F0W253w+VJbaBbipBl4OfiDy3IX739FBjo5o=;
        h=Subject:To:From:Date:From;
        b=PFKibOsJfoB/JtrAR/eyt/7/SunAOiApxL7iizDKoLNeWBXKmDkwsstGzqwZvwwVP
         1afJeaVXy9JMnFGXCwuhax1v1ILqyPrMhKgn8cFKSzM6W6DBsNrahtOY8gMySQHTzu
         aLnuArncbVNiBWsBKV4MPGiCQm47+hT1BwQ3iq9Q=
Subject: patch "iio: ssp_sensors: fix error code in ssp_print_mcu_debug()" added to staging-linus
To:     dan.carpenter@oracle.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, jic23@kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:24 +0200
Message-ID: <163342568421375@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: ssp_sensors: fix error code in ssp_print_mcu_debug()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4170d3dd1467e9d78cb9af374b19357dc324b328 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 14 Sep 2021 13:53:33 +0300
Subject: iio: ssp_sensors: fix error code in ssp_print_mcu_debug()

The ssp_print_mcu_debug() function should return negative error codes on
error.  Returning "length" is meaningless.  This change does not affect
runtime because the callers only care about zero/non-zero.

Reported-by: Jonathan Cameron <jic23@kernel.org>
Fixes: 50dd64d57eee ("iio: common: ssp_sensors: Add sensorhub driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20210914105333.GA11657@kili
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/common/ssp_sensors/ssp_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/common/ssp_sensors/ssp_spi.c b/drivers/iio/common/ssp_sensors/ssp_spi.c
index 4864c38b8d1c..77449b4f3df5 100644
--- a/drivers/iio/common/ssp_sensors/ssp_spi.c
+++ b/drivers/iio/common/ssp_sensors/ssp_spi.c
@@ -137,7 +137,7 @@ static int ssp_print_mcu_debug(char *data_frame, int *data_index,
 	if (length > received_len - *data_index || length <= 0) {
 		ssp_dbg("[SSP]: MSG From MCU-invalid debug length(%d/%d)\n",
 			length, received_len);
-		return length ? length : -EPROTO;
+		return -EPROTO;
 	}
 
 	ssp_dbg("[SSP]: MSG From MCU - %s\n", &data_frame[*data_index]);
-- 
2.33.0


