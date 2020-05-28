Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913251E5ED7
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 13:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388742AbgE1L43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 07:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388735AbgE1L41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:56:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E7FD214F1;
        Thu, 28 May 2020 11:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666987;
        bh=93U4NeV0j3o7YcuUCIuCRbRZcRPgqv//uz/oCsfli08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvjpE1QGtl7hKF86Eom+8YwiBPfRdHBvZ+y1xmvYni/pYYtrAwAjZB5e71NlOgQad
         +/+8nUH63MaNbshiMtji6wAbOL05HpfJf179YyhFC5I9tFOFov5pjeJTFNFMc6BFc7
         chVAupi5hUzqGgPMtQxFBmA1rtwlyJnQMNjyq5uc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 23/47] wireguard: selftests: use newer iproute2 for gcc-10
Date:   Thu, 28 May 2020 07:55:36 -0400
Message-Id: <20200528115600.1405808-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit ee3c1aa3f34b7842c1557cfe5d8c3f7b8c692de8 ]

gcc-10 switched to defaulting to -fno-common, which broke iproute2-5.4.
This was fixed in iproute-5.6, so switch to that. Because we're after a
stable testing surface, we generally don't like to bump these
unnecessarily, but in this case, being able to actually build is a basic
necessity.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/wireguard/qemu/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index 90598a425c18..4bdd6c1a19d3 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -44,7 +44,7 @@ endef
 $(eval $(call tar_download,MUSL,musl,1.2.0,.tar.gz,https://musl.libc.org/releases/,c6de7b191139142d3f9a7b5b702c9cae1b5ee6e7f57e582da9328629408fd4e8))
 $(eval $(call tar_download,IPERF,iperf,3.7,.tar.gz,https://downloads.es.net/pub/iperf/,d846040224317caf2f75c843d309a950a7db23f9b44b94688ccbe557d6d1710c))
 $(eval $(call tar_download,BASH,bash,5.0,.tar.gz,https://ftp.gnu.org/gnu/bash/,b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d))
-$(eval $(call tar_download,IPROUTE2,iproute2,5.4.0,.tar.xz,https://www.kernel.org/pub/linux/utils/net/iproute2/,fe97aa60a0d4c5ac830be18937e18dc3400ca713a33a89ad896ff1e3d46086ae))
+$(eval $(call tar_download,IPROUTE2,iproute2,5.6.0,.tar.xz,https://www.kernel.org/pub/linux/utils/net/iproute2/,1b5b0e25ce6e23da7526ea1da044e814ad85ba761b10dd29c2b027c056b04692))
 $(eval $(call tar_download,IPTABLES,iptables,1.8.4,.tar.bz2,https://www.netfilter.org/projects/iptables/files/,993a3a5490a544c2cbf2ef15cf7e7ed21af1845baf228318d5c36ef8827e157c))
 $(eval $(call tar_download,NMAP,nmap,7.80,.tar.bz2,https://nmap.org/dist/,fcfa5a0e42099e12e4bf7a68ebe6fde05553383a682e816a7ec9256ab4773faa))
 $(eval $(call tar_download,IPUTILS,iputils,s20190709,.tar.gz,https://github.com/iputils/iputils/archive/s20190709.tar.gz/#,a15720dd741d7538dd2645f9f516d193636ae4300ff7dbc8bfca757bf166490a))
-- 
2.25.1

