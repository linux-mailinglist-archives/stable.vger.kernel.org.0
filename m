Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B381947ABC2
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhLTOi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:38:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47370 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbhLTOiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:38:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AA5CB80EE2;
        Mon, 20 Dec 2021 14:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FE1C36AE8;
        Mon, 20 Dec 2021 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011098;
        bh=+2CORKnuWusfOSE29PywiLyWAt+P1S1QVvMxS69/RRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrVJoU2rjq3uVXL3YP14W1cNr7+Li0ur3CSit4ZOxKOjKdNH//Ww94FPw8jSkjF87
         hmjUiGI4CYKIWLV479l11i4ZZ0+hn/wnkMFjc7tHxEAn4+qHswZLE2pSkLWVQcWmzi
         MwVZLd3/M7TyZeNVBexmdLwpGDqtcmM/ynC66988=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 4.9 26/31] Input: touchscreen - avoid bitwise vs logical OR warning
Date:   Mon, 20 Dec 2021 15:34:26 +0100
Message-Id: <20211220143020.811786269@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
References: <20211220143019.974513085@linuxfoundation.org>
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
 drivers/input/touchscreen/of_touchscreen.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/input/touchscreen/of_touchscreen.c
+++ b/drivers/input/touchscreen/of_touchscreen.c
@@ -79,8 +79,8 @@ void touchscreen_parse_properties(struct
 	data_present = touchscreen_get_prop_u32(dev, "touchscreen-size-x",
 						input_abs_get_max(input,
 								  axis) + 1,
-						&maximum) |
-		       touchscreen_get_prop_u32(dev, "touchscreen-fuzz-x",
+						&maximum);
+	data_present |= touchscreen_get_prop_u32(dev, "touchscreen-fuzz-x",
 						input_abs_get_fuzz(input, axis),
 						&fuzz);
 	if (data_present)
@@ -90,8 +90,8 @@ void touchscreen_parse_properties(struct
 	data_present = touchscreen_get_prop_u32(dev, "touchscreen-size-y",
 						input_abs_get_max(input,
 								  axis) + 1,
-						&maximum) |
-		       touchscreen_get_prop_u32(dev, "touchscreen-fuzz-y",
+						&maximum);
+	data_present |= touchscreen_get_prop_u32(dev, "touchscreen-fuzz-y",
 						input_abs_get_fuzz(input, axis),
 						&fuzz);
 	if (data_present)
@@ -101,11 +101,11 @@ void touchscreen_parse_properties(struct
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
 		touchscreen_set_params(input, axis, maximum, fuzz);
 


