Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A325026B572
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbgIOXob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgIOOd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99C6223C19;
        Tue, 15 Sep 2020 14:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179911;
        bh=EV1baJKNerMt/tzQ4G/KOBjXGRC1nK+tDGVmbMJlEG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbjSiWf7dn66pzYCJVjk35DiQcrTlFODU1MOScYfX+yCIrC0u7kElR3Jh5FZMCfMP
         KjrV/5E68dun/SHV5hwAT7gfeyvK9CcztlKNLGSBTwWCtK4G9PPrkU57cje+xHFy0C
         uuJEpmJOwkvyd5voC6mpzX8kpsVgMZPNGwjHi0Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 034/177] soundwire: fix double free of dangling pointer
Date:   Tue, 15 Sep 2020 16:11:45 +0200
Message-Id: <20200915140655.278498663@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 3fbbf2148a406b3e350fe91e6fdd78eb42ecad24 ]

clang static analysis flags this problem

stream.c:844:9: warning: Use of memory after
  it is freed
        kfree(bus->defer_msg.msg->buf);
              ^~~~~~~~~~~~~~~~~~~~~~~

This happens in an error handler cleaning up memory
allocated for elements in a list.

	list_for_each_entry(m_rt, &stream->master_list, stream_node) {
		bus = m_rt->bus;

		kfree(bus->defer_msg.msg->buf);
		kfree(bus->defer_msg.msg);
	}

And is triggered when the call to sdw_bank_switch() fails.
There are a two problems.

First, when sdw_bank_switch() fails, though it frees memory it
does not clear bus's reference 'defer_msg.msg' to that memory.

The second problem is the freeing msg->buf. In some cases
msg will be NULL so this will dereference a null pointer.
Need to check before freeing.

Fixes: 99b8a5d608a6 ("soundwire: Add bank switch routine")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200902202650.14189-1-trix@redhat.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/stream.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/stream.c b/drivers/soundwire/stream.c
index a9a72574b34ab..684761e86d4fc 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -716,6 +716,7 @@ error:
 	kfree(wbuf);
 error_1:
 	kfree(wr_msg);
+	bus->defer_msg.msg = NULL;
 	return ret;
 }
 
@@ -839,9 +840,10 @@ static int do_bank_switch(struct sdw_stream_runtime *stream)
 error:
 	list_for_each_entry(m_rt, &stream->master_list, stream_node) {
 		bus = m_rt->bus;
-
-		kfree(bus->defer_msg.msg->buf);
-		kfree(bus->defer_msg.msg);
+		if (bus->defer_msg.msg) {
+			kfree(bus->defer_msg.msg->buf);
+			kfree(bus->defer_msg.msg);
+		}
 	}
 
 msg_unlock:
-- 
2.25.1



