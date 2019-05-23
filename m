Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A62828795
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389746AbfEWTVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388894AbfEWTVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:21:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AC272133D;
        Thu, 23 May 2019 19:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639260;
        bh=ZibPXFaGJH9Q/OXzJX75Njp7npJK1gDSTZBYygSwI2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qo/O6R98kDgDsWZ3CoJQBS46cHWjIiKjwBr194neBj6xF7I3KTN8iQkOkKvO7JMog
         Di7ZzBuFZprzlmfw3d28QEErVtZhFXG8ctZRyk/9XLs68nzHoNNqtJs07OqsCd8OTc
         3GsJTQjyPPxRNiipDNcBLghe47Qv5KbFcKFh5ct8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.0 021/139] regulator: core: fix error path for regulator_set_voltage_unlocked
Date:   Thu, 23 May 2019 21:05:09 +0200
Message-Id: <20190523181723.484279665@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Twiss <stwiss.opensource@diasemi.com>

commit 70b464918e5331e488058870fcc6821d54c4e541 upstream.

During several error paths in the function
regulator_set_voltage_unlocked() the value of 'ret' can take on negative
error values. However, in calls that go through the 'goto out' statement,
this return value is lost and return 0 is used instead, indicating a
'pass'.

There are several cases where this function should legitimately return a
fail instead of a pass: one such case includes constraints check during
voltage selection in the call to regulator_check_voltage(), which can
have -EINVAL for the case when an unsupported voltage is incorrectly
requested. In that case, -22 is expected as the return value, not 0.

Fixes: 9243a195be7a ("regulator: core: Change voltage setting path")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3360,15 +3360,12 @@ static int regulator_set_voltage_unlocke
 
 	/* for not coupled regulators this will just set the voltage */
 	ret = regulator_balance_voltage(rdev, state);
-	if (ret < 0)
-		goto out2;
+	if (ret < 0) {
+		voltage->min_uV = old_min_uV;
+		voltage->max_uV = old_max_uV;
+	}
 
 out:
-	return 0;
-out2:
-	voltage->min_uV = old_min_uV;
-	voltage->max_uV = old_max_uV;
-
 	return ret;
 }
 


