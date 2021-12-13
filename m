Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86F8472714
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhLMJ6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbhLMJyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:54:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF3EC08E89B;
        Mon, 13 Dec 2021 01:46:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B48EB80E1A;
        Mon, 13 Dec 2021 09:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC9CC00446;
        Mon, 13 Dec 2021 09:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388764;
        bh=3YPyKFDOHBmREIQWawdPZ7VlSSvyu1L9TysSd+k1PPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOGf5H36xA2IPZ6JrsUKNAYtfO/Ig3y+5H7L3lmIJil/AQ1k+qpDLK4IHggM7w9/Y
         b4YGmhr+HawvvK3/rNG9bMFPQNUPxxNy6ZrOYNa3lrIKmNAsw67v5ezkfC2fv3bKvI
         R7dvdGICHaMtG0sVuU2k6wzxjlF1TXqC8M3iAFDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 56/88] dt-bindings: net: Reintroduce PHY no lane swap binding
Date:   Mon, 13 Dec 2021 10:30:26 +0100
Message-Id: <20211213092935.198001789@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 96db48c9d777a73a33b1d516c5cfed7a417a5f40 upstream.

This binding was already documented in phy.txt, commit 252ae5330daa
("Documentation: devicetree: Add PHY no lane swap binding"), but got
accidently removed during YAML conversion in commit d8704342c109
("dt-bindings: net: Add a YAML schemas for the generic PHY options").

Note: 'enet-phy-lane-no-swap' and the absence of 'enet-phy-lane-swap' are
not identical, as the former one disable this feature, while the latter
one doesn't change anything.

Fixes: d8704342c109 ("dt-bindings: net: Add a YAML schemas for the generic PHY options")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20211130082756.713919-1-alexander.stein@ew.tq-group.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/ethernet-phy.yaml |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -87,6 +87,14 @@ properties:
       compensate for the board being designed with the lanes
       swapped.
 
+  enet-phy-lane-no-swap:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      If set, indicates that PHY will disable swap of the
+      TX/RX lanes. This property allows the PHY to work correcly after
+      e.g. wrong bootstrap configuration caused by issues in PCB
+      layout design.
+
   eee-broken-100tx:
     $ref: /schemas/types.yaml#definitions/flag
     description:


