Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053BB499FB0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842026AbiAXXAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835938AbiAXWht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:37:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B25C0E9BB1;
        Mon, 24 Jan 2022 12:59:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D395AB80CCF;
        Mon, 24 Jan 2022 20:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2C5C340E5;
        Mon, 24 Jan 2022 20:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057996;
        bh=zsvG9gsyB/+katNNGqHNLCo0NLdIzDOFimUQUDWBBhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itgGcWSOPDe6suWulrWk+sM3/VmBo7IL2SOUVFB5XqMeBDHOHvJlTE7LH+ImyHNQm
         71Ytle8jrxNHlaHy0K9LUK3cV1v7yQ9j8H26YsyBtWidJfZXaUo3lwtLcNpZUXdwB9
         V6Tvfu7jPDTf6uoeS8fwPlZaLU+DF/qPmEc1gwIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0147/1039] fs: dlm: fix build with CONFIG_IPV6 disabled
Date:   Mon, 24 Jan 2022 19:32:16 +0100
Message-Id: <20220124184130.110761736@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 1b9beda83e27a0c2cd75d1cb743c297c7b36c844 ]

This patch will surround the AF_INET6 case in sk_error_report() of dlm
with a #if IS_ENABLED(CONFIG_IPV6). The field sk->sk_v6_daddr is not
defined when CONFIG_IPV6 is disabled. If CONFIG_IPV6 is disabled, the
socket creation with AF_INET6 should already fail because a runtime
check if AF_INET6 is registered. However if there is the possibility
that AF_INET6 is set as sk_family the sk_error_report() callback will
print then an invalid family type error.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 4c3d90570bcc ("fs: dlm: don't call kernel_getpeername() in error_report()")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 7b1c5f05a988b..7a8efce1c343e 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -612,6 +612,7 @@ static void lowcomms_error_report(struct sock *sk)
 				   ntohs(inet->inet_dport), sk->sk_err,
 				   sk->sk_err_soft);
 		break;
+#if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
 		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
 				   "sending to node %d at %pI6c, "
@@ -620,6 +621,7 @@ static void lowcomms_error_report(struct sock *sk)
 				   ntohs(inet->inet_dport), sk->sk_err,
 				   sk->sk_err_soft);
 		break;
+#endif
 	default:
 		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
 				   "invalid socket family %d set, "
-- 
2.34.1



