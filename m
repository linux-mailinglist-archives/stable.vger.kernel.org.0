Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAADA15771C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbgBJM5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:57:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728168AbgBJMlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:24 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08AAB20873;
        Mon, 10 Feb 2020 12:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338484;
        bh=nKPESEBBVbq7QRV44lN6GvJzwPK+HexaFyj4+anZu6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofBA8MTo6S8kM9zCveCoyFLWIfY4JaJkMux8jLd4WOeUwhjNg2WzpFWsWEjnq3ff0
         Oo4ISw1YQWK382VW1CtAzwglHFRLbQtpBLYPub08tu0P0PSx2Y/fz5OhJ7MRluA8Qd
         yFniAua8XCrWbGjtWD+RS0CAlAajWu/lPVLNjsZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.5 263/367] arm64: dts: qcom: qcs404-evb: Set vdd_apc regulator in high power mode
Date:   Mon, 10 Feb 2020 04:32:56 -0800
Message-Id: <20200210122448.776944453@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@linaro.org>

commit eac8ce86cb90ba96cb4bcbf2549d7a8b6938aa30 upstream.

vdd_apc is the regulator that supplies the main CPU cluster.

At sudden CPU load changes, we have noticed invalid page faults on
addresses with all bits shifted, as well as on addresses with individual
bits flipped.

By putting the vdd_apc regulator in high power mode, the voltage drops
during sudden load changes will be less severe, and we have not been able
to reproduce the invalid page faults with the regulator in this mode.

Fixes: 8faea8edbb35 ("arm64: dts: qcom: qcs404-evb: add spmi regulators")
Cc: stable@vger.kernel.org
Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20191014120920.12691-1-niklas.cassel@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
@@ -73,6 +73,7 @@
 		regulator-always-on;
 		regulator-boot-on;
 		regulator-name = "vdd_apc";
+		regulator-initial-mode = <1>;
 		regulator-min-microvolt = <1048000>;
 		regulator-max-microvolt = <1384000>;
 	};


