Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B597D23A67F
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgHCMYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728069AbgHCMYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:24:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 866DA208C7;
        Mon,  3 Aug 2020 12:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457486;
        bh=XVcPbjpC+kqng3JA1yO0vWvYX9nhbo9hnchve8xK23I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZmMZyAlH5z8Yn5nXlR+hsoaLkslwF/tuN6vrtdit2D5RuUnBaXEBA+tMM47kXZhs
         /tDH5+trwrTKQprdeMBM1gJo85MYVxJb2z4e6kBEVMHevyLfDwZG1kFTc4yoUzvF2q
         Lq897ZiuQ7Ml8WE0xog/KeXjkgi9Qc0C5s6llpZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 085/120] selftests/bpf: fix netdevsim trap_flow_action_cookie read
Date:   Mon,  3 Aug 2020 14:19:03 +0200
Message-Id: <20200803121907.011881451@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4bbca662df2523ff7ad3224463f1f28e6a118044 ]

When read netdevsim trap_flow_action_cookie, we need to init it first,
or we will get "Invalid argument" error.

Fixes: d3cbb907ae57 ("netdevsim: add ACL trap reporting cookie as a metadata")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_offload.py | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index 8294ae3ffb3cb..43c9cda199b82 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -318,6 +318,9 @@ class DebugfsDir:
                 continue
 
             if os.path.isfile(p):
+                # We need to init trap_flow_action_cookie before read it
+                if f == "trap_flow_action_cookie":
+                    cmd('echo deadbeef > %s/%s' % (path, f))
                 _, out = cmd('cat %s/%s' % (path, f))
                 dfs[f] = out.strip()
             elif os.path.isdir(p):
-- 
2.25.1



