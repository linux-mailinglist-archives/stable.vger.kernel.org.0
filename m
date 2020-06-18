Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC82C1FE17C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbgFRByz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731528AbgFRBZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:25:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A175421974;
        Thu, 18 Jun 2020 01:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443552;
        bh=bIk6w6VvDx5GaB2S3OeclfhGrx+NuGFb52D0NAChQF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wc9k4r+EPEe2SHZeAvvwqVZokx1WnCJnfnyVyhm06Nxvl3LcJ6IQaMmHwXrC6Mm+R
         jg6wIxjkSHq1CJkR5MFZ0oGRt7UYcozk46OtL4+DWzWq9omvD2zaUUE9ADPGa5+Sou
         sxjl8IGL4FxaJB1A7pyf3XBnagjuhm8jgeEKI0as=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     tannerlove <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 167/172] selftests/net: in rxtimestamp getopt_long needs terminating null entry
Date:   Wed, 17 Jun 2020 21:22:13 -0400
Message-Id: <20200618012218.607130-167-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/networking/timestamping/rxtimestamp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/networking/timestamping/rxtimestamp.c b/tools/testing/selftests/networking/timestamping/rxtimestamp.c
index dd4162fc0419..7a573fb4c1c4 100644
--- a/tools/testing/selftests/networking/timestamping/rxtimestamp.c
+++ b/tools/testing/selftests/networking/timestamping/rxtimestamp.c
@@ -114,6 +114,7 @@ static struct option long_options[] = {
 	{ "tcp", no_argument, 0, 't' },
 	{ "udp", no_argument, 0, 'u' },
 	{ "ip", no_argument, 0, 'i' },
+	{ NULL, 0, NULL, 0 },
 };
 
 static int next_port = 19999;
-- 
2.25.1

