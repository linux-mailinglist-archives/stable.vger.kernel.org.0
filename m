Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B315F29FE
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiJCH3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiJCH2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:28:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311B514000;
        Mon,  3 Oct 2022 00:19:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9604360FAF;
        Mon,  3 Oct 2022 07:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE27C433C1;
        Mon,  3 Oct 2022 07:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781494;
        bh=UJ1ZSCsoX9pendbzzQIvsRKKNW92EBDO2PZe5B4PXY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLRVpwsLErwgF7zWIn0Qvm7EBC3zSawAVjsKT03hRB0G7Vi/UHOoTN5Hg3GhLZifB
         909gG+11aaOZcfmr2Pf04tEpP9pbsufi3ogDYXP3dR7zVdDza00tS5+buAxF+fC+Il
         xE5zdhHp0h6UiRNJzoDx2qhSR7ofCnMZxiwEAxSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Romain Naour <romain.naour@skf.com>,
        Romain Naour <romain.naour@smile.fr>,
        Roger Quadros <rogerq@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/83] ARM: dts: am5748: keep usb4_tm disabled
Date:   Mon,  3 Oct 2022 09:11:06 +0200
Message-Id: <20221003070723.027993607@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Romain Naour <romain.naour@skf.com>

[ Upstream commit 6a6d9ecff14a2a46c1deeffa3eb3825349639bdd ]

Commit bcbb63b80284 ("ARM: dts: dra7: Separate AM57 dtsi files")
disabled usb4_tm for am5748 devices since USB4 IP is not present
in this SoC.

The commit log explained the difference between AM5 and DRA7 families:

AM5 and DRA7 SoC families have different set of modules in them so the
SoC sepecific dtsi files need to be separated.

e.g. Some of the major differences between AM576 and DRA76

		DRA76x	AM576x

USB3		x
USB4		x
ATL		x
VCP		x
MLB		x
ISS		x
PRU-ICSS1		x
PRU-ICSS2		x

Then commit 176f26bcd41a ("ARM: dts: Add support for dra762 abz
package") removed usb4_tm part from am5748.dtsi and introcuded new
ti-sysc errors in dmesg:

ti-sysc 48940000.target-module: clock get error for fck: -2
ti-sysc: probe of 48940000.target-module failed with error -2

Fixes: 176f26bcd41a ("ARM: dts: Add support for dra762 abz package")

Signed-off-by: Romain Naour <romain.naour@skf.com>
Signed-off-by: Romain Naour <romain.naour@smile.fr>
Message-Id: <20220823072742.351368-1-romain.naour@smile.fr>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am5748.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/am5748.dtsi b/arch/arm/boot/dts/am5748.dtsi
index c260aa1a85bd..a1f029e9d1f3 100644
--- a/arch/arm/boot/dts/am5748.dtsi
+++ b/arch/arm/boot/dts/am5748.dtsi
@@ -25,6 +25,10 @@
 	status = "disabled";
 };
 
+&usb4_tm {
+	status = "disabled";
+};
+
 &atl_tm {
 	status = "disabled";
 };
-- 
2.35.1



