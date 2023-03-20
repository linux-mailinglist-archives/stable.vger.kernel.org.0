Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCD86C1699
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjCTPHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjCTPH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:07:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EC32FCF0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:02:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5859B61585
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648A8C433D2;
        Mon, 20 Mar 2023 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324571;
        bh=zW/pXyfoSc6I6H2lsuSoUJoriMOSxhvCwMU10yNX72o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBB8of5f6lgEIoicrgFo50w7Dh10L8blHXR3Dm6fMfNJHnlPzKgA7egO+Sqx+OUCj
         N8cQl4bthqwBSdSkiQbmluyU4DBYRvbgO9zzby211A5wFAdC26DzNQMzSOXX0FSrXO
         /0LCfEe/wKFbcHK49jKkNUIHAXk8AWgbwAVBbP90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "D. Wythe" <alibuda@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/99] net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()
Date:   Mon, 20 Mar 2023 15:53:57 +0100
Message-Id: <20230320145444.172512950@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit 22a825c541d775c1dbe7b2402786025acad6727b ]

When performing a stress test on SMC-R by rmmod mlx5_ib driver
during the wrk/nginx test, we found that there is a probability
of triggering a panic while terminating all link groups.

This issue dues to the race between smc_smcr_terminate_all()
and smc_buf_create().

			smc_smcr_terminate_all

smc_buf_create
/* init */
conn->sndbuf_desc = NULL;
...

			__smc_lgr_terminate
				smc_conn_kill
					smc_close_abort
						smc_cdc_get_slot_and_msg_send

			__softirqentry_text_start
				smc_wr_tx_process_cqe
					smc_cdc_tx_handler
						READ(conn->sndbuf_desc->len);
						/* panic dues to NULL sndbuf_desc */

conn->sndbuf_desc = xxx;

This patch tries to fix the issue by always to check the sndbuf_desc
before send any cdc msg, to make sure that no null pointer is
seen during cqe processing.

Fixes: 0b29ec643613 ("net/smc: immediate termination for SMCR link groups")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Link: https://lore.kernel.org/r/1678263432-17329-1-git-send-email-alibuda@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_cdc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 94503f36b9a61..9125d28d9ff5d 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -104,6 +104,9 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 	union smc_host_cursor cfed;
 	int rc;
 
+	if (unlikely(!READ_ONCE(conn->sndbuf_desc)))
+		return -ENOBUFS;
+
 	smc_cdc_add_pending_send(conn, pend);
 
 	conn->tx_cdc_seq++;
-- 
2.39.2



