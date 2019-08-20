Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D75960D2
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbfHTNnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730875AbfHTNnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:43:32 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C3A52087E;
        Tue, 20 Aug 2019 13:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308611;
        bh=+GpJ6hCkPxj3nzmJ3U386dLprsd+bv2NsXfze3k/pao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oY8jktVMQRPSJFoH0HNr+qv8zz2+nH56vbOJYZUzuL5MLUKq7yYCeiHh2+Y68Wagn
         mxx60y1EIIrNOGBpaXXvT+vqbU5cnB9I5s5btRirAze4h5V7Gv7CHBDqNugObToIQn
         YYdbV5hd5TWRD3H7ZgjyIA1IMnih1ZIYK9z3it5s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Vladu <avladu@cloudbasesolutions.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Alessandro Pilotti <apilotti@cloudbasesolutions.com>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/4] tools: hv: fix KVP and VSS daemons exit code
Date:   Tue, 20 Aug 2019 09:43:25 -0400
Message-Id: <20190820134325.11825-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134325.11825-1-sashal@kernel.org>
References: <20190820134325.11825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Vladu <avladu@cloudbasesolutions.com>

[ Upstream commit b0995156071b0ff29a5902964a9dc8cfad6f81c0 ]

HyperV KVP and VSS daemons should exit with 0 when the '--help'
or '-h' flags are used.

Signed-off-by: Adrian Vladu <avladu@cloudbasesolutions.com>

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Alessandro Pilotti <apilotti@cloudbasesolutions.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/hv_kvp_daemon.c | 2 ++
 tools/hv/hv_vss_daemon.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 1774800668168..fffc7c4184599 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1379,6 +1379,8 @@ int main(int argc, char *argv[])
 			daemonize = 0;
 			break;
 		case 'h':
+			print_usage(argv);
+			exit(0);
 		default:
 			print_usage(argv);
 			exit(EXIT_FAILURE);
diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 5d51d6ff08e6a..b5465f92ed50e 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -164,6 +164,8 @@ int main(int argc, char *argv[])
 			daemonize = 0;
 			break;
 		case 'h':
+			print_usage(argv);
+			exit(0);
 		default:
 			print_usage(argv);
 			exit(EXIT_FAILURE);
-- 
2.20.1

