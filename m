Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59F8226711
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733305AbgGTQIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733303AbgGTQIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:08:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E98A322CBE;
        Mon, 20 Jul 2020 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261309;
        bh=wyhtxrRVjoNaSMSi3svCzuj5nQN4rviZjNep9R9HDHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VN7Ur6RJMyEC2cFXP59NinnkvxXofWoH9R10V+ZbWGGOlVOAZF7aLtF3dS75XXWcZ
         f3oIbpyG9rmJO/xmDo0zfe6DrXv6qB5zTFIXqbODPp6llgIYogYYAqrQkU4AowKWHs
         Iq4VwtljbcFC0rYfg9qej9LkSRCYY4ELD9MZrtpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 042/244] dt-bindings: bus: uniphier-system-bus: fix warning in example
Date:   Mon, 20 Jul 2020 17:35:13 +0200
Message-Id: <20200720152827.855042349@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit 0fb24d1e5a6cf3b7ca0df325fbfb10895df41bec ]

Since commit e69f5dc623f9 ("dt-bindings: serial: Convert 8250 to
json-schema"), the schema for "ns16550a" is checked.

'make dt_binding_check' emits the following warning:

  uart@5,00200000: $nodename:0: 'uart@5,00200000' does not match '^serial(@[0-9a-f,]+)*$'

Rename the node to follow the pattern defined in
Documentation/devicetree/bindings/serial/serial.yaml

While I was here, I removed leading zeros from unit names.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Link: https://lore.kernel.org/r/20200623113242.779241-1-yamada.masahiro@socionext.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/bus/socionext,uniphier-system-bus.yaml           | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/bus/socionext,uniphier-system-bus.yaml b/Documentation/devicetree/bindings/bus/socionext,uniphier-system-bus.yaml
index c4c9119e4a206..a0c6c5d2b70fb 100644
--- a/Documentation/devicetree/bindings/bus/socionext,uniphier-system-bus.yaml
+++ b/Documentation/devicetree/bindings/bus/socionext,uniphier-system-bus.yaml
@@ -80,14 +80,14 @@ examples:
         ranges = <1 0x00000000 0x42000000 0x02000000>,
                  <5 0x00000000 0x46000000 0x01000000>;
 
-        ethernet@1,01f00000 {
+        ethernet@1,1f00000 {
             compatible = "smsc,lan9115";
             reg = <1 0x01f00000 0x1000>;
             interrupts = <0 48 4>;
             phy-mode = "mii";
         };
 
-        uart@5,00200000 {
+        serial@5,200000 {
             compatible = "ns16550a";
             reg = <5 0x00200000 0x20>;
             interrupts = <0 49 4>;
-- 
2.25.1



