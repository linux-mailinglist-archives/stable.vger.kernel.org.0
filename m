Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162BE511642
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 13:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbiD0LI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiD0LHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:07:55 -0400
X-Greylist: delayed 436 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Apr 2022 04:01:50 PDT
Received: from smtp104.ord1d.emailsrvr.com (smtp104.ord1d.emailsrvr.com [184.106.54.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01C411C3F
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 04:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1651056871;
        bh=ddNlq5a2SOtmxvXApNEVeoZ2XeV9vzsOaLURDCY5Qwo=;
        h=From:To:Subject:Date:From;
        b=CVZgAGVEPeKwnPqIFQt62LxJQyN9C2ner9d547kxW3nsR6xV3qHWa00lQXZh+WBqv
         0LFutu6QbOqzQLOO963fWypXGPPqreDgkgsPE4YCMbo1mQ3xcY1fXbAGTY9S15zhcv
         Ccv1jetlEEkauYkvCa9nJeZ1YEUoQ8/35tWWKHR8=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp6.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 96A9BE00E8;
        Wed, 27 Apr 2022 06:54:30 -0400 (EDT)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     stable@vger.kernel.org
Cc:     linux-spi@vger.kernel.org, devicetree@vger.kernel.org,
        Dinh Nguyen <dinguyen@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 5.15 0/2] ARM: socfpga: fix broken QuadSPI support
Date:   Wed, 27 Apr 2022 11:54:05 +0100
Message-Id: <20220427105407.40167-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 3bf3f977-eed8-458c-82a7-dc4c605c474d-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Write support on the Cadence QSPI controller on the Intel SoCFPGA
platform was broken by 9cb2ff111712 ("spi: cadence-quadspi: Disable
Auto-HW polling) and fixed by 98d948eb8331 ("spi: cadence-quadspi: fix
write completion support") and 36de991e9390 ("ARM: dts: socfpga: change
qspi to "intel,socfpga-qspi").

1) spi: cadence-quadspi: fix write completion support
2) ARM: dts: socfpga: change qspi to "intel,socfpga-qspi"

 arch/arm/boot/dts/socfpga.dtsi                    |  2 +-
 arch/arm/boot/dts/socfpga_arria10.dtsi            |  2 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi |  2 +-
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi     |  2 +-
 drivers/spi/spi-cadence-quadspi.c                 | 24 ++++++++++++++++++++---
 5 files changed, 25 insertions(+), 7 deletions(-)

