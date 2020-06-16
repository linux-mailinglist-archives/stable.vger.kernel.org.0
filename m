Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7451FBB22
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgFPPjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730967AbgFPPjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:39:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF05920B1F;
        Tue, 16 Jun 2020 15:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321980;
        bh=ZXs9ocW7Ed+eH9yAMQJE98d/MX0NoYJxO6UE9FsODYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2duqi/M1o/oeXAUdHkuCJxWQqETJyq5IwHm4cRT5LmzX1SDxj4o+Jo5SRARCZ+2Vs
         Gcz/c+aFFWX9FC6BnFTokx6IIbVYZi+gh7DOj+T+XG8rmtktEPRkhnQdHso8Rv57YY
         HhKkwUmgFItkt7hNEV5LPu1r30H+1htkwbHrBRK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 090/134] selftests/net: in rxtimestamp getopt_long needs terminating null entry
Date:   Tue, 16 Jun 2020 17:34:34 +0200
Message-Id: <20200616153105.093713585@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: tannerlove <tannerlove@google.com>

[ Upstream commit 865a6cbb2288f8af7f9dc3b153c61b7014fdcf1e ]

getopt_long requires the last element to be filled with zeros.
Otherwise, passing an unrecognized option can cause a segfault.

Fixes: 16e781224198 ("selftests/net: Add a test to validate behavior of rx timestamps")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/networking/timestamping/rxtimestamp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/networking/timestamping/rxtimestamp.c
+++ b/tools/testing/selftests/networking/timestamping/rxtimestamp.c
@@ -115,6 +115,7 @@ static struct option long_options[] = {
 	{ "tcp", no_argument, 0, 't' },
 	{ "udp", no_argument, 0, 'u' },
 	{ "ip", no_argument, 0, 'i' },
+	{ NULL, 0, NULL, 0 },
 };
 
 static int next_port = 19999;


