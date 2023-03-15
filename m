Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC466BB22A
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjCOMdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjCOMd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:33:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC3510429
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5282661D26
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C393C433D2;
        Wed, 15 Mar 2023 12:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883543;
        bh=TaF1KHDUjsWtGvQLL8vjzm97oh8qj2p4XYNNXrqoO50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhePuWY/hJYK5XJ6AvnpoNLe5VBCvpWbfqW2nrj9YcL4dlhHqoH35nySz3x7jg3nC
         TYbHeydSc8uiuzNVM6wz+AadpLG5LNLcuhhEfRoQw4amLyAXUbmOqREdjDldjVwRLD
         A8CX5vdXMtcIJsecJ4qPYh+Zvt220eX5yNBtvffo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/143] fs: dlm: be sure to call dlm_send_queue_flush()
Date:   Wed, 15 Mar 2023 13:12:04 +0100
Message-Id: <20230315115741.670936435@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 7354fa4ef697191effedc2ae9a8293427708bbf5 ]

If we release a midcomms node structure, there should be nothing left
inside the dlm midcomms send queue. However, sometimes this is not true
because I believe some DLM_FIN message was not acked... if we run
into a shutdown timeout, then we should be sure there is no pending send
dlm message inside this queue when releasing midcomms node structure.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/midcomms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index b53d7a281be93..d976c2009b185 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1367,6 +1367,7 @@ static void midcomms_node_release(struct rcu_head *rcu)
 	struct midcomms_node *node = container_of(rcu, struct midcomms_node, rcu);
 
 	WARN_ON_ONCE(atomic_read(&node->send_queue_cnt));
+	dlm_send_queue_flush(node);
 	kfree(node);
 }
 
-- 
2.39.2



