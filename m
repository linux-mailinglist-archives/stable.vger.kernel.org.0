Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A1347AE1E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbhLTO6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:58:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46858 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237249AbhLTO4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0E23611C2;
        Mon, 20 Dec 2021 14:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FD1C36AE8;
        Mon, 20 Dec 2021 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012173;
        bh=m1jTfQmrPWmIqj+svdv2jI93fdEvGn9MDIWZEADIIps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJugzSxqc7LyzUoC2OwlBjzrCLlfy9FNRGEz7mgZkKqRo57iNS23+Z592BAUkVSXn
         nMCJB+JGpsm7bT5Ea7I5Gtr+yYQ73+bRX0RPdCO3avXGr7oc1GZAOLgqmAmpG2qcKF
         zxeCRA+MMXPll1yzPo0Ukif6EZrBpo2gbo54hHvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/177] selftests/net: toeplitz: fix udp option
Date:   Mon, 20 Dec 2021 15:33:44 +0100
Message-Id: <20211220143042.599780344@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit a8d13611b4a7b1b20d17bf2b9a89a3efcabde56c ]

Tiny fix. Option -u ("use udp") does not take an argument.

It can cause the next argument to silently be ignored.

Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/toeplitz.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
index 710ac956bdb33..c5489341cfb80 100644
--- a/tools/testing/selftests/net/toeplitz.c
+++ b/tools/testing/selftests/net/toeplitz.c
@@ -498,7 +498,7 @@ static void parse_opts(int argc, char **argv)
 	bool have_toeplitz = false;
 	int index, c;
 
-	while ((c = getopt_long(argc, argv, "46C:d:i:k:r:stT:u:v", long_options, &index)) != -1) {
+	while ((c = getopt_long(argc, argv, "46C:d:i:k:r:stT:uv", long_options, &index)) != -1) {
 		switch (c) {
 		case '4':
 			cfg_family = AF_INET;
-- 
2.33.0



