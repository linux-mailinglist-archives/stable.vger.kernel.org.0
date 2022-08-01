Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A874D5869B5
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiHAMGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbiHAMFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:05:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C59D5927E;
        Mon,  1 Aug 2022 04:54:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DCE261227;
        Mon,  1 Aug 2022 11:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD477C433D6;
        Mon,  1 Aug 2022 11:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354883;
        bh=eQkHLvuFiQC4fCGZQxZG6VEon3kkOfjQUOYlGs5oa7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvIlVOTfRaXa368fpO+z2gqStsJ5CwYSZkRXTH0/EfB96ubnVnX+kUVXhBnCxj2Q/
         wSObBbOoGqimJ3qU1kQcf7gxJ9zEDxQzYjnkW8rR3tdOasEO1mvEbPoZw0ur08FMhR
         eZnJW9YOu1NBeQLODul1lHiBm/rPH4F5agDEqw8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 55/69] sctp: fix sleep in atomic context bug in timer handlers
Date:   Mon,  1 Aug 2022 13:47:19 +0200
Message-Id: <20220801114136.701782781@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit b89fc26f741d9f9efb51cba3e9b241cf1380ec5a ]

There are sleep in atomic context bugs in timer handlers of sctp
such as sctp_generate_t3_rtx_event(), sctp_generate_probe_event(),
sctp_generate_t1_init_event(), sctp_generate_timeout_event(),
sctp_generate_t3_rtx_event() and so on.

The root cause is sctp_sched_prio_init_sid() with GFP_KERNEL parameter
that may sleep could be called by different timer handlers which is in
interrupt context.

One of the call paths that could trigger bug is shown below:

      (interrupt context)
sctp_generate_probe_event
  sctp_do_sm
    sctp_side_effects
      sctp_cmd_interpreter
        sctp_outq_teardown
          sctp_outq_init
            sctp_sched_set_sched
              n->init_sid(..,GFP_KERNEL)
                sctp_sched_prio_init_sid //may sleep

This patch changes gfp_t parameter of init_sid in sctp_sched_set_sched()
from GFP_KERNEL to GFP_ATOMIC in order to prevent sleep in atomic
context bugs.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://lore.kernel.org/r/20220723015809.11553-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/stream_sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 99e5f69fbb74..a2e1d34f52c5 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -163,7 +163,7 @@ int sctp_sched_set_sched(struct sctp_association *asoc,
 		if (!SCTP_SO(&asoc->stream, i)->ext)
 			continue;
 
-		ret = n->init_sid(&asoc->stream, i, GFP_KERNEL);
+		ret = n->init_sid(&asoc->stream, i, GFP_ATOMIC);
 		if (ret)
 			goto err;
 	}
-- 
2.35.1



