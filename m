Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF44247AEB3
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbhLTPCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240551AbhLTPAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:00:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169AFC08ED45;
        Mon, 20 Dec 2021 06:51:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9759611A8;
        Mon, 20 Dec 2021 14:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90797C36AE8;
        Mon, 20 Dec 2021 14:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011881;
        bh=y9apnoNAYexrCveOZLC7ncpaTfZgO5DErlWxWA8PDOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqIyoFUaYozgLAw6pM661ISvXycJqCOoUzO5gf6SknxNnkZn48YO0cu2fNBDvich5
         N2zocR0JT/Aly9owBF1DqQQKlqPLY7GbvJCT2ByvahhN3gsYyp1neWOlxotGECO2yA
         a6Mimv44OyE/YWlzdVUJWHyHkBdTBr0OUgaA7S3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.10 83/99] Input: touchscreen - avoid bitwise vs logical OR warning
Date:   Mon, 20 Dec 2021 15:34:56 +0100
Message-Id: <20211220143032.189471514@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit a02dcde595f7cbd240ccd64de96034ad91cffc40 upstream.

A new warning in clang points out a few places in this driver where a
bitwise OR is being used with boolean types:

drivers/input/touchscreen.c:81:17: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
        data_present = touchscreen_get_prop_u32(dev, "touchscreen-min-x",
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use of a bitwise OR is intentional, as bitwise operations do not
short circuit, which allows all the calls to touchscreen_get_prop_u32()
to happen so that the last parameter is initialized while coalescing the
results of the calls to make a decision after they are all evaluated.

To make this clearer to the compiler, use the '|=' operator to assign
the result of each touchscreen_get_prop_u32() call to data_present,
which keeps the meaning of the code the same but makes it obvious that
every one of these calls is expected to happen.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20211014205757.3474635-1-nathan@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/of_touchscreen.c |   42 ++++++++++++++---------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/drivers/input/touchscreen/of_touchscreen.c
+++ b/drivers/input/touchscreen/of_touchscreen.c
@@ -79,27 +79,27 @@ void touchscreen_parse_properties(struct
 
 	data_present = touchscreen_get_prop_u32(dev, "touchscreen-min-x",
 						input_abs_get_min(input, axis_x),
-						&minimum) |
-		       touchscreen_get_prop_u32(dev, "touchscreen-size-x",
-						input_abs_get_max(input,
-								  axis_x) + 1,
-						&maximum) |
-		       touchscreen_get_prop_u32(dev, "touchscreen-fuzz-x",
-						input_abs_get_fuzz(input, axis_x),
-						&fuzz);
+						&minimum);
+	data_present |= touchscreen_get_prop_u32(dev, "touchscreen-size-x",
+						 input_abs_get_max(input,
+								   axis_x) + 1,
+						 &maximum);
+	data_present |= touchscreen_get_prop_u32(dev, "touchscreen-fuzz-x",
+						 input_abs_get_fuzz(input, axis_x),
+						 &fuzz);
 	if (data_present)
 		touchscreen_set_params(input, axis_x, minimum, maximum - 1, fuzz);
 
 	data_present = touchscreen_get_prop_u32(dev, "touchscreen-min-y",
 						input_abs_get_min(input, axis_y),
-						&minimum) |
-		       touchscreen_get_prop_u32(dev, "touchscreen-size-y",
-						input_abs_get_max(input,
-								  axis_y) + 1,
-						&maximum) |
-		       touchscreen_get_prop_u32(dev, "touchscreen-fuzz-y",
-						input_abs_get_fuzz(input, axis_y),
-						&fuzz);
+						&minimum);
+	data_present |= touchscreen_get_prop_u32(dev, "touchscreen-size-y",
+						 input_abs_get_max(input,
+								   axis_y) + 1,
+						 &maximum);
+	data_present |= touchscreen_get_prop_u32(dev, "touchscreen-fuzz-y",
+						 input_abs_get_fuzz(input, axis_y),
+						 &fuzz);
 	if (data_present)
 		touchscreen_set_params(input, axis_y, minimum, maximum - 1, fuzz);
 
@@ -107,11 +107,11 @@ void touchscreen_parse_properties(struct
 	data_present = touchscreen_get_prop_u32(dev,
 						"touchscreen-max-pressure",
 						input_abs_get_max(input, axis),
-						&maximum) |
-		       touchscreen_get_prop_u32(dev,
-						"touchscreen-fuzz-pressure",
-						input_abs_get_fuzz(input, axis),
-						&fuzz);
+						&maximum);
+	data_present |= touchscreen_get_prop_u32(dev,
+						 "touchscreen-fuzz-pressure",
+						 input_abs_get_fuzz(input, axis),
+						 &fuzz);
 	if (data_present)
 		touchscreen_set_params(input, axis, 0, maximum, fuzz);
 


