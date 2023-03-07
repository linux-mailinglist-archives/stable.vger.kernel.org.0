Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A4F6AD61F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 05:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCGERY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 23:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjCGERP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 23:17:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF10557D08;
        Mon,  6 Mar 2023 20:17:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 848E9611E0;
        Tue,  7 Mar 2023 04:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF087C4339B;
        Tue,  7 Mar 2023 04:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678162633;
        bh=RicJ3qXIV9Fl4AR02iRR+L+juREsdw4zlXJgemMP7OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AN3YQNRKvoLZCpCmg3JTExSU9Hf90sHSWbFmkMrgeI83vZ28gCAg8WLSbNuEKzBit
         pRv/XUowGHbnr1JUDw8M7IpYZ6kTvEWqFGTOay6Bvac2m3E0C2UYCQzhjnSHPa0543
         TToNFQgnFFgo7oDFxazQC4WAMppaQtQmtgSqU5DPymyQV9hlVlAhlHdb8ZdIzg37Pu
         H+vUbL7+FhI7HcdBL+KGD9zKteZGubbeZL2kwRDNMGn4h93up4ru34NvmM+kxG00Ji
         g/BmY8mHnYW07klJcTeKfRA9ci9gwzxNzN+jzQPzgIuN1BEee5G5Hxkx6X7Il0WN5s
         sNZLHNxINftQg==
From:   Bjorn Andersson <andersson@kernel.org>
To:     helgaas@kernel.org,
        Krishna chaitanya chundru <quic_krichai@quicinc.com>
Cc:     kishon@ti.com, stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-kernel@vger.kernel.org, quic_nitegupt@quicinc.com,
        linux-clk@vger.kernel.org, linux-pci@vger.kernel.org,
        Prasad Malisetty <pmaliset@codeaurora.org>,
        mturquette@baylibre.com, svarbanov@mm-sol.com,
        dmitry.baryshkov@linaro.org, quic_vbadigan@quicinc.com,
        vkoul@kernel.org, manivannan.sadhasivam@linaro.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, quic_skananth@quicinc.com,
        kw@linux.com, robh@kernel.org, bhelgaas@google.com,
        linux-arm-msm@vger.kernel.org, mka@chromium.org,
        quic_ramkri@quicinc.com, konrad.dybcio@somainline.org,
        swboyd@chromium.org, Rob Herring <robh+dt@kernel.org>,
        quic_hemantk@quicinc.com,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        agross@kernel.org, lpieralisi@kernel.org,
        linux-phy@lists.infradead.org
Subject: Re: [PATCH V2] arm64: dts: qcom: sc7280: Mark PCIe controller as cache coherent
Date:   Mon,  6 Mar 2023 20:20:35 -0800
Message-Id: <167816282865.1458033.5335158204914566504.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1677584952-17496-1-git-send-email-quic_krichai@quicinc.com>
References: <1677584952-17496-1-git-send-email-quic_krichai@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Feb 2023 17:19:12 +0530, Krishna chaitanya chundru wrote:
> If the controller is not marked as cache coherent, then kernel will
> try to ensure coherency during dma-ops and that may cause data corruption.
> So, mark the PCIe node as dma-coherent as the devices on PCIe bus are
> cache coherent.
> 
> 

Applied, thanks!

[1/1] arm64: dts: qcom: sc7280: Mark PCIe controller as cache coherent
      commit: 8a63441e83724fee1ef3fd37b237d40d90780766

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
