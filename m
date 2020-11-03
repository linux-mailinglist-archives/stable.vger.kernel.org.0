Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B782A57CD
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731251AbgKCUvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730359AbgKCUvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1E7F2071E;
        Tue,  3 Nov 2020 20:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436706;
        bh=AjAGEaHUEH4XbgEYgxDY+0UFlNgEmUmF+rvHxo8JIhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3bdVRvUmbe37UZXkrrPXQJ2y9BAXMlllzqxed5HtfeRL5LQr7yJagQtiBtIdoQo9
         T+iXtQdOh/bwV41zGyxlUFUddUhMHtGqeogZz9OhV5LpB6ySzkbFN4SWScVjS/VcKC
         iAlXb60BDYjKJjb0DlV/15kBp1ycrHP5ZiKVtg8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Jeremy Kerr <jk@ozlabs.org>
Subject: [PATCH 5.9 367/391] ARM: aspeed: g5: Do not set sirq polarity
Date:   Tue,  3 Nov 2020 21:36:58 +0100
Message-Id: <20201103203411.911534862@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

commit c82bf6e133d30e0f9172a20807814fa28aef0f67 upstream.

A feature was added to the aspeed vuart driver to configure the vuart
interrupt (sirq) polarity according to the LPC/eSPI strapping register.

Systems that depend on a active low behaviour (sirq_polarity set to 0)
such as OpenPower boxes also use LPC, so this relationship does not
hold. Jeremy confirms that the s2600st which is strapped for eSPI also
does not have this relationship.

The property was added for a Tyan S7106 system which is not supported
in the kernel tree. Should this or other systems wish to use this
feature of the driver they should add it to the machine specific device
tree.

Fixes: c791fc76bc72 ("arm: dts: aspeed: Add vuart aspeed,sirq-polarity-sense...")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Tested-by: Jeremy Kerr <jk@ozlabs.org>
Reviewed-by: Jeremy Kerr <jk@ozlabs.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200812112400.2406734-1-joel@jms.id.au
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/aspeed-g5.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/boot/dts/aspeed-g5.dtsi
+++ b/arch/arm/boot/dts/aspeed-g5.dtsi
@@ -425,7 +425,6 @@
 				interrupts = <8>;
 				clocks = <&syscon ASPEED_CLK_APB>;
 				no-loopback-test;
-				aspeed,sirq-polarity-sense = <&syscon 0x70 25>;
 				status = "disabled";
 			};
 


