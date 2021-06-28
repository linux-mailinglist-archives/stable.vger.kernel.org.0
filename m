Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C183B629D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhF1Ost (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235728AbhF1Opg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F24461C85;
        Mon, 28 Jun 2021 14:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890854;
        bh=ZTZM0dvHLlG6y9uA42XvKMxsAgeBWrNoU8mAfDrO400=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vh0br1LEZTlQ4v8wJ+Bb10C++vaSJBqHQzawb72+K1uhvLKzx7wWWaMhwoHAHyXDr
         +uHndhT0h77QiG68jVKi2/eGyRP/ycz3TB0En/QnovLqRbQBVcMdf3HvFKWelGUkwe
         qxRlf2zj5QY1QYpqnQMzNV2UESKTm3NGNiFJobZteFnQm8YgtRMr3l4ONq53pdsBqw
         82w5YBHtwMyroy/L4bqsaffDtG5jw9c2P/H8g8s3/GTakK5Wi/itcnkeDPAeDT76zr
         N9wqgFMZvflYK7Ovi4oCIE5ocdAAXwguvIIbTrUPvfj4do1MgPW0cUMUNtnmptDjY2
         cqp+eRwndJeDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 076/109] tools headers UAPI: Sync linux/in.h copy with the kernel sources
Date:   Mon, 28 Jun 2021 10:32:32 -0400
Message-Id: <20210628143305.32978-77-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 1792a59eab9593de2eae36c40c5a22d70f52c026 upstream.

To pick the changes in:

  321827477360934d ("icmp: don't send out ICMP messages with a source address of 0.0.0.0")

That don't result in any change in tooling, as INADDR_ are not used to
generate id->string tables used by 'perf trace'.

This addresses this build warning:

  Warning: Kernel ABI header at 'tools/include/uapi/linux/in.h' differs from latest version at 'include/uapi/linux/in.h'
  diff -u tools/include/uapi/linux/in.h include/uapi/linux/in.h

Cc: David S. Miller <davem@davemloft.net>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/uapi/linux/in.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/include/uapi/linux/in.h b/tools/include/uapi/linux/in.h
index 48e8a225b985..2a66ab49f14d 100644
--- a/tools/include/uapi/linux/in.h
+++ b/tools/include/uapi/linux/in.h
@@ -280,6 +280,9 @@ struct sockaddr_in {
 /* Address indicating an error return. */
 #define	INADDR_NONE		((unsigned long int) 0xffffffff)
 
+/* Dummy address for src of ICMP replies if no real address is set (RFC7600). */
+#define	INADDR_DUMMY		((unsigned long int) 0xc0000008)
+
 /* Network number for local host loopback. */
 #define	IN_LOOPBACKNET		127
 
-- 
2.30.2

