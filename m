Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9198E1FB81C
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732845AbgFPPxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732645AbgFPPxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:53:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C4E207C4;
        Tue, 16 Jun 2020 15:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322796;
        bh=ZXs9ocW7Ed+eH9yAMQJE98d/MX0NoYJxO6UE9FsODYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqUIqtsIzFHPuhzYUQgpbQ0Fb6Zj3p5KTJ1LqHEBunrJQ0rAsAVqcKnGP/+Xu9ZwR
         i/bV3HnRO14bCg2cV1pua992JECcZVzEMcSYp+E/bntjND5RkYk5z5LFJoFHXVw5+5
         aut8I9G3+GQg8VX09VROOl17znYjWggU0Du9Q8po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 108/161] selftests/net: in rxtimestamp getopt_long needs terminating null entry
Date:   Tue, 16 Jun 2020 17:34:58 +0200
Message-Id: <20200616153111.505557328@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
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


