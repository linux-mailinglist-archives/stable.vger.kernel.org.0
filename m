Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBA0328A94
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239681AbhCASSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:18:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239492AbhCASNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:13:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22F7F652CA;
        Mon,  1 Mar 2021 17:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620213;
        bh=0hiLo64RakMj4WGjwhNGQEDJD5yHrDLvBuA9UrbDKiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIdZti8tqeJd2C4k9u0vE/MdicKUPSpEh9213YtBtY28+EPEOcVkvk/QFOl8JBKYM
         J2og6uZfyE7zgkrzt5MVHjXkbgVhCKAqbfzxSjVBuw+XPWPyaSYmuefOCDnGrM3T5W
         VYQdYpEngLyTAi9N3+/GARTdj48eVQ14hVUJpFaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 041/775] arm64: dts: qcom: msm8916-samsung-a5u: Fix iris compatible
Date:   Mon,  1 Mar 2021 17:03:29 +0100
Message-Id: <20210301161203.751552026@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 826e6faf49ae1eb065759a30832a2e34740bd8b1 ]

Unlike most MSM8916 boards, samsung-a5u uses WCN3660B instead of
WCN3620 to support the 5 GHz band additionally.

WCN3660B has similar requirements as WCN3620, but it needs the XO
clock to run at 48 MHz instead of 19.2 MHz. So far it was possible
to describe that configuration using the qcom,wcn3680 compatible.

However, as of commit 8490987bdb9a ("wcn36xx: Hook and identify RF_IRIS_WCN3680"),
the wcn36xx driver will now use the qcom,wcn3680 compatible
to enable functionality specific to WCN3680. In particular,
WCN3680 supports 802.11ac, which is not available in WCN3660B.

Use the new qcom,wcn3660b compatible to describe the chip properly.

Fixes: 0d7051999175 ("arm64: dts: msm8916-samsung-a5u: Override iris compatible")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20210106102134.59801-4-stephan@gerhold.net
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916-samsung-a5u-eur.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916-samsung-a5u-eur.dts b/arch/arm64/boot/dts/qcom/msm8916-samsung-a5u-eur.dts
index e39c04d977c25..dd35c3344358c 100644
--- a/arch/arm64/boot/dts/qcom/msm8916-samsung-a5u-eur.dts
+++ b/arch/arm64/boot/dts/qcom/msm8916-samsung-a5u-eur.dts
@@ -38,7 +38,7 @@
 
 &pronto {
 	iris {
-		compatible = "qcom,wcn3680";
+		compatible = "qcom,wcn3660b";
 	};
 };
 
-- 
2.27.0



