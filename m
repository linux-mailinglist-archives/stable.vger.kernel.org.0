Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB72232E8D0
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhCEM3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:37558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhCEM2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:28:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C113C65029;
        Fri,  5 Mar 2021 12:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947317;
        bh=IxnJxRiT4HmKwHo+MU2Tp4cjV2vTzr0uWsF1wjVTaN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msETL+zi04mNa+yiAVIqFDNEIskrwY0/FEdQZitX5cBRWog0CTXj+7zH8siEHcuEy
         e0yAF+FwMnMLwq1sRczbsJOjxswgVePsVPOzhduqRSlZ8nZtpC+JU64dQOep6f+bz1
         pu1gwzUADWGNyxVhUm8teGz9cBnhuUedDLoFtOGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Zhibin Liu <zhibinliu@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 023/102] tcp: fix tcp_rmem documentation
Date:   Fri,  5 Mar 2021 13:20:42 +0100
Message-Id: <20210305120904.421879766@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 1d1be91254bbdd189796041561fd430f7553bb88 upstream.

tcp_rmem[1] has been changed to 131072, we should update the documentation
to reflect this.

Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Zhibin Liu <zhibinliu@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/ip-sysctl.rst |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -630,16 +630,15 @@ tcp_rmem - vector of 3 INTEGERs: min, de
 
 	default: initial size of receive buffer used by TCP sockets.
 	This value overrides net.core.rmem_default used by other protocols.
-	Default: 87380 bytes. This value results in window of 65535 with
-	default setting of tcp_adv_win_scale and tcp_app_win:0 and a bit
-	less for default tcp_app_win. See below about these variables.
+	Default: 131072 bytes.
+	This value results in initial window of 65535.
 
 	max: maximal size of receive buffer allowed for automatically
 	selected receiver buffers for TCP socket. This value does not override
 	net.core.rmem_max.  Calling setsockopt() with SO_RCVBUF disables
 	automatic tuning of that socket's receive buffer size, in which
 	case this value is ignored.
-	Default: between 87380B and 6MB, depending on RAM size.
+	Default: between 131072 and 6MB, depending on RAM size.
 
 tcp_sack - BOOLEAN
 	Enable select acknowledgments (SACKS).


