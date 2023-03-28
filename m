Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C978F6CC49F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbjC1PGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbjC1PGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:06:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D42EB57
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB7C7B81D8F
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE09C433D2;
        Tue, 28 Mar 2023 15:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015885;
        bh=ri310TNQZ0iwgcAG9yZjwZxQ1eVID1iW+e5DPdfxJB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Grso+CEboq/R9K3MEMJf4HSpDdM+4YTswatzHPneHKLWUfVCnUSjCsxv3j0soUPmh
         0NtnLjo5cRAOpX/JfdH+EruaG4C4NZgvnQclI3TCkxO6HUmHH76TbNybGpe6K5iaTk
         5buzj9DgHomey/qCSK4wyxUsN4AkefQDE/H46Bgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krishna chaitanya chundru <quic_krichai@quicinc.com>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 210/224] arm64: dts: qcom: sc7280: Mark PCIe controller as cache coherent
Date:   Tue, 28 Mar 2023 16:43:26 +0200
Message-Id: <20230328142626.097841314@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishna chaitanya chundru <quic_krichai@quicinc.com>

commit 8a63441e83724fee1ef3fd37b237d40d90780766 upstream.

If the controller is not marked as cache coherent, then kernel will
try to ensure coherency during dma-ops and that may cause data corruption.
So, mark the PCIe node as dma-coherent as the devices on PCIe bus are
cache coherent.

Cc: stable@vger.kernel.org
Fixes: 92e0ee9f83b3 ("arm64: dts: qcom: sc7280: Add PCIe and PHY related node")
Signed-off-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1677584952-17496-1-git-send-email-quic_krichai@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2077,6 +2077,8 @@
 			pinctrl-names = "default";
 			pinctrl-0 = <&pcie1_clkreq_n>;
 
+			dma-coherent;
+
 			iommus = <&apps_smmu 0x1c80 0x1>;
 
 			iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,


