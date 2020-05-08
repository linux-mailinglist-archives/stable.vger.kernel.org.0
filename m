Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAD61CAEFA
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgEHNNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729652AbgEHMsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD0F721473;
        Fri,  8 May 2020 12:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942096;
        bh=ZyHE1W+JZxQ0Y1vRKWpYFiUEuY+PkXT/CYY1jZimems=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4iXUb90Gq26Ny2+krgr8UBhcpzXGmGaFkQF4uwowj48CmFIV3DE8o0wkS77xH3fp
         Td1WZeYWt99bNWtgFWWaqEQfMrJIhyMfI6YTlnv6pT1e5yQDR8lsOF22aV9D+hS9Ph
         SfjXfMmnVzzhzHTwm19F/eNSGYmr2mzOYWcuRXFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 295/312] regulator: core: Rely on regulator_dev_release to free constraints
Date:   Fri,  8 May 2020 14:34:46 +0200
Message-Id: <20200508123145.117282276@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 6333ef46bbe514a8ece6c432aab6bcf8637b2d7c upstream.

As we now free the constraints in regulator_dev_release we will still
call free on the constraints pointer even if we went down an error
path in regulator_register, because it is only allocated after the
device_register. As such we no longer need to free rdev->constraints
on the error paths, so this patch removes said frees.

Fixes: 29f5f4860a8e ("regulator: core: Move more deallocation into class unregister")
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1057,18 +1057,18 @@ static int set_machine_constraints(struc
 
 	ret = machine_constraints_voltage(rdev, rdev->constraints);
 	if (ret != 0)
-		goto out;
+		return ret;
 
 	ret = machine_constraints_current(rdev, rdev->constraints);
 	if (ret != 0)
-		goto out;
+		return ret;
 
 	if (rdev->constraints->ilim_uA && ops->set_input_current_limit) {
 		ret = ops->set_input_current_limit(rdev,
 						   rdev->constraints->ilim_uA);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to set input limit\n");
-			goto out;
+			return ret;
 		}
 	}
 
@@ -1077,21 +1077,20 @@ static int set_machine_constraints(struc
 		ret = suspend_prepare(rdev, rdev->constraints->initial_state);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to set suspend state\n");
-			goto out;
+			return ret;
 		}
 	}
 
 	if (rdev->constraints->initial_mode) {
 		if (!ops->set_mode) {
 			rdev_err(rdev, "no set_mode operation\n");
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
 		ret = ops->set_mode(rdev, rdev->constraints->initial_mode);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to set initial mode: %d\n", ret);
-			goto out;
+			return ret;
 		}
 	}
 
@@ -1102,7 +1101,7 @@ static int set_machine_constraints(struc
 		ret = _regulator_do_enable(rdev);
 		if (ret < 0 && ret != -EINVAL) {
 			rdev_err(rdev, "failed to enable\n");
-			goto out;
+			return ret;
 		}
 	}
 
@@ -1111,7 +1110,7 @@ static int set_machine_constraints(struc
 		ret = ops->set_ramp_delay(rdev, rdev->constraints->ramp_delay);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to set ramp_delay\n");
-			goto out;
+			return ret;
 		}
 	}
 
@@ -1119,7 +1118,7 @@ static int set_machine_constraints(struc
 		ret = ops->set_pull_down(rdev);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to set pull down\n");
-			goto out;
+			return ret;
 		}
 	}
 
@@ -1127,7 +1126,7 @@ static int set_machine_constraints(struc
 		ret = ops->set_soft_start(rdev);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to set soft start\n");
-			goto out;
+			return ret;
 		}
 	}
 
@@ -1136,16 +1135,12 @@ static int set_machine_constraints(struc
 		ret = ops->set_over_current_protection(rdev);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to set over current protection\n");
-			goto out;
+			return ret;
 		}
 	}
 
 	print_constraints(rdev);
 	return 0;
-out:
-	kfree(rdev->constraints);
-	rdev->constraints = NULL;
-	return ret;
 }
 
 /**
@@ -3983,7 +3978,7 @@ unset_supplies:
 
 scrub:
 	regulator_ena_gpio_free(rdev);
-	kfree(rdev->constraints);
+
 wash:
 	device_unregister(&rdev->dev);
 	/* device core frees rdev */


