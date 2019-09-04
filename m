Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A60A8E59
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732814AbfIDR5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387849AbfIDR51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:57:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 560E92339D;
        Wed,  4 Sep 2019 17:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619846;
        bh=uqRNqJi62a3YoLQc/RalojxQDLtQI6ctcSZ1ziYJuHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7QfU+WVKLz7W2RbYTrBZlWdtfhT1QafkarFzzsTH8fNU1ACbHpC1GmMGrMIZrv/9
         /k9sBNEQWlKcBuEtHYbmjAemyQ1CN+2zf9HtdQ/fUARHySd7skhvUKgIGr7sZV2XB5
         cjZA6/EEACXDnvQCHGctC5h01D3TsDrg0wKN4uAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adrian Vladu <avladu@cloudbasesolutions.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Alessandro Pilotti <apilotti@cloudbasesolutions.com>
Subject: [PATCH 4.4 54/77] tools: hv: fix KVP and VSS daemons exit code
Date:   Wed,  4 Sep 2019 19:53:41 +0200
Message-Id: <20190904175308.393391175@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



