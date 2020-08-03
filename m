Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0A723A519
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgHCMdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgHCMdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:33:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5A2B204EC;
        Mon,  3 Aug 2020 12:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457998;
        bh=j4QwB29Ee9qxu9nA3B0US/rFh4yAG4wKdres+4bmP5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHVePIwjQXMV8Nf0MTM0ZtIqhocyVhuhUT9O7UxtO9t66zuUVBbWVrCt/41Bu10Uq
         o6A2IBQgIoj7w5712v9WsBrTDa+2RtmS0cBrzj5ZVGLtknc6mc6IdBNZttbYbMSuc/
         f6+iGsKXVLPiRII9yI6KcoXIfns2pQxON3t3oerI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/56] selftests/net: rxtimestamp: fix clang issues for target arch PowerPC
Date:   Mon,  3 Aug 2020 14:19:43 +0200
Message-Id: <20200803121851.709960504@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

[ Upstream commit 955cbe91bcf782c09afe369c95a20f0a4b6dcc3c ]

The signedness of char is implementation-dependent. Some systems
(including PowerPC and ARM) use unsigned char. Clang 9 threw:
warning: result of comparison of constant -1 with expression of type \
'char' is always true [-Wtautological-constant-out-of-range-compare]
                                  &arg_index)) != -1) {

Tested: make -C tools/testing/selftests TARGETS="net" run_tests

Fixes: 16e781224198 ("selftests/net: Add a test to validate behavior of rx timestamps")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/networking/timestamping/rxtimestamp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/networking/timestamping/rxtimestamp.c b/tools/testing/selftests/networking/timestamping/rxtimestamp.c
index 7a573fb4c1c4e..c6428f1ac22fb 100644
--- a/tools/testing/selftests/networking/timestamping/rxtimestamp.c
+++ b/tools/testing/selftests/networking/timestamping/rxtimestamp.c
@@ -328,8 +328,7 @@ int main(int argc, char **argv)
 	bool all_tests = true;
 	int arg_index = 0;
 	int failures = 0;
-	int s, t;
-	char opt;
+	int s, t, opt;
 
 	while ((opt = getopt_long(argc, argv, "", long_options,
 				  &arg_index)) != -1) {
-- 
2.25.1



