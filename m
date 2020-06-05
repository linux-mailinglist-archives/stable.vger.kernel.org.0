Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E401EFB40
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgFEOZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgFEOQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC45208A9;
        Fri,  5 Jun 2020 14:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366612;
        bh=D0nourJT4cPZYNOqGjUCpq3oY9EB+0oI1CxFUfFKk4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJF2WVcfiTmKtDPViHs3880U5VW3SeV2JOcobI6aQcnNyRgv8u+ybuhbV7DnJyQD0
         kU4RbAVtfMkkUNbNN/HvoQd0xGSKXLwa5T3997bXa8YA+6Rf6C8CHJMoXQ7YPZ/Sx6
         5addNElEnsOrFqhup4vct242T4EtAp9UpMKDC5mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 23/43] wireguard: selftests: use newer iproute2 for gcc-10
Date:   Fri,  5 Jun 2020 16:14:53 +0200
Message-Id: <20200605140153.738574711@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

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



