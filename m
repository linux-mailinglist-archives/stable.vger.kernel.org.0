Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEA03FDB57
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345221AbhIAMkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245748AbhIAMiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:38:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0C2E610E5;
        Wed,  1 Sep 2021 12:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499700;
        bh=H6B1/1anDben9r72Mw4Uvx5sfAisxESMV/l5TUKvy+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nusIV7IKakvNA1G4Eh44rV+b57TyX2ke4P+vlWyjXkUKQMPsgAGbWyNj0uCU/seaz
         +JomofRAIqcIW4lMlgeaSCIbBiAMDCPNbrsA89IP/YUQcMaljHkxmb+R6cpivgoCNu
         4j35pdZom/ox0tw/koYTwzBlXYNSlkmwGjyu2XeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/103] dt-bindings: sifive-l2-cache: Fix select matching
Date:   Wed,  1 Sep 2021 14:28:01 +0200
Message-Id: <20210901122302.286571745@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 1c8094e394bceb4f1880f9d539bdd255c130826e ]

When the schema fixups are applied to 'select' the result is a single
entry is required for a match, but that will never match as there should
be 2 entries. Also, a 'select' schema should have the widest possible
match, so use 'contains' which matches the compatible string(s) in any
position and not just the first position.

Fixes: 993dcfac64eb ("dt-bindings: riscv: sifive-l2-cache: convert bindings to json-schema")
Signed-off-by: Rob Herring <robh@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/riscv/sifive-l2-cache.yaml          | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
index efc0198eeb74..5444be7667b6 100644
--- a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
+++ b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
@@ -24,9 +24,9 @@ allOf:
 select:
   properties:
     compatible:
-      items:
-        - enum:
-            - sifive,fu540-c000-ccache
+      contains:
+        enum:
+          - sifive,fu540-c000-ccache
 
   required:
     - compatible
-- 
2.30.2



