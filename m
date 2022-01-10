Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6145E489136
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239941AbiAJHaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:30:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36182 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240012AbiAJH2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:28:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D05A0611AA;
        Mon, 10 Jan 2022 07:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E91C36AED;
        Mon, 10 Jan 2022 07:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799687;
        bh=iiwAMT1Wz0s8M/2Kfjrbib1DKw7Qzm0d8p/EiP5o7YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tca9mFyEOR+X9pbf6kHQela3sw4fa3hGbjUrVFwxhOpIsznJ9tvVwKQVmk7yQlPDq
         /pzlIZh42Dr5iygAoyBtLGHleOi7ZKCGQA5oAtOj0eH0WPRzdZe6MP5EUO8uX14SdN
         6MC36Ix3yELsyqd+sR2i0wF+LBdB4TCopNNj3rYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 02/34] Input: touchscreen - Fix backport of a02dcde595f7cbd240ccd64de96034ad91cffc40
Date:   Mon, 10 Jan 2022 08:22:57 +0100
Message-Id: <20220110071815.735904662@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

Upstream commit a02dcde595f7 ("Input: touchscreen - avoid bitwise vs
logical OR warning") was applied as commit f6e9e7be9b80 ("Input:
touchscreen - avoid bitwise vs logical OR warning") in linux-5.4.y but
it did not properly account for commit d9265e8a878a ("Input:
of_touchscreen - add support for touchscreen-min-x|y"), which means the
warning mentioned in the commit message is not fully fixed:

drivers/input/touchscreen/of_touchscreen.c:78:17: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
        data_present = touchscreen_get_prop_u32(dev, "touchscreen-min-x",
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/input/touchscreen/of_touchscreen.c:78:17: note: cast one or both operands to int to silence this warning
drivers/input/touchscreen/of_touchscreen.c:92:17: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
        data_present = touchscreen_get_prop_u32(dev, "touchscreen-min-y",
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/input/touchscreen/of_touchscreen.c:92:17: note: cast one or both operands to int to silence this warning
2 warnings generated.

It seems like the 4.19 backport was applied to the 5.4 tree, which did
not have any conflicts so no issue was noticed at that point.

Fix up the backport to bring it more in line with the upstream version
so that there is no warning.

Fixes: f6e9e7be9b80 ("Input: touchscreen - avoid bitwise vs logical OR warning")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/of_touchscreen.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/input/touchscreen/of_touchscreen.c
+++ b/drivers/input/touchscreen/of_touchscreen.c
@@ -77,8 +77,8 @@ void touchscreen_parse_properties(struct
 	axis = multitouch ? ABS_MT_POSITION_X : ABS_X;
 	data_present = touchscreen_get_prop_u32(dev, "touchscreen-min-x",
 						input_abs_get_min(input, axis),
-						&minimum) |
-		       touchscreen_get_prop_u32(dev, "touchscreen-size-x",
+						&minimum);
+	data_present |= touchscreen_get_prop_u32(dev, "touchscreen-size-x",
 						input_abs_get_max(input,
 								  axis) + 1,
 						&maximum);
@@ -91,8 +91,8 @@ void touchscreen_parse_properties(struct
 	axis = multitouch ? ABS_MT_POSITION_Y : ABS_Y;
 	data_present = touchscreen_get_prop_u32(dev, "touchscreen-min-y",
 						input_abs_get_min(input, axis),
-						&minimum) |
-		       touchscreen_get_prop_u32(dev, "touchscreen-size-y",
+						&minimum);
+	data_present |= touchscreen_get_prop_u32(dev, "touchscreen-size-y",
 						input_abs_get_max(input,
 								  axis) + 1,
 						&maximum);


