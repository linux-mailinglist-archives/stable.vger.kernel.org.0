Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C889134C8AB
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhC2IXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233961AbhC2IWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:22:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3048761580;
        Mon, 29 Mar 2021 08:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006150;
        bh=KC7cYA3GCnH1sNAc2tHBgiwFe0CGHB7A53pDDXKoVps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6xbfCMHn8Ph5Iu710bmfWUuy6WQ0ThinNN4VAMcqiwxsBTfXCOb/63uvhokT8W47
         KY3JwnQuCWMgvlldNQwKJi6SOXcabKRInDr4cgLO4WRnw//O2Herh8CcNvbaFkixHC
         59QbUQYurbijGh9514viuy2kymU8+ukxtcJXblrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos Llamas <cmllamas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/221] selftests/net: fix warnings on reuseaddr_ports_exhausted
Date:   Mon, 29 Mar 2021 09:57:46 +0200
Message-Id: <20210329075633.691517664@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit 81f711d67a973bf8a6db9556faf299b4074d536e ]

Fix multiple warnings seen with gcc 10.2.1:
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializer [-Wmissing-braces]
   32 | struct reuse_opts unreusable_opts[12] = {
      |                                         ^
   33 |  {0, 0, 0, 0},
      |   {   } {   }

Fixes: 7f204a7de8b0 ("selftests: net: Add SO_REUSEADDR test to check if 4-tuples are fully utilized.")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/reuseaddr_ports_exhausted.c | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/net/reuseaddr_ports_exhausted.c b/tools/testing/selftests/net/reuseaddr_ports_exhausted.c
index 7b01b7c2ec10..066efd30e294 100644
--- a/tools/testing/selftests/net/reuseaddr_ports_exhausted.c
+++ b/tools/testing/selftests/net/reuseaddr_ports_exhausted.c
@@ -30,25 +30,25 @@ struct reuse_opts {
 };
 
 struct reuse_opts unreusable_opts[12] = {
-	{0, 0, 0, 0},
-	{0, 0, 0, 1},
-	{0, 0, 1, 0},
-	{0, 0, 1, 1},
-	{0, 1, 0, 0},
-	{0, 1, 0, 1},
-	{0, 1, 1, 0},
-	{0, 1, 1, 1},
-	{1, 0, 0, 0},
-	{1, 0, 0, 1},
-	{1, 0, 1, 0},
-	{1, 0, 1, 1},
+	{{0, 0}, {0, 0}},
+	{{0, 0}, {0, 1}},
+	{{0, 0}, {1, 0}},
+	{{0, 0}, {1, 1}},
+	{{0, 1}, {0, 0}},
+	{{0, 1}, {0, 1}},
+	{{0, 1}, {1, 0}},
+	{{0, 1}, {1, 1}},
+	{{1, 0}, {0, 0}},
+	{{1, 0}, {0, 1}},
+	{{1, 0}, {1, 0}},
+	{{1, 0}, {1, 1}},
 };
 
 struct reuse_opts reusable_opts[4] = {
-	{1, 1, 0, 0},
-	{1, 1, 0, 1},
-	{1, 1, 1, 0},
-	{1, 1, 1, 1},
+	{{1, 1}, {0, 0}},
+	{{1, 1}, {0, 1}},
+	{{1, 1}, {1, 0}},
+	{{1, 1}, {1, 1}},
 };
 
 int bind_port(struct __test_metadata *_metadata, int reuseaddr, int reuseport)
-- 
2.30.1



