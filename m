Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3705218A51A
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 21:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgCRU7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728207AbgCRU46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A10CA2166E;
        Wed, 18 Mar 2020 20:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584565017;
        bh=X7SO+AFWtttTHvmpiHOIjqHujUY1avAOlL7VXiJYJl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/fnKMGPRcdR2tZN3S/29Bd3UX3pbPwmqoHYuYuMVBbQjtSLv10qi3Tcd0z2pSLM1
         mZxFjOQvu6v0cH20/69pKBzYbCrITY80PlfyoKbhJKEimcmaoz9Jds+WBpVsCkw+pI
         HIJUaDgFW+T4z7YA7AKewVHQEDSLqBlEzSTlnuok=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/12] dt-bindings: net: FMan erratum A050385
Date:   Wed, 18 Mar 2020 16:56:43 -0400
Message-Id: <20200318205648.17937-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205648.17937-1-sashal@kernel.org>
References: <20200318205648.17937-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

[ Upstream commit 26d5bb9e4c4b541c475751e015072eb2cbf70d15 ]

FMAN DMA read or writes under heavy traffic load may cause FMAN
internal resource leak; thus stopping further packet processing.

The FMAN internal queue can overflow when FMAN splits single
read or write transactions into multiple smaller transactions
such that more than 17 AXI transactions are in flight from FMAN
to interconnect. When the FMAN internal queue overflows, it can
stall further packet processing. The issue can occur with any one
of the following three conditions:

  1. FMAN AXI transaction crosses 4K address boundary (Errata
     A010022)
  2. FMAN DMA address for an AXI transaction is not 16 byte
     aligned, i.e. the last 4 bits of an address are non-zero
  3. Scatter Gather (SG) frames have more than one SG buffer in
     the SG list and any one of the buffers, except the last
     buffer in the SG list has data size that is not a multiple
     of 16 bytes, i.e., other than 16, 32, 48, 64, etc.

With any one of the above three conditions present, there is
likelihood of stalled FMAN packet processing, especially under
stress with multiple ports injecting line-rate traffic.

To avoid situations that stall FMAN packet processing, all of the
above three conditions must be avoided; therefore, configure the
system with the following rules:

  1. Frame buffers must not span a 4KB address boundary, unless
     the frame start address is 256 byte aligned
  2. All FMAN DMA start addresses (for example, BMAN buffer
     address, FD[address] + FD[offset]) are 16B aligned
  3. SG table and buffer addresses are 16B aligned and the size
     of SG buffers are multiple of 16 bytes, except for the last
     SG buffer that can be of any size.

Additional workaround notes:
- Address alignment of 64 bytes is recommended for maximally
efficient system bus transactions (although 16 byte alignment is
sufficient to avoid the stall condition)
- To support frame sizes that are larger than 4K bytes, there are
two options:
  1. Large single buffer frames that span a 4KB page boundary can
     be converted into SG frames to avoid transaction splits at
     the 4KB boundary,
  2. Align the large single buffer to 256B address boundaries,
     ensure that the frame address plus offset is 256B aligned.
- If software generated SG frames have buffers that are unaligned
and with random non-multiple of 16 byte lengths, before
transmitting such frames via FMAN, frames will need to be copied
into a new single buffer or multiple buffer SG frame that is
compliant with the three rules listed above.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/powerpc/fsl/fman.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/powerpc/fsl/fman.txt b/Documentation/devicetree/bindings/powerpc/fsl/fman.txt
index 1fc5328c0651b..23708f3f4e58a 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/fman.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/fman.txt
@@ -110,6 +110,13 @@ PROPERTIES
 		Usage: required
 		Definition: See soc/fsl/qman.txt and soc/fsl/bman.txt
 
+- fsl,erratum-a050385
+		Usage: optional
+		Value type: boolean
+		Definition: A boolean property. Indicates the presence of the
+		erratum A050385 which indicates that DMA transactions that are
+		split can result in a FMan lock.
+
 =============================================================================
 FMan MURAM Node
 
-- 
2.20.1

