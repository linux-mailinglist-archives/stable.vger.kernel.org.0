Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED873431AC8
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhJRN3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231893AbhJRN3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3574E6135A;
        Mon, 18 Oct 2021 13:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563584;
        bh=UrQb19vn92t+wlWhi0MJjKgCXzBQqaBIrbL0uQajCP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0JqEjVijANWLH6dNDSdDB/yo069e8jWPyp2iASx0/o5zJNzSV7k1Pl4cyQT7uKsy
         FGtuC1VWRZp2En5YZ7OWZ5bfz3s0qTjzxgL91dHva1i86bxQVADxwhcBXSNDY/3YD7
         a/swyVu+mcBfx/vKh5FiiFKTjrX8gsoqGW5umTOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Valek - 2N <valek@2n.cz>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 23/39] iio: light: opt3001: Fixed timeout error when 0 lux
Date:   Mon, 18 Oct 2021 15:24:32 +0200
Message-Id: <20211018132326.189742955@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Valek - 2N <valek@2n.cz>

commit 26d90b5590579def54382a2fc34cfbe8518a9851 upstream.

Reading from sensor returned timeout error under
zero light conditions.

Signed-off-by: Jiri Valek - 2N <valek@2n.cz>
Fixes: ac663db3678a ("iio: light: opt3001: enable operation w/o IRQ")
Link: https://lore.kernel.org/r/20210920125351.6569-1-valek@2n.cz
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt3001.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -283,6 +283,8 @@ static int opt3001_get_lux(struct opt300
 		ret = wait_event_timeout(opt->result_ready_queue,
 				opt->result_ready,
 				msecs_to_jiffies(OPT3001_RESULT_READY_LONG));
+		if (ret == 0)
+			return -ETIMEDOUT;
 	} else {
 		/* Sleep for result ready time */
 		timeout = (opt->int_time == OPT3001_INT_TIME_SHORT) ?
@@ -319,9 +321,7 @@ err:
 		/* Disallow IRQ to access the device while lock is active */
 		opt->ok_to_ignore_lock = false;
 
-	if (ret == 0)
-		return -ETIMEDOUT;
-	else if (ret < 0)
+	if (ret < 0)
 		return ret;
 
 	if (opt->use_irq) {


