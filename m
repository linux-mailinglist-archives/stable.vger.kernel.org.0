Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1FF128897
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391143AbfEWT1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:27:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390913AbfEWT1X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:27:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8135320879;
        Thu, 23 May 2019 19:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639643;
        bh=Nm15f3YcNOtVfrW1oNjZ7xyyUdfKI/PQDQcqZCXPm/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcvCqjSmLnL0fF0LE2MEhwX5+UWUhvm1nkXGORjbDMJIz1oJAnFPWSB2/9KXgH785
         W8n5ddQ1cLXQspdpgrWStlrr7CQaGBxV9hjRcS2Xop+R4rnDbDh3N+IcZq9xfg+6Qk
         0nh3rJ4V2GT+DFzBeFtN98403Kh2lkUV0darpAks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.1 025/122] regulator: core: fix error path for regulator_set_voltage_unlocked
Date:   Thu, 23 May 2019 21:05:47 +0200
Message-Id: <20190523181708.070633377@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
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
@@ -3322,15 +3322,12 @@ static int regulator_set_voltage_unlocke
 
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
 


