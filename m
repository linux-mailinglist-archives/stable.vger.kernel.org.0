Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEC9499525
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392270AbiAXUu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390166AbiAXUpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16915C0617BC;
        Mon, 24 Jan 2022 11:54:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D217BB81229;
        Mon, 24 Jan 2022 19:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B12C340E5;
        Mon, 24 Jan 2022 19:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054059;
        bh=1yWpEKWsnxvzT9qXhc23Xqk5jPQ5wA/WL2CuYle5s9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSqtI6WQBOkbn7uqz0o5zwgtz9lmp/u1OU2/gzHgYRwNR2UOpN0b/xf2Q0bfFEAS3
         iihx8PtZzjgsCPWPiDmsfuJjBJuAtS/QD1RD/fdMKvzC1NjTHaQWhigoOBSAhUffTl
         ooxA6hMl2zF9VMPkuO9yimlpZUL0bBGPf3YJDShs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/563] dt-bindings: thermal: Fix definition of cooling-maps contribution property
Date:   Mon, 24 Jan 2022 19:40:13 +0100
Message-Id: <20220124184032.992904339@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 49bcb1506f2e095262c01bda7fd1c0db524c91e2 ]

When converting the thermal-zones bindings to yaml the definition of the
contribution property changed. The intention is the same, an integer
value expressing a ratio of a sum on how much cooling is provided by the
device to the zone. But after the conversion the integer value is
limited to the range 0 to 100 and expressed as a percentage.

This is problematic for two reasons.

- This do not match how the binding is used. Out of the 18 files that
  make use of the property only two (ste-dbx5x0.dtsi and
  ste-hrefv60plus.dtsi) sets it at a value that satisfy the binding,
  100. The remaining 16 files set the value higher and fail to validate.

- Expressing the value as a percentage instead of a ratio of the sum is
  confusing as there is nothing to enforce the sum in the zone is not
  greater then 100.

This patch restore the pre yaml conversion description and removes the
value limitation allowing the usage of the bindings to validate.

Fixes: 1202a442a31fd2e5 ("dt-bindings: thermal: Add yaml bindings for thermal zones")
Reported-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/20211109103045.1403686-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/thermal/thermal-zones.yaml       | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/thermal-zones.yaml b/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
index 164f71598c595..1b3954aa71c15 100644
--- a/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
+++ b/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
@@ -199,12 +199,11 @@ patternProperties:
 
               contribution:
                 $ref: /schemas/types.yaml#/definitions/uint32
-                minimum: 0
-                maximum: 100
                 description:
-                  The percentage contribution of the cooling devices at the
-                  specific trip temperature referenced in this map
-                  to this thermal zone
+                  The cooling contribution to the thermal zone of the referred
+                  cooling device at the referred trip point. The contribution is
+                  a ratio of the sum of all cooling contributions within a
+                  thermal zone.
 
             required:
               - trip
-- 
2.34.1



