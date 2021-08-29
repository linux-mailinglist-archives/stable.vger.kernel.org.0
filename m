Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A623FA989
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 08:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhH2Gtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 02:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhH2Gto (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 02:49:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEE9960F36;
        Sun, 29 Aug 2021 06:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630219732;
        bh=PO0JqlHDkqEeoogpqhhMcRS2aOsAaF/FaO1zFcSsjCk=;
        h=Subject:To:Cc:From:Date:From;
        b=rsPCojdx+6EgG/aeXkAKzbbymAQ078MPUYbeuqy/rI69Raqlq5/mqBEXU4f5L2qgj
         RiB9jJVFBaa9vIcvStvJmnBIp0q0IA0mc2wEC0idJzh5MinF0hY1rRM0Be+HWnnxhq
         i7rhE3PMgyyKVDZJxTG3DL2E23uR2KMwADsPyE8o=
Subject: FAILED: patch "[PATCH] dt-bindings: sifive-l2-cache: Fix 'select' matching" failed to apply to 5.10-stable tree
To:     robh@kernel.org, palmerdabbelt@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Aug 2021 08:48:43 +0200
Message-ID: <163021972318468@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1c8094e394bceb4f1880f9d539bdd255c130826e Mon Sep 17 00:00:00 2001
From: Rob Herring <robh@kernel.org>
Date: Tue, 17 Aug 2021 12:47:55 -0500
Subject: [PATCH] dt-bindings: sifive-l2-cache: Fix 'select' matching

When the schema fixups are applied to 'select' the result is a single
entry is required for a match, but that will never match as there should
be 2 entries. Also, a 'select' schema should have the widest possible
match, so use 'contains' which matches the compatible string(s) in any
position and not just the first position.

Fixes: 993dcfac64eb ("dt-bindings: riscv: sifive-l2-cache: convert bindings to json-schema")
Signed-off-by: Rob Herring <robh@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

diff --git a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
index 1d38ff76d18f..2b1f91603897 100644
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

