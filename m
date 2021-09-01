Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553BC3FDBFB
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345158AbhIAMqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343556AbhIAMmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BBA6611EE;
        Wed,  1 Sep 2021 12:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499871;
        bh=o2mwZyS42D/WF0zVjhjzspZpLk/qXdhkbJUgfqNz5Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQjOqKmY7eNhyfXpEqFRy4bcye0SKlvBO4HM9zAws/mjRgfZqSD/8suDcbGTsqwgF
         Gm32t+mTkFjG0PmZlMCEfb74TisRdsYLnFZXYseHXb7I+6q+JyQ2XCsgzhyn8lgvO4
         EXwMD34hE/mPOPAprjaXfqs2xVZ6VRqVQ+a2KykQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.13 016/113] dt-bindings: sifive-l2-cache: Fix select matching
Date:   Wed,  1 Sep 2021 14:27:31 +0200
Message-Id: <20210901122302.517181075@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

commit 1c8094e394bceb4f1880f9d539bdd255c130826e upstream.

When the schema fixups are applied to 'select' the result is a single
entry is required for a match, but that will never match as there should
be 2 entries. Also, a 'select' schema should have the widest possible
match, so use 'contains' which matches the compatible string(s) in any
position and not just the first position.

Fixes: 993dcfac64eb ("dt-bindings: riscv: sifive-l2-cache: convert bindings to json-schema")
Signed-off-by: Rob Herring <robh@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
+++ b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
@@ -24,10 +24,10 @@ allOf:
 select:
   properties:
     compatible:
-      items:
-        - enum:
-            - sifive,fu540-c000-ccache
-            - sifive,fu740-c000-ccache
+      contains:
+        enum:
+          - sifive,fu540-c000-ccache
+          - sifive,fu740-c000-ccache
 
   required:
     - compatible


