Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD4D4727AE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbhLMKE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:04:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45932 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240115AbhLMJ7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:59:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 953D0B80E0B;
        Mon, 13 Dec 2021 09:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4642C34600;
        Mon, 13 Dec 2021 09:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389580;
        bh=EKvmEC6DFUYpWCBl1Vae3ZFfwaR41nGzQPj+1IJMSes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6Ee0q31NT/3cZGicxUkFK6cuv14aWh5pT2xPyR0urrwa5yaCj17jfK8nrhMyeSZB
         3dGJB6QzgBM7P1q0gWfn0iBhF8KgoJWyuLYlNswqmv5F63ENFGPJKAMjk4/1bbDcVp
         qV2YAquA7kmMY/C+y+RGXyUAmZKKWOz8bfYDpGvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh@kernel.org>
Subject: [PATCH 5.15 128/171] dt-bindings: net: Reintroduce PHY no lane swap binding
Date:   Mon, 13 Dec 2021 10:30:43 +0100
Message-Id: <20211213092949.351293227@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -91,6 +91,14 @@ properties:
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
     $ref: /schemas/types.yaml#/definitions/flag
     description:


